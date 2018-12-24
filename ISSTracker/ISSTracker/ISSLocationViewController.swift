//
//  ISSLocationViewController.swift
//  ISSTracker
//
//  Created by Brent Piephoff on 12/24/18.
//  Copyright © 2018 Brent P. All rights reserved.
//

import UIKit

class ISSLocationViewController: UIViewController {

    var latestLocation: IssLocationQuery.Data.IssLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateISSLocation()
    }
    
    private func updateISSLocation() {
        apollo.fetch(query: IssLocationQuery()) { result, error in
            if let issLocation = result?.data?.issLocation {
                self.latestLocation = issLocation
            }
        }
    }

}
