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
    
    @ObservedObject var recipes : ListOfRecipes
    @State var searchQuery = ""
    @State var signedIn = false
    
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(recipes.allRecipes) {recipe in
                        
                        let recipeID = recipe.id
                        
                        if recipes.favoriteItems.contains(recipeID ?? "0"){
                            NavigationLink(destination: RecipeInstructionView(recipes: recipes, currentRecipe: recipe)){
                                DisplayFavoritesList(recipes: recipes, db: db, recipe: recipe)
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
    
    @ObservedObject var recipes : ListOfRecipes
    @State var isItemFavoriteMarked = false
    
    let currentUser = Auth.auth().currentUser
    let db : Firestore
    let recipe : Recipe
    
    var body : some View {
        
        Section {
            ZStack{
                VStack {
                    HStack {
                        Text(recipe.name)
                        Spacer()
                        Spacer()
                        Image(systemName: "clock")
                        Text("\(recipe.cookingtimeMinutes) min")
                    }
                    AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
                    }
                    .frame(width: .none, height: 75)
                    .cornerRadius(5)
                }
            }
        }
    }
    
    func checkForFavorite() {
        isItemFavoriteMarked = recipes.favoriteItems.contains(recipe.id!)
    }
}
