//
//  RecepieView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth


struct FavoriteView: View {
    let db = Firestore.firestore()
    @ObservedObject var recepies : RecepiesList
    
    @State var searchQuery = ""
    @State var signedIn = false
    let currentUser = Auth.auth().currentUser
    
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(recepies.allRecepies) {recepie in
                            let recepieID = recepie.id
                            if recepies.favoriteItems.contains(recepieID ?? "0"){
                                NavigationLink(destination: RecepieInstructionView(recepies: recepies, currentRecepie: recepie)){
                                    DisplayFavoritesList(recepies: recepies, db: db, recepie: recepie)
                                }
                            }
                    }
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                }
                .listStyle(.plain)
            }
            .navigationTitle("Favoriter")
        }
    }
}
                    


struct DisplayFavoritesList: View{
    
    
    @ObservedObject var recepies : RecepiesList
    @State var isItemFavoriteMarked = false
    
    let currentUser = Auth.auth().currentUser
    let db : Firestore
    let recepie : Recepie
    

    var body : some View {

            Section {
                VStack {
                    HStack {
                        Text(recepie.name)
                        Spacer()
                        Spacer()
                        Image(systemName: "clock")
                        Text("\(recepie.cookingtimeMinutes) min")
                    }
                }
            }

        }
    
    
    func checkForFavorite() {
        isItemFavoriteMarked = recepies.favoriteItems.contains(recepie.id!)
    }
    
    
    }



