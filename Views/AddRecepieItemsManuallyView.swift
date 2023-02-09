//
//  AddRecepieItemsManuallyView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-09.
//

import SwiftUI

struct AddRecepieItemsManuallyView: View {
    @State var userInput = ""
    
    
    var body : some View {
        VStack{
            TextField("Lägg till en vara..", text: $userInput)
        }
        
    }
}
