//
//  IngredientDTO.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022
//

import FirebaseFirestore

struct IngredientDTO {
    var id : String?
    var nomIngredient : String
    var prixUnitaire : Double
    var qteIngredient : Double
    var unite : String
    var categorie : String
    var listAllergene : [String]
    
    static func transformDTO(_ ingredient : IngredientDTO) -> Ingredient {
        return Ingredient(nomIngredient: ingredient.nomIngredient,
                          prixUnitaire: ingredient.prixUnitaire,
                          qteIngredient: ingredient.qteIngredient,
                          unite: ingredient.unite,
                          categorie: ingredient.categorie,
                          listAllergene: ingredient.listAllergene,
                          id: ingredient.id)
    }
    
    static func transformToDTO(_ ingredient : Ingredient) -> [String : Any]{
        return [
            "nomIngredient" : ingredient.nomIngredient,
            "prixUnitaire" : ingredient.prixUnitaire,
            "qteIngredient" : ingredient.qteIngredient,
            "unite" : ingredient.unite,
            "categorie" : ingredient.categorie,
            "listAllergene" : ingredient.listAllergene,
        ]
    }
    
    static func docToDTO(doc : NSDictionary) -> IngredientDTO {
        return IngredientDTO(nomIngredient: doc["nomIngredient"] as? String ?? "",
                             prixUnitaire: doc["prixUnitaire"] as? Double ?? 0,
                             qteIngredient: doc["qteIngredient"] as? Double ?? 0,
                             unite: doc["unite"] as? String ?? "",
                             categorie: doc["categorie"] as? String ?? "",
                             listAllergene: doc["listAllergene"] as? [String] ?? [])
    }
    
}
