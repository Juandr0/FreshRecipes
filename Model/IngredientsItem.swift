//
//  IngredientsItem.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-16.
//

import Foundation
import FirebaseFirestoreSwift

struct IngredientsItem : Identifiable, Codable, Hashable{
    
    @DocumentID var id : String?
    var itemName : String
    var itemQuantity : Double?
    var itemMeasurement : String?
}
