//
//  Item.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-07.
//

import Foundation
import FirebaseFirestoreSwift

struct Item : Identifiable, Codable {
    
    @DocumentID var id : String?
    var itemName : String
    var itemQuantity : Double?
    var isBought = false
}
