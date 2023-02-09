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
    @StateObject var recepies = RecepiesList()
    var currentUser = Auth.auth().currentUser
    
    var db = Firestore.firestore()
    
    
    var body: some View {
        
        //Ersätt lista med en forEach direkt för att göra listan dymanisk
        //Alternativt hitta ngn funktion som tar in en int som begränsar och sätt den till list.size
        
        NavigationView {
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
                    } .foregroundColor(.green)
                  
                    
                }.listStyle(.inset)
                    .navigationTitle("Inköpslista")
                   
            }
            }

        }
        
    }

        
    

    
    








struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
