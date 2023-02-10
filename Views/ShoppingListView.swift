//
//  ShoppingListView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-24.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct ShoppingListView: View {
    @ObservedObject var recepies : RecepiesList
    var currentUser = Auth.auth().currentUser
    
    var db = Firestore.firestore()
    
    
    var body: some View {
        
        //Ersätt lista med en forEach direkt för att göra listan dymanisk
        //Alternativt hitta ngn funktion som tar in en int som begränsar och sätt den till list.size
        
        NavigationView {
            ZStack{
                VStack {
                    List {
                        ForEach(recepies.userItems){item in
                            if !item.isBought{
                                HStack{
                                    Button(item.itemName, action: ({
                                        if let currentUser {
                                            let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                            docRef.document(item.id!).updateData([
                                                "isBought" : !item.isBought
                                            ])
                                        }
                                    }))
                                    Spacer()
                                    Image(systemName: "square")
                                        .backgroundStyle(.white)
                                }
                            }
                        }.onDelete() {indexSet in
                            for index in indexSet{
                                guard let user = Auth.auth().currentUser else {return}
                                let item = recepies.userItems[index]
                                if let id = item.id {
                                    db.collection("users").document(user.uid)
                                        .collection("userItems").document(id).delete()
                                }
                            }
                            if (recepies.userItems.isEmpty){
                                for recepieID in recepies.addedRecepieID {
                                    db.collection("users").document(currentUser!.uid).collection("addedRecepieID").document(recepieID).delete()
                                }
                            }
                            
                        }
                        
                        ForEach(recepies.userItems){ item in
                            if item.isBought{
                                HStack{
                                    Button(item.itemName, action: ({
                                        if let currentUser {
                                            let docRef = db.collection("users").document(currentUser.uid).collection("userItems")
                                            docRef.document(item.id!).updateData([
                                                "isBought" : !item.isBought
                                            ])
                                        }
                                        
                                    }))
                                    .strikethrough()
                                    Spacer()
                                    Image(systemName: "checkmark.square")
                                        .backgroundStyle(.white)
                                    
                                }
                            }
                        }
                        .onDelete() {indexSet in
                            guard let user = Auth.auth().currentUser else {return}
                            for index in indexSet{
                                let item = recepies.userItems[index]
                                if let id = item.id {
                                    db.collection("users").document(user.uid)
                                        .collection("userItems").document(id).delete()
                                }
                            }
                            if (recepies.userItems.isEmpty){
                                for recepieID in recepies.addedRecepieID {
                                    db.collection("users").document(currentUser!.uid).collection("addedRecepieID").document(recepieID).delete()
                                }
                            }
                        }
                        .foregroundColor(.green)
                        
                        
                        
                    }//List end
                
                    .listStyle(.inset)
                        .navigationBarTitle("Inköpslista")
                        .navigationBarItems(trailing: NavigationLink(destination: AddRecepieItemsManuallyView()) {
                            HStack {
                                Text("Lägg till")
                                Image(systemName: "plus.circle")
                            }
                            
                        })
          
                        NavigationLink(destination: AddRecepieItemsManuallyView()){
                            HStack{
                                Spacer()
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
                            }
                        }     
                    } //VStack end
                } //ZStack end
            }

        }
    }

        
    

