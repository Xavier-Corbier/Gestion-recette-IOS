//
//  VenteDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation

struct VenteDTO {
    var id : String?
    var dateAchat : String
    var idficheReference : String
    var nbrPlatVendu : Int
    
    static func transformToDTO(_ vente : Vente) -> [String : Any]{
        return [
            "dateAchat" : vente.dateAchat,
            "idficheReference" : vente.idficheReference,
            "nbrPlatVendu" : vente.nbrPlatVendu,]
    }
}
