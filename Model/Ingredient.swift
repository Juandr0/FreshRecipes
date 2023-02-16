//
//  Ingredient.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-02-16.
//

import UIKit

import Foundation
import FirebaseFirestoreSwift

struct IngredientItem : Identifiable, Codable, Hashable{
    
    @DocumentID var id : String?
    var itemName : String
    var itemQuantity : Double?
    var itemMeasurement : String?

}
