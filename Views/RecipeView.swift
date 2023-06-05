//
//  RecipeView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

extension String {
    
    func toURL() -> URL? {
        return URL(string: self)
    }
}

struct RecipeView: View {
    
    @ObservedObject var recipes : ListOfRecipes
    
    var body: some View {
        NavigationView {
            VStack{
                SearchFilterView(recipes : recipes)
            }
        }
    }
}

struct ListOfRecipesView: View{
    
    @ObservedObject var recipes : ListOfRecipes
    @State var recipeIsAddedToDb = false
    @State var recipeIsFavouriteMarked = false
    @State var searchQuery = ""
    @State var itemExists = false
    
    let currentUser = Auth.auth().currentUser
    let db : Firestore
    let recipe : Recipe
    
    var body : some View {
        Section {
            VStack {
                HStack {
                    if recipeIsFavouriteMarked {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 15, height: 15)
                    }
                    Text(recipe.name)
                        .font(.title3)
                    Spacer()
                }
                HStack {
                    Button(action: {
                    }){
                        AsyncImage(url: URL(string: recipe.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "takeoutbag.and.cup.and.straw")
                        }
                        .frame(width: 200, height: 100)
                        .cornerRadius(5)
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "clock")
                            Text("\(recipe.cookingtimeMinutes) min")
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                //Removes item from cart
                                let searchString = recipe.id
                                if let currentUser {
                                    let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                    if recipes.addedRecipeID.contains(searchString!){
                                        for recipeItem in recipe.ingredientsAsItem! {
                                            if let userIndex = recipes.userItems.firstIndex(where: { $0.name == recipeItem.name }) {
                                                if userIndex < recipes.userItems.count {
                                                    let userItem = recipes.userItems[userIndex]
                                                    if userItem.quantity > recipeItem.quantity {
                                                        let newValue = userItem.quantity - recipeItem.quantity
                                                        db.collection("users").document(currentUser.uid).collection("userItems").document(userItem.id!).updateData([
                                                            "itemQuantity": newValue
                                                        ])
                                                        print("Det finns mer av \(recipeItem.name) än receptet, kvantiteten med \(String(describing: recipeItem.quantity))")
                                                    } else {
                                                        docRef.document(userItem.id!).delete()
                                                    }
                                                } else {
                                                    print("Index out of range")
                                                }
                                            } else {
                                                print("Item not found")
                                            }
                                        }
                                        print("DeleteLoop FB ITEMS Complete")
                                        
                                        if recipe.id != nil {
                                            db.collection("users").document(currentUser.uid).collection("addedRecipieID").document(recipe.id!).delete()
                                            recipeIsAddedToDb = false
                                            print("recipe ID removed from DB")
                                        } else {
                                            print("Error: recipe.id is nil")
                                        }
                                    }
                                    //Adds items to the cart
                                    else {
                                        
                                        let docRef = db.collection("users").document(currentUser.uid)
                                        docRef.collection("addedRecepieID").document(recipe.id!).setData([:])
                                        
                                        for recipeItem in recipe.ingredientsAsItem! {
                                            itemExists = recipes.checkIfItemIsAdded(searchWord: recipeItem.name.lowercased())
                                            if !itemExists {
                                                let newItem = Item(name: recipeItem.name,
                                                                   quantity: recipeItem.quantity,
                                                                   measurement: recipeItem.measurement,
                                                                   isBought: false)
                                                docRef.collection("userItems").document().setData([
                                                    
                                                    "itemMeasurement" : newItem.measurement,
                                                    "itemQuantity" : newItem.quantity,
                                                    "itemName" : newItem.name,
                                                    "isBought" : newItem.isBought
                                                ])
                                            } else {
                                                print("\(recipeItem.name) - Finns redan, adderar kvantiteten med \(String(describing: recipeItem.quantity))")
                                                
                                                for recipe in recipes.userItems {
                                                    if recipe.name.lowercased() == recipeItem.name.lowercased() {
                                                        let newValue = recipe.quantity + recipeItem.quantity
                                                        db.collection("users").document(currentUser.uid).collection("userItems").document(recipe.id!).updateData([
                                                            "itemQuantity" : newValue
                                                        ])
                                                    }
                                                }
                                                itemExists = false
                                            }
                                        }
                                        recipeIsAddedToDb = true
                                        print("added items Complete")
                                    }
                                }
                            }){
                                Image(systemName: recipeIsAddedToDb ? "minus.circle" : "cart")
                            }
                            
                            .frame(width: 50, height: 35)
                            .buttonStyle(.bordered)
                            .background(recipeIsAddedToDb ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 15))
                        }.onAppear{
                            checkForRecipe()
                            checkForFavorite()
                        }
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 20, trailing: 0))
    }
    
    func checkForRecipe() {
        recipeIsAddedToDb = recipes.addedRecipeID.contains(recipe.id!)
    }
    
    func checkForFavorite() {
        if currentUser != nil {
            let recipeID = recipe.id
            if recipes.favoriteItems.contains(recipeID ?? "0"){
                recipeIsFavouriteMarked = true
            } else {
                recipeIsFavouriteMarked = false
            }
        }
    }
}

struct SearchFilterView : View {
    
    @ObservedObject var recipes : ListOfRecipes
    @State var filterListExcluded = [String]()
    @State var filterQuery = ""
    @State var searchQuery = ""
    @State var isFilterViewCollapsed = true
    
    var db = Firestore.firestore()
    
    var body : some View {
        HStack {
            Text(isFilterViewCollapsed ? "Klicka här för att filtrera din sökning" : "Klicka här för att gömma dina filter")
                .onTapGesture {
                    self.isFilterViewCollapsed.toggle()
                }
            Image(systemName: "magnifyingglass" )
                .rotationEffect(.degrees(isFilterViewCollapsed ? 0 : 45))
                .animation(isFilterViewCollapsed ? .easeInOut(duration: 0.1)  : .default)
                .onTapGesture {
                    self.isFilterViewCollapsed.toggle()
                }
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
        if !isFilterViewCollapsed {
            VStack{
                HStack{
                    TextField("Skriv här för att lägga till ett nytt filter", text: $filterQuery)
                        .padding(.leading,20)
                    Spacer()
                    Button(action: {
                        if (filterQuery != "") {
                            filterListExcluded.append(filterQuery.lowercased())
                            filterQuery = ""
                        }
                    }){
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.red)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                    }
                    Spacer()
                }
                if (filterQuery != "" && filterListExcluded.isEmpty) {
                    Text("Skriv in sökordet och klicka på knappen för att exkludera ingredienser eller hela maträtter från din sökning. Skriv exempelvis 'fisk' eller 'flygande jacob'")
                        .foregroundColor(.gray)
                }
                List(){
                    if !filterListExcluded.isEmpty {
                        ForEach(filterListExcluded, id: \.self) {ingredient in
                            HStack{
                                Image(systemName: "hand.thumbsdown.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.red)
                                Text(ingredient.prefix(1).capitalized + ingredient.dropFirst())
                                Spacer()
                                Button(action: {
                                    filterListExcluded.removeAll(where: {$0 == ingredient})
                                }){
                                    Image(systemName: "minus.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }.listStyle(.inset)
                    .listRowBackground(Color.accentColor)
                Spacer()
            }.padding(.leading, 20)
        }
        List() {
            ForEach(recipes.allRecipes.filter {
                //Filters what's displayed by using the searchQuery. I.e: User types "kyckling" in the searchbar and since it gets a match in the ingredientslist of 'flygande jacob', it will display this dish
                self.searchQuery.isEmpty ? true :
                $0.name.localizedCaseInsensitiveContains(self.searchQuery) || $0.ingredients.description.localizedCaseInsensitiveContains(self.searchQuery) || $0.allergenics.description.localizedCaseInsensitiveContains(self.searchQuery)
            }, id: \.self) {recipe in
                
                //Recepies that contains filtered out words is removed here
                if (!recipe.allergenics.contains(where: { filterListExcluded.contains($0) }) && !recipe.ingredients.contains(where: { filterListExcluded.contains($0) }) &&
                    !filterListExcluded.contains(recipe.name.lowercased()))
                {
                    //Displays the recepies
                    NavigationLink(destination: RecipeInstructionView(recipes: recipes, currentRecipe: recipe)){
                        ListOfRecipesView(recipes: recipes, db: db, recipe: recipe)
                    }
                    .navigationTitle("Recept")
                }
            }
        }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            .listStyle(.inset)
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always) , prompt: "Sök på maträtter eller ingredienser")
    }
}
