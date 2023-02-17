//
//  LoadingScreen.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-16.
//

import SwiftUI

import Firebase
import FirebaseAuth

struct LoadingScreen: View {

    var loadingTextList = ["Kocken slipar sina knivar..",
                           "Hämtar färska grönsaker..",
                           "Jagar ut Ernst Kirchsteiger från köket..",
                           "Letar efter kokboken..",
                           "Startar ugnen..",
                           "Konsulterar med fjolårets mästerkock..",
                           "Letar efter kockmössan..",
                           "Letar efter bläck till inköpslistan..",
                           ]
    

    @State var rotationAngle: Angle = .degrees(0)
    @State var loadingText: String = ""
    @Binding var isUserLoggedIn : Bool
    

    let rotationTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    let textTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    let loginTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let currentUser = Auth.auth().currentUser
    


    var body: some View {
        NavigationView{
            VStack {
                Image(systemName: "circle.dashed")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .rotationEffect(rotationAngle)
                    .onReceive(rotationTimer) { _ in
                        rotationAngle += .degrees(1)
                    }
                
                
                Text(loadingText)
                    .onReceive(textTimer) { _ in
                        loadingText = loadingTextList.randomElement()!
                    }
                    .padding(.top, 10)
                    .animation(.default, value: 5)
            }
            .onAppear {
                loadingText = loadingTextList.randomElement()!
                listenForAuthChanges()
            }
            .onDisappear{
                rotationTimer.upstream.connect().cancel()
                textTimer.upstream.connect().cancel()
                loginTimer.upstream.connect().cancel()
            }
            .onReceive(loginTimer) { _ in
                retryLogin()
            }
            
        }
      
    }


    func retryLogin() {
        if !isUserLoggedIn {
            Auth.auth().signInAnonymously { authResult, error in

            }
        }
    }
    
    func listenForAuthChanges() {
        // Listen for authentication state changes
       Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // User is signed in
                print("User is signed in with uid:", user.uid)
                isUserLoggedIn = true
            } else {
                // User is signed out
                print("User is signed out")
            }
        }
    }
}






