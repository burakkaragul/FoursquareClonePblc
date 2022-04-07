//
//  AppDelegate.swift
//  FoursquareCloneParse
//
//  Created by Burak Karagül on 5.03.2022.
//


//      Burası uygulama açıldığı zaman ilk açılan ve hazırlıkların yapıldığı alan

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        

        
        //        Burada Back4app ile uygulamamız arasındaki bağlantıları yapıyoruz
        
        
        
        let configuration = ParseClientConfiguration {
          $0.applicationId = "VHi3hptrLAcWMN65fWE3I6ZPndek3s9K3IQDz1zJ"
          $0.clientKey = "xEaFZ237BymRdUlwxzSdOpyosjPZ7z557pRTH7zB"
          $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        
        
     
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

