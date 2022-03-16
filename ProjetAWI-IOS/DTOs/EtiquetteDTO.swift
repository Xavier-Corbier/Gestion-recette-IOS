//
//  EtiquetteDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation

struct EtiquetteDTO {
    var id : String?
    var dateCreation : String
    var idficheReference : String
    var nombreEtiquete : Int
    var nomPlat : String
    var listDenree : [DenreeEtiquette]
    static func transformToDTO(_ etiquette : Etiquette) -> [String : Any]{
        let list : [[String : Any]] = etiquette.listDenree.map {
            (denree) -> [String : Any] in
            return [
                "isAllergene" : denree.isAllergene,
                "nom" : denree.nom
            ]
        }
        return [
            "dateCreation" : etiquette.dateCreation,
            "idficheReference" : etiquette.idficheReference,
            "nombreEtiquete" : etiquette.nombreEtiquete,
            "nomPlat" : etiquette.nomPlat,
            "listDenree" : list,
        ]
    }
    
}
