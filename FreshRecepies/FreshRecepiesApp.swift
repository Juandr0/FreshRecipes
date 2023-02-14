//
//  FreshRecepiesApp.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct FreshRecepiesApp: App {

    
    init() {
        FirebaseApp.configure()
        Auth.auth().signInAnonymously { authResult, error in
            
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            StartPageView()
//            RecepieView()
        }
    }
}
