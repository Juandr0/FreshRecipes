//
//  ShoppingListView.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-24.
//

import SwiftUI

struct ShoppingListView: View {
    var body: some View {
        
        //Ersätt lista med en forEach direkt för att göra listan dymanisk
        //Alternativt hitta ngn funktion som tar in en int som begränsar och sätt den till list.size
                List() {
                    VStack {
                        Text("1")
                    }
                    
                }

                List() {
                    Text("2")
                }
    }
}

//struct ShoppingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShoppingListView()
//    }
//}
