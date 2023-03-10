//
//  AddRecepieItemsManuallyView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-09.
//

import Combine
import SwiftUI
import Firebase
import FirebaseAuth


struct AddRecepieItemsManuallyView: View {
    @ObservedObject var recepies : RecepiesList
    @State var userInput = ""
    @State var inputQuantity : Double = 1.0
    @State var measurement = "st"
    @State var doesItemExist = false
    

    var currentUser = Auth.auth().currentUser
 

    
  
    
    var body : some View {
        ZStack {
            VStack{
                Spacer()
                TextField("Lägg till ny artikel och välj antal nedan", text: $userInput)
                    .multilineTextAlignment(.center)
                HStack {
                    ItemQuantityPicker(inputQuantity: $inputQuantity)
                    MeasurementPicker(userInput : $userInput,
                                      measurement : $measurement,
                                      recepies : recepies )
                }
                Spacer()
            }
            UpdateAndAddItems(recepies : recepies,
                              userInput: $userInput,
                              inputQuantity: $inputQuantity,
                              measurement: $measurement,
                              doesItemExist: $doesItemExist)
        }
    }
}


struct UpdateAndAddItems : View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var recepies : RecepiesList
    @Binding var userInput : String
    @Binding var inputQuantity : Double
    @Binding var measurement : String
    @Binding var doesItemExist : Bool

    var db = Firestore.firestore()
    var currentUser = Auth.auth().currentUser
    
    var body : some View {
        VStack{
            Spacer()
            Button(action: {
                if userInput != "" {
                    if let currentUser {
                        doesItemExist = recepies.checkIfItemIsAdded(searchWord: userInput.lowercased())
                        if !doesItemExist {
                            db.collection("users").document(currentUser.uid).collection("userItems").addDocument(data:  [
                                "itemName" : userInput.lowercased(),
                                "isBought" : false,
                                "itemMeasurement" : measurement,
                                "itemQuantity" : inputQuantity
                            ])
                        } else {
                            print("Finns redan, adderar kvantiteten istället")

                            for recipe in recepies.userItems {
                                if recipe.itemName.lowercased() == userInput.lowercased() {
                                    let newValue = inputQuantity + recipe.itemQuantity
                                    db.collection("users").document(currentUser.uid).collection("userItems").document(recipe.id!).updateData([
                                        
                                        "itemQuantity" : newValue
                                    ])
                                }
                            }
                            doesItemExist = false
                        }
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




struct MeasurementPicker : View  {
    @Binding var userInput : String
    @Binding var measurement : String
    @ObservedObject var recepies : RecepiesList
    
    let measurementUnitsList = [
        "st",
        "g",
        "hg",
        "kg",
        "ml",
        "cl",
        "dl",
        "l",
        "tsk",
        "msk",
        "förp",
        "burk",
        "port",
        "kruka"
    ]

    var body : some View {
        VStack{
            Picker("Mått (gäller bara ej tillagda föremål)", selection: $measurement)  {
                ForEach(measurementUnitsList, id: \.self) { unit in
                    Text("\(unit)")
                }
            }.pickerStyle(WheelPickerStyle())
        }
        .onChange(of: userInput) { _ in
            test()
        }
    }
    
    func test() {
        for item in recepies.userItems {
            if item.itemName == userInput.lowercased() {
                measurement = item.itemMeasurement
            }
        }
    }
}




struct ItemQuantityPicker : View {
    @Binding var inputQuantity : Double
    
    let decimalList = [
        0.25,
        0.5,
        0.75,
        1.0,
        1.25,
        1.5,
        1.75,
        2.0,
        2.25,
        2.5,
        2.75,
        3.0,
        3.25,
        3.5,
        3.75,
        4.0,
        4.25,
        4.5,
        4.75,
        5.0,
        5.25,
        5.5,
        5.75,
        6.0,
        6.25,
        6.5,
        6.75,
        7.0,
        7.25,
        7.5,
        7.75,
        8.0,
        8.25,
        8.5,
        8.75,
        9.0,
        9.25,
        9.5,
        9.75,
        10.0,
      ]

    var body : some View {
        Picker("Antal", selection: $inputQuantity)  {
            ForEach(decimalList, id: \.self) { number in
                Text(String(number))
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}




                   
