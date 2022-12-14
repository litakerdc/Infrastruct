//
//  InfrastructApp.swift
//  Infrastruct
//
//  This serves as our "configuration page", it is where our App is first launched from and passes our enviormentObjects to our views.
//
//  Created by devadmin on 9/19/22.
//

import RealmSwift
import SwiftUI
import Firebase

@main
struct InfrastructApp: SwiftUI.App {
    @StateObject var dataManager = DataManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            
            //Show our app, and pass references to our Authentication viewModel and our Database dataManager enviormentObjects.
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(dataManager)
             
        }
    }
}
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                         [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            FirebaseApp.configure()
            
            return true
        }
    }
