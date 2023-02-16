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
    @State var inputQuantity = 0.0
    @State var measurement = ""
    
    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    var measurementUnitsList = [  "-",
                                  "g",
                                  "hg",
                                  "kg",
                                  "ml",
                                  "dl",
                                  "liter",
                                  "tsk",
                                  "msk",
                                  "st",
                                  "förpackning",
                                  "burk",
                                  "portion",
                                  "kruka"]
    
    
    var body : some View {
   

        ZStack {
            VStack{
                Spacer()
                TextField("Lägg till ny artikel och välj antal nedan", text: $userInput)
                    .multilineTextAlignment(.center)
                HStack {
                    Picker("Antal", selection: $inputQuantity)  {
                        ForEach(0..<1000) { number in
                            Text("\(number)")
                        }
                    }.pickerStyle(WheelPickerStyle())
                    
                    Picker("Mått", selection: $measurement)  {
                        ForEach(measurementUnitsList, id: \.self) { unit in
                            Text("\(unit)")
                        }
                    }.pickerStyle(WheelPickerStyle())
   

                }
                Spacer()
            }
        
            VStack{
                Spacer()
                    Button(action: {
                        if userInput != "" {
                            if let currentUser {
                            db.collection("users").document(currentUser.uid).collection("userItems").addDocument(data:  [
                                
                                "itemName" : userInput,
                                "isBought" : false,
                                "itemMeasurement" : measurement,
                                "itemQuantity" : inputQuantity.self
                                                                                                                        
                            ])}
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
}

                   
