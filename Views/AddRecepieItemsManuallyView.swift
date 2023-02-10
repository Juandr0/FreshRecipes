//
//  AddRecepieItemsManuallyView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-09.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct AddRecepieItemsManuallyView: View {
    @Environment(\.dismiss) var dismiss
    @State var userInput = ""
    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    var body : some View {
        VStack{
            Spacer()
            HStack {
         
                TextField("Lägg till ny artikel", text: $userInput)
                    .multilineTextAlignment(.center)
            }
            Spacer()
           
        
            Button(action: {
                if userInput != "" {
                    if let currentUser {
                        db.collection("users").document(currentUser.uid).collection("userItems").addDocument(data:  [        "itemName" : userInput,
                               "isBought" : false ])
                    }
                }
                
                userInput = ""
                dismiss()

            }){
                HStack {
                    Spacer()
                    if userInput != ""{
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
                    }
                  
                   
                }
              
            }
            
              
            
        }
    }
}

                   
