//
//  DescriptionDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import FirebaseFirestore

struct DescriptionDTO {
    
    var description : String
    var nom : String
    var tempsPreparation : Double
    
    static func transformDTO(_ description : DescriptionDTO) -> Description {
        return Description(nom: description.nom,
                           description: description.description,
                           tempsPreparation: description.tempsPreparation)
    }
    
    static func transformToDTO(_ description : Description) -> [String : Any]{
        return [
            "description" : description.description,
            "nom" : description.nom,
            "tempsPreparation" : description.tempsPreparation
        ]
    }
    
    static func docToDTO(doc : NSDictionary) -> DescriptionDTO {
        return DescriptionDTO(description: doc["description"] as? String ?? "",
                              nom: doc["nom"] as? String ?? "",
                              tempsPreparation: doc["tempsPreparation"] as? Double ?? 0)
    }
    
}
