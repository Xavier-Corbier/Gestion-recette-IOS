//
//  EtapeDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import FirebaseFirestore

struct EtapeDTO {
        
    var contenu : [DenreeDTO]
    var identification : DescriptionDTO
    
    static func transformDTO(_ etape : EtapeDTO) -> Etape {
        return Etape(contenu: etape.contenu.map{
            (denreeDTO) -> Denree in
            return DenreeDTO.transformDTO(DenreeDTO(ingredient: denreeDTO.ingredient, number: denreeDTO.number))
        }
                     ,description: DescriptionDTO.transformDTO(etape.identification))
    }
    
    static func transformToDTO(_ etape : Etape) -> [String : Any]{
        return [
            "contenu" : etape.contenu.map{
                (denree) -> [String : Any] in
                return DenreeDTO.transformToDTO(denree)
            },
            "identification" : DescriptionDTO.transformToDTO(etape.description),
        ]
    }
    
    static func docToDTO(doc : NSDictionary) -> EtapeDTO {
        return EtapeDTO(contenu: (doc["contenu"] as! [NSDictionary] ).map{
            (docDenree) -> DenreeDTO in
            return DenreeDTO.docToDTO(doc: docDenree)
        },
                        identification: DescriptionDTO.docToDTO(doc: doc["identification"] as! NSDictionary))
    }

    
}
