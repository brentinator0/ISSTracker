//
//  AppDelegate.swift
//  ISSTracker
//
//  Created by Brent Piephoff on 12/23/18.
//  Copyright © 2018 Brent P. All rights reserved.
//

import UIKit
import Apollo
import ApolloWebSocket

//let apollo = ApolloClient(url: URL(string: "https://api.graph.cool/simple/v1/cjq22o07gah3e0134jeaf6cu5")!)

var apollo: ApolloClient = {
    // Leave auth stuff here for later
    let authPayloads = [
        "Authorization": "Bearer "
    ]
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = authPayloads

    let map: GraphQLMap = authPayloads
    let wsEndpointURL = URL(string: "wss://subscriptions.us-west-2.graph.cool/v1/cjq22o07gah3e0134jeaf6cu5")!
    let endpointURL = URL(string: "https://api.graph.cool/simple/v1/cjq22o07gah3e0134jeaf6cu5")!
    
    var request = URLRequest(url: wsEndpointURL)
    request.setValue("<my_key>", forHTTPHeaderField: "X-Hasura-Access-Key")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    

    let websocket = WebSocketTransport(request: request, sendOperationIdentifiers: false)

    let splitNetworkTransport = SplitNetworkTransport(
        httpNetworkTransport: HTTPNetworkTransport(
            url: endpointURL,
            configuration: configuration
        ),
        webSocketNetworkTransport: websocket
    )
    return ApolloClient(networkTransport: splitNetworkTransport)
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

