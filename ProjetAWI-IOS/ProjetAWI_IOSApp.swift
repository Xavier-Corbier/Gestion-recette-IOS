//
//  ProjetAWI_IOSApp.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI
import Firebase


@main
struct ProjetAWI_IOSApp: App {
    
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
    
    init(){
        FirebaseApp.configure()
        
        
    }
}
