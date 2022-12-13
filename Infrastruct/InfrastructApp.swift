//
//  InfrastructApp.swift
//  Infrastruct
//
//  Created by devadmin on 9/19/22.
//

import RealmSwift
import SwiftUI
import Firebase
//import RealmSwift

//let app = ReamSwift.App(id: "rchat-jihmd")

@main
struct InfrastructApp: SwiftUI.App {
    @StateObject var dataManager = DataManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            /**
            ListView()
                .environmentObject(dataManager)
             **/
            //IF WANT TO SEE DB PROOF OF CONCEPT, COMMENT NEXT 3 LINES OUT AND UNCOMMENT TOP TWO LINES.
            let viewModel = AppViewModel()
            
            
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
