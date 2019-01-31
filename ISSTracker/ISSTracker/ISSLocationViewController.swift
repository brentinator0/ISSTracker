//
//  ISSLocationViewController.swift
//  ISSTracker
//
//  Created by Brent Piephoff on 12/24/18.
//  Copyright © 2018 Brent P. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import MapboxGeocoder
import MessageKit

class ISSLocationViewController: UIViewController {
    
    private var trackedCoordinates = [CLLocationCoordinate2D]()
    private let centerAnnotation = MGLPointAnnotation()
    private var mapView = generateMapView()
    private var timer = Timer()
    
    // View Models
    private var chatViewModel: ChatViewModel?
    
    // User Location Tracking
    private var currentUserLocation: UserLocation?
    private var geocoder: Geocoder!
    private var geocodingDataTask: URLSessionDataTask?
    
    // Custom Text View
    private var inputToolbar: UIView!
    private var textView: ChatInputTextView!
    private var textViewBottomConstraint: NSLayoutConstraint!
    
    private var locatedISS = false
    
    private let tableContentInsetBottom: CGFloat = 20.0
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = -keyboardHeight - 8
            view.layoutIfNeeded()
        }
    }
    
    @objc private func tapGestureHandler() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        
        configureMapView()
        configureGeocoder()
        scheduledTimerWithTimeInterval()
        configureViewModels()
                
        // *** Create Toolbar
        inputToolbar = UIView()
        inputToolbar.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputToolbar)
        
        // *** Create GrowingTextView ***
        textView = ChatInputTextView()
        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        textView.maxLength = 200
        textView.maxHeight = 70
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = "Say something..."
        textView.placeholderColor = UIColor(white: 0.8, alpha: 1.0)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.returnKeyType = UIReturnKeyType.done
        
        inputToolbar.addSubview(textView)
        
        // *** Autolayout ***
        let topConstraint = textView.topAnchor.constraint(equalTo: inputToolbar.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topConstraint
            ])
        
        textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: inputToolbar.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            textViewBottomConstraint,
            tableViewBottomConstraint
            ])
        
        // Listen to keyboard show / hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Hide keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        updateTableContentInset(forTableView: tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: This is currently a "hack" to set the chat table bottom constraint correctly, will fix later
        guard let window = UIApplication.shared.keyWindow else { return }
        let bottomPadding = window.safeAreaInsets.bottom
        tableViewBottomConstraint.constant = inputToolbar.frame.height - bottomPadding
    }
    
    func updateTableContentInset(forTableView tv: UITableView) {
        let numSections = tv.numberOfSections
        var contentInsetTop = tv.bounds.size.height
        
        for section in 0..<numSections {
            let numRows = tv.numberOfRows(inSection: section)
            let sectionHeaderHeight = tv.rectForHeader(inSection: section).size.height
            let sectionFooterHeight = tv.rectForFooter(inSection: section).size.height
            contentInsetTop -= sectionHeaderHeight + sectionFooterHeight
            for i in 0..<numRows {
                let rowHeight = tv.rectForRow(at: IndexPath(item: i, section: section)).size.height
                contentInsetTop -= rowHeight
                if contentInsetTop <= 0 {
                    contentInsetTop = 0
                    break
                }
            }
            // Break outer loop as well if contentInsetTop == 0
            if contentInsetTop == 0 {
                break
            }
        }
        tv.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: tableContentInsetBottom, right: 0)
    }
    
    func reloadTable() {
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let point = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height + self.tableContentInsetBottom)
            self.tableView.setContentOffset(point, animated: true)
        }

    }
    
    private static func generateMapView() -> MGLMapView {
        let url = URL(string: "mapbox://styles/bbpiepho/cjq277dqq304m2rqjwlu5ot97")
        let map = MGLMapView(frame: .zero, styleURL: url)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return map
    }
    
    private func configureMapView() {
        mapView.frame = self.view.bounds
        mapView.delegate = self
        
        // Set mapview.showsUserLocation initially to "true" to trigger mapbox into getting the user's location once
        mapView.showsUserLocation = true
        
        self.view.insertSubview(mapView, belowSubview: tableView)
        self.mapView.addAnnotation(self.centerAnnotation)
    }
    
    private func configureGeocoder() {
        geocoder = Geocoder.shared
    }
    
    private func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateISSLocation), userInfo: nil, repeats: true)
    }
    
    @objc private func updateISSLocation() {
        apollo.fetch(query: IssLocationQuery(), cachePolicy: .returnCacheDataAndFetch) { result, error in
            guard let issLocation = result?.data?.issLocation else { return }
            guard let long = issLocation.longitude, let lat = issLocation.latitude else { return }
            guard let doubleLong = Double(long), let doubleLat = Double(lat) else { return }
            self.locatedISS = true

            let coordinate = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong)
            
            self.trackedCoordinates.append(coordinate)
            let line = MGLPolyline(coordinates: &self.trackedCoordinates, count: UInt(self.trackedCoordinates.count))

            self.mapView.addAnnotation(line)

            print("Latest Coordinates: lat:\(doubleLat) long:\(doubleLong)")
            self.mapView.setCenter(coordinate, zoomLevel: 3.0, animated: true)
            self.centerAnnotation.coordinate = self.mapView.centerCoordinate
        }
    }
    
    private func configureViewModels() {
        chatViewModel = ChatViewModel()
        chatViewModel?.initFetch()
        
        chatViewModel?.reloadTableViewClosure = { [unowned self] () in
            DispatchQueue.main.async {
                self.reloadTable()
            }
        }
    }
}

extension ISSLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = chatViewModel else { return 0 }
        return vm.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatMessageCellID", for: indexPath) as! ChatMessageTableViewCell
        let cellData = self.chatViewModel?.getCellData(at: indexPath)
        cell.messageLabel.text = cellData?.messageText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

extension ISSLocationViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {        
        // Set mapview.showsUserLocation to "false" here to prevent additional queries to the user's location
        mapView.showsUserLocation = false

        guard let userCoordinates = mapView.userLocation?.coordinate else { return }
        
        if currentUserLocation == nil {
            let options = ReverseGeocodeOptions(coordinate: userCoordinates)
            geocodingDataTask = geocoder.geocode(options) { [unowned self] (placemarks, attribution, _) in
                
                if let placemarks = placemarks, !placemarks.isEmpty {
                    guard let placemark = placemarks.first else {
                        return
                    }

                    guard let countryCode = placemark.country?.code else { return }
                    self.currentUserLocation = UserLocation(coordinates: userCoordinates, countryCode: countryCode)
                }
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        let imageName = "ISS"
        let reuseIdentifier = imageName
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as! ISSAnnotationView?
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = ISSAnnotationView(reuseIdentifier: reuseIdentifier, image: UIImage(named: imageName)!)
        }
        
        annotationView?.rotateImageView()
        
        //annotationView?.isHidden = !locatedISS
        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .red
    }
}

extension ISSLocationViewController : GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: ChatInputTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        
        if text.count == 1 && resultRange != nil {

            if let userLoc = currentUserLocation {
                let cm = ChatMessage(text: textView.text, chatLocation: ChatMessage.ChatLocation(latitude: String(userLoc.coordinates.latitude),
                                                                                        longitude: String(userLoc.coordinates.longitude),
                                                                                        countryCode: userLoc.countryCode))
                chatViewModel?.createMessage(cm)
            }
            
            // Clear the textView text and dismiss the keyboard
            textView.text = ""
            textView.resignFirstResponder()
            
            return false
        }
        return true
    }
}

class ChatMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
}

class ISSAnnotationView: MGLAnnotationView {
    var imageView: UIImageView!
    
    required init(reuseIdentifier: String?, image: UIImage) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.imageView = UIImageView(image: image)
        self.addSubview(self.imageView)
        self.frame = self.imageView.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func rotateImageView() {
        let duration: TimeInterval = 50
        let angle: CGFloat = .pi / 2.0
        let transform = imageView.transform.rotated(by: angle)
        
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.imageView.transform = transform
        })
    }
}

private struct UserLocation {
    let coordinates: CLLocationCoordinate2D
    let countryCode: String
}

