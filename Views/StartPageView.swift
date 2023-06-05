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
    
    @State var isUserLoggedIn = false
    let db = Firestore.firestore()
    
    var body: some View {
        if isUserLoggedIn  {
            NavigationTabView()
        }
        else {
            LoadingScreen(isUserLoggedIn: $isUserLoggedIn)
        }
    }
}

struct NavigationTabView : View {
    
    @StateObject var recipes = ListOfRecipes()
    let currentUser = Auth.auth().currentUser
    
    var body : some View {
        TabView {
            RecipeView(recipes : recipes)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Recept")
                }
            ShoppingListView(recipes : recipes)
                .tabItem{
                    Image(systemName: "list.clipboard")
                    Text("Inköpslista")
                }
            FavoriteView(recipes : recipes)
                .tabItem{
                    Image(systemName: "heart")
                    Text("Favoriter")
                }
        }.tint(.orange)
    }
}
