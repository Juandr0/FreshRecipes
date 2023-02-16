//
//  NewShoppingListView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-16.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct NewShoppingListView: View {
    @ObservedObject var recepies : RecepiesList
    @State var showResetAlert = false
    var currentUser = Auth.auth().currentUser
    var db = Firestore.firestore()
    
    
    var body : some View {
        VStack{
            ForEach(recepies.allRecepies) { recipe in
                if let ingredients = recipe.ingredientsAsItem {
                    ForEach(ingredients) { item in
                        Text("\(item.itemName)")
                    }
                }
            }
        }
        
     

//        NavigationView {
//            ZStack{
//                VStack {
//                    List {
//                        ForEach(recepies.userItems){item in
//                            if !item.isBought{
//                                HStack{
//                                    Image(systemName: "square")
//                                        .backgroundStyle(.white)
//                                        .padding(.trailing, 20)
//                                    Button(item.itemName, action: ({
//                                        if let currentUser {
//                                            let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
//
//
//                                            docRef.document(item.id!).updateData([
//                                                "isBought" : !item.isBought
//                                            ])
//                                        }
//                                    }))
//                                    Spacer()
//
//                                }
//                            }
//                        }.onDelete { indexSet in
//                            guard let user = Auth.auth().currentUser else { return }
//                            for index in indexSet {
//                                let item = recepies.userItems[index]
//                                if let id = item.id {
//                                    db.collection("users").document(user.uid)
//                                        .collection("userItems").document(id).delete { error in
//                                            if let error = error {
//                                                print("Error deleting document: \(error)")
//                                            } else {
//                                                if recepies.userItems.isEmpty{
//                                                    deleteAllItems()
//                                                }
//                                            }
//                                        }
//                                }
//                            }
//                        }
//
//                        ForEach(recepies.userItems){ item in
//                            if item.isBought{
//                                HStack{
//                                    Image(systemName: "checkmark.square")
//                                        .padding(.trailing, 20)
//                                    Button(item.itemName, action: ({
//                                        if let currentUser {
//                                            let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
//                                            docRef.document(item.id!).updateData([
//                                                "isBought" : !item.isBought
//                                            ])
//                                        }
//                                    }))
//                                    .strikethrough()
//                                    Spacer()
//                                        .backgroundStyle(.white)
//                                }
//                            }
//                        }
//                        .onDelete { indexSet in
//                            guard let user = Auth.auth().currentUser else { return }
//                            for index in indexSet {
//                                let item = recepies.userItems[index]
//                                if let id = item.id {
//                                    db.collection("users").document(user.uid)
//                                        .collection("userItems").document(id).delete { error in
//                                            if let error = error {
//                                                print("Error deleting document: \(error)")
//                                            } else {
//                                                if recepies.userItems.isEmpty{
//                                                    deleteAllItems()
//                                                }
//                                            }
//                                        }
//                                }
//                            }
//                        }
//                        .listRowBackground(Color(red: 0.3, green: 0.3, blue: 0.3))
//                    }//List end
//                    .listStyle(.inset)
//                        .navigationBarTitle("Inköpslista")
//                        .padding(.top, 20)
//                        .navigationBarTitleDisplayMode(.large)
//
//
//
//                        .navigationBarItems(trailing: Button(action:{
//                            self.showResetAlert = true
//                        }){
//                            Image(systemName: "trash.circle")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .foregroundColor(.red)
//
//                        })
//                        .alert(isPresented: $showResetAlert) {
//                            Alert(title: Text("Varning"), message: Text("\nÄr du säker att du vill radera alla varor i varukorgen?"), primaryButton: .destructive(Text("Radera")) {
//                                deleteAllItems()
//                                recepies.userItems.removeAll()
//                            }, secondaryButton: .cancel(Text("Avbryt")))
//                          }
//
//
//
//                    } //VStack end
//                VStack{
//                    Spacer()
//                        HStack{
//                            Spacer()
//
//
//                            NavigationLink(destination: AddRecepieItemsManuallyView()) {
//                                Image(systemName: "plus.circle")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(.white)
//                                Text("Lägg till  ")
//                                    .foregroundColor(.white)
//                                }
//                                .buttonStyle(.bordered)
//                                .background(Color.gray)
//                                .cornerRadius(15)
//                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 25))
//
//
//                        }
//                    }
//                } //ZStack end
//        }
    }
    
    
        func deleteAllItems(){
            if let currentUser {
                for recepieID in recepies.addedRecepieID {
                    db.collection("users").document(currentUser.uid).collection("addedRecepieID").document(recepieID).delete()
                }
                
                for ingredientID in recepies.userItems {
                    if let index = recepies.userItems.firstIndex(where: { $0.id == ingredientID.id }) {
                        if index >= 0 && index < recepies.userItems.count {
                            db.collection("users").document(currentUser.uid).collection("userItems").document(recepies.userItems[index].id!).delete()
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
    


//struct NewShoppingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewShoppingListView()
//    }

