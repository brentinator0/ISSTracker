//
//  ISSLocationChatViewModel.swift
//  ISSTracker
//
//  Created by Brent Piephoff on 12/27/18.
//  Copyright © 2018 Brent P. All rights reserved.
//

import Foundation

class ChatViewModel {
    private var chatMessages = [ChatMessage]()
    private var cellDataModels: [ChatMessageCellData] = [ChatMessageCellData]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    // MARK: Binding closures
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    // MARK: Configuration
    func initFetch() {
        self.isLoading = true
        apollo.fetch(query: RetreiveLastMessagesQuery(numOfMessages: 3), cachePolicy: .returnCacheDataAndFetch) { result, error in
            guard let messages = result?.data?.allMessages else { return }
            self.processFetchedMessages(messages: messages)
            self.configureChatSubscription()
        }
    }
    
    private func configureChatSubscription() {
        apollo.subscribe(subscription: CreateMessageSubscription()) { result, error in
            if let result = result {
                guard let message = result.data?.message else { return }
                self.processSubscribedMessages(message: message)
            }
        }
    }
    
    // MARK: TableView Helper Functions
    var numberOfCells: Int {
        return cellDataModels.count
    }
    
    func getCellData(at indexPath: IndexPath ) -> ChatMessageCellData {
        return cellDataModels[indexPath.row]
    }
    
    // MARK: Data Processing
    func createCellDataModel(cm: ChatMessage) -> ChatMessageCellData {
        return ChatMessageCellData(messageText: cm.text, latitude: cm.chatLocation.latitude, longitude: cm.chatLocation.longitude, countryCode: cm.chatLocation.countryCode)
    }
    
    private func processFetchedMessages(messages: [RetreiveLastMessagesQuery.Data.AllMessage]) {
        var msgs = [ChatMessage]()
        for msg in messages {
            let cmLoc = ChatMessage.ChatLocation(latitude: msg.location.latitude, longitude: msg.location.longitude, countryCode: msg.location.country)
            let cm = ChatMessage(text: msg.text, chatLocation: cmLoc)
            msgs.append(cm)
            
            self.cellDataModels.append(createCellDataModel(cm: cm))
        }
        self.chatMessages = msgs
    }
    
    private func processSubscribedMessages(message: CreateMessageSubscription.Data.Message) {
        guard let location = message.node?.location else { return }
        guard let text = message.node?.text else { return }
        
        let cmLoc = ChatMessage.ChatLocation(latitude: location.latitude, longitude: location.longitude, countryCode: location.country)
        let cm = ChatMessage(text: text, chatLocation: cmLoc)
        self.chatMessages.append(cm)
        self.cellDataModels.append(createCellDataModel(cm: cm))
    }
}

struct ChatMessageCellData {
    let messageText: String
    let latitude: Double
    let longitude: Double
    let countryCode: String
}

struct ChatMessage {
    let text: String
    let chatLocation: ChatLocation
    
    struct ChatLocation {
        let latitude: Double
        let longitude: Double
        let countryCode: String
    }
}
