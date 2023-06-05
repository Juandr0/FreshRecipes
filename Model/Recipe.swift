//
//  Recepie.swift
//  FreshRecepies
//
//  Created by Alexander Carlsson on 2023-01-31.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Recipe: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.portions == rhs.portions && lhs.ingredients == rhs.ingredients && lhs.ingredientsAsItem == rhs.ingredientsAsItem && lhs.allergenics == rhs.allergenics && lhs.instructions == rhs.instructions && lhs.cookingtimeMinutes == rhs.cookingtimeMinutes && lhs.imageUrl == rhs.imageUrl
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(portions)
        hasher.combine(ingredients)
        hasher.combine(ingredientsAsItem)
        hasher.combine(allergenics)
        hasher.combine(instructions)
        hasher.combine(cookingtimeMinutes)
        hasher.combine(imageUrl)
    }
    
    @DocumentID var id: String?
    var name: String
    var portions: Int
    var ingredients: [String]
    var ingredientsAsItem: [Item]?
    var allergenics: [String]
    var instructions: [String]
    var cookingtimeMinutes: Int
    var imageUrl: String
}
