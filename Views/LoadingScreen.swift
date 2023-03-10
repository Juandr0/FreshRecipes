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
                           "Letar efter bläck till inköpslistan..",
                           ]
    

    @State var rotationAngle: Angle = .degrees(0)
    @State var loadingText: String = ""
    @Binding var isUserLoggedIn : Bool
    

    let rotationTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    let textTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    


    var body: some View {
        NavigationView{
            VStack {
                    Image("AppLogoFR")
                        .resizable()
                        .frame(width: 350, height: 350)
                    Text("Fresh Recipes")
                    .font(Font.custom("Hoefler Text Italic", size: 50))
                    .padding(.top, -80)
                
                Spacer()
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
                Spacer()
            }
            .onAppear {
                loadingText = loadingTextList.randomElement()!
                signInAnonymously()
                listenForAuthChanges()
            }
            .onDisappear{
                rotationTimer.upstream.connect().cancel()
                textTimer.upstream.connect().cancel()
            }
         
            
        }
      
    }

    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                print("Error signing in: \(error).  retrying..")
                signInAnonymously()
            }
        }
    }

    
    func listenForAuthChanges() {
        // Listen for authentication state changes
       Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // User is signed in
                print("LoadingScreen: User is signed in with uid:", user.uid)
                isUserLoggedIn = true
            } else {
                // User is signed out
                print("User is signed out")
            }
        }
    }
}






