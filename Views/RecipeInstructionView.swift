//
//  RecepieInstructionView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-06.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct RecipeInstructionView: View {
    
    @ObservedObject var recipes : ListOfRecipes
    @State var isCollapsed = true
    @State var recipeIsFavouriteMarked = false
    
    let currentRecipe : Recipe
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var body : some View {
        
        VStack {
            HStack {
                Text("\(currentRecipe.name)")
                    .font(.title)
                    .padding(.leading, 20)
                Spacer()
            }
            ZStack{
                AsyncImage(url: URL(string: currentRecipe.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "takeoutbag.and.cup.and.straw")
                }
                .frame( height: 150)
                .cornerRadius(5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                VStack{
                    FavoriteMark(recipes : recipes,
                                 recipeIsFavouriteMarked : $recipeIsFavouriteMarked,
                                 currentRecipe: currentRecipe)
                }
            }
            VStack{
                HStack {
                    Spacer()
                    Text("Allergiinformation")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.isCollapsed.toggle()
                        }
                    Image(systemName: "triangle.tophalf.filled" )
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(isCollapsed ? 90 : 180))
                        .animation(isCollapsed ? .easeInOut(duration: 0.1)  : .default)
                        .onTapGesture {
                            self.isCollapsed.toggle()
                        }
                    Spacer()
                    HStack {
                        Image(systemName: "clock")
                        Text("\(currentRecipe.cookingtimeMinutes) min")
                    } .padding(.trailing, 20)
                }
            }
            
            if !isCollapsed {
                ForEach (currentRecipe.allergenics, id: \.self) { text in
                    HStack{
                        Spacer()
                        Text(text)
                        Spacer()
                    }
                }
            }
        }
        List (currentRecipe.instructions, id: \.self) {text in
            Text(text)
        }.listStyle(.plain)
    }
}

struct FavoriteMark : View {
    @ObservedObject var recipes : ListOfRecipes
    @Binding var recipeIsFavouriteMarked : Bool
    let db = Firestore.firestore()
    let currentRecipe : Recipe
    let currentUser = Auth.auth().currentUser
    
    var body : some View {
        HStack{
            Spacer()
            Button(action: {
                
                if let currentUser {
                    recipeIsFavouriteMarked = !recipeIsFavouriteMarked
                    let docRef = db.collection("users").document(currentUser.uid).collection("favorites").document(currentRecipe.id!)
                    
                    if recipeIsFavouriteMarked {
                        docRef.setData([:])
                        recipeIsFavouriteMarked = true
                    } else {
                        docRef.delete()
                        recipeIsFavouriteMarked = false
                        recipes.favoriteItems.removeAll(where: {$0 == currentRecipe.id})
                    }
                }
            }) {
                Image(systemName: recipeIsFavouriteMarked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .topTrailing)
                    .foregroundColor(.red)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 145, trailing: 0))
            }
            .contentShape(Rectangle())
        }.onAppear{
            checkForFavorite()
        }
    }
    
    func checkForFavorite() {
        if currentUser != nil {
            let recipeID = currentRecipe.id
            if recipes.favoriteItems.contains(recipeID ?? "0"){
                recipeIsFavouriteMarked = true
            }
        }
    }
}
