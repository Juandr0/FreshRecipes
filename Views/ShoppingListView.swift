//
//  ShoppingListView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct ShoppingListView: View {
    
    @ObservedObject var recipes : ListOfRecipes
    
    var currentUser = Auth.auth().currentUser
    var db = Firestore.firestore()
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack {
                    if recipes.userItems.isEmpty {
                        Text("Här var det tomt.. \nLägg till saker i listan så visas de här!")
                            .foregroundColor(.gray)
                            .padding(.top, 250)
                    }
                    ItemsList(recipes : recipes,
                              db : db)
                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink(destination: AddRecipeItemsManuallyView(recipes: recipes)) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                            Text("Lägg till  ")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.bordered)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 25))
                    }
                }
            }
        }
    }
}

struct ItemsList : View {
    
    @State var showResetAlert = false
    @ObservedObject var recipes : ListOfRecipes
    
    var db : Firestore
    var currentUser = Auth.auth().currentUser
    
    var body : some View {
        List {
            ForEach(recipes.userItems){item in
                if !item.isBought{
                    HStack{
                        Image(systemName: "square")
                            .backgroundStyle(.white)
                            .padding(.trailing, 20)
                        Button(action: ({
                            if let currentUser {
                                let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                
                                docRef.document(item.id!).updateData([
                                    "isBought" : !item.isBought
                                ])
                            }
                        })){
                            HStack{
                                //If double ends with a "0" - display it as an int
                                Text(item.quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(item.quantity)) : String(item.quantity))
                                Text(item.measurement)
                                Spacer()
                                Text(item.name)
                            }
                        }
                    }
                }
            }
            .onDelete { indexSet in
                guard let user = Auth.auth().currentUser else { return }
                for index in indexSet {
                    let item = recipes.userItems[index]
                    if let id = item.id {
                        db.collection("users").document(user.uid)
                            .collection("userItems").document(id).delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error)")
                                } else {
                                    if recipes.userItems.isEmpty{
                                        deleteAllItems()
                                    }
                                }
                            }
                    }
                }
            }
            ForEach(recipes.userItems){ item in
                if item.isBought{
                    HStack{
                        Image(systemName: "checkmark.square")
                            .padding(.trailing, 20)
                        Button(action: ({
                            if let currentUser {
                                let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                docRef.document(item.id!).updateData([
                                    "isBought" : !item.isBought
                                ])
                            }
                        })){
                            HStack{
                                //If double ends with a "0" - display it as an int
                                Text(item.quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(item.quantity)) : String(item.quantity))
                                Text(item.measurement)
                                Spacer()
                                Text(item.name)
                            }
                            .strikethrough()
                        }
                        Spacer()
                            .backgroundStyle(.white)
                    }
                }
            }
            .onDelete { indexSet in
                guard let user = Auth.auth().currentUser else { return }
                for index in indexSet {
                    let item = recipes.userItems[index]
                    if let id = item.id {
                        db.collection("users").document(user.uid)
                            .collection("userItems").document(id).delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error)")
                                } else {
                                    if recipes.userItems.isEmpty{
                                        deleteAllItems()
                                    }
                                }
                            }
                    }
                }
            }
            .listRowBackground(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
        .listStyle(.inset)
        .navigationBarTitle("Inköpslista")
        .padding(.top, 20)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(trailing: Button(action:{
            self.showResetAlert = true
        }){
            Image(systemName: "trash.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
        })
        .alert(isPresented: $showResetAlert) {
            Alert(title: Text("Varning"), message: Text("\nÄr du säker att du vill radera alla varor i varukorgen?"), primaryButton: .destructive(Text("Radera")) {
                deleteAllItems()
                recipes.userItems.removeAll()
            }, secondaryButton: .cancel(Text("Avbryt")))
        }
    }
    
    func deleteAllItems(){
        
        if let currentUser {
            for recipeID in recipes.addedRecipeID {
                db.collection("users").document(currentUser.uid).collection("addedRecepieID").document(recipeID).delete()
            }
            
            for ingredientID in recipes.userItems {
                if let index = recipes.userItems.firstIndex(where: { $0.id == ingredientID.id }) {
                    if index >= 0 && index < recipes.userItems.count {
                        db.collection("users").document(currentUser.uid).collection("userItems").document(recipes.userItems[index].id!).delete()
                    } else {
                        print("Index out of range")
                    }
                } else {
                    print("Item not found")
                }
            }
            print("DeleteLoop FB ITEMS Complete")
        }
    }
}
