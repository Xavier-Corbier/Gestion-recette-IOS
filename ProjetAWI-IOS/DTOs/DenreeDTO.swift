//
//  DenreeDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import FirebaseFirestore


struct DenreeDTO {
    
    var ingredient : IngredientDTO
    var number : Double
    
    static func transformDTO(_ denree : DenreeDTO) -> Denree {
        return Denree(ingredient: IngredientDTO.transformDTO(denree.ingredient),
                      nombre: denree.number)
    }
    
    static func transformToDTO(_ denree : Denree) -> [String : Any]{
        return [
            "ingredient" : IngredientDTO.transformToDTO(denree.ingredient),
            "number" : denree.nombre,
        ]
    }
    
    static func docToDTO(doc : NSDictionary) -> DenreeDTO {
        return DenreeDTO(ingredient: IngredientDTO.docToDTO(doc: doc["ingredient"] as! NSDictionary),
                         number: doc["number"] as? Double ?? 0)
    }
    
    
    
}
