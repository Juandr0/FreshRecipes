//
//  StartPageView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct StartPageView: View {

    @StateObject var recepies = RecepiesList()
    @State var isUserLoggedIn = false
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser


    var body: some View {
        
        if isUserLoggedIn  {
            TabView {
                RecepieView(recepies : recepies)
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("Recepies")
                    }
                  

                ShoppingListView(recepies : recepies)
                    .tabItem{
                        Image(systemName: "list.clipboard")
                        Text("Shopping list")
                    }
                   
                
                FavoriteView(recepies : recepies)
                    .tabItem{
                        Image(systemName: "heart")
                        Text("Favorites")
                    }
            }
        }
        else {
            LoadingScreen(isUserLoggedIn: $isUserLoggedIn)
        }
    }
    
    
    //struct StartPageView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        StartPageView()
    //    }
    //}
}
