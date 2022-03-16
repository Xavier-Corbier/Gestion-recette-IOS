//
//  HeaderFTDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import FirebaseFirestore

struct HeaderFTDTO {
    
    var categorie : String
    var coefCoutProduction : Double
    var coefPrixDeVente : Double
    var coutForfaitaire : Double
    var coutMatiere : Double
    var coutMoyenHorraire : Double
    var dureeTotal : Double
    var isCalculCharge : Bool
    var nbrCouvert : Int
    var nomAuteur : String
    var nomPlat : String
    
    
    static func transformDTO(header : HeaderFTDTO, id : String) -> HeaderFT {
        return HeaderFT(nomPlat: header.nomPlat,
                        nomAuteur: header.nomAuteur,
                        nbrCouvert: header.nbrCouvert,
                        id: id,
                        categorie: header.categorie,
                        isCalculCharge: header.isCalculCharge,
                        coutMatiere: header.coutMatiere,
                        dureeTotal: header.dureeTotal,
                        coutMoyenHoraire: header.coutMoyenHorraire,
                        coutForfaitaire: header.coutForfaitaire,
                        coefCoutProduction: header.coefCoutProduction,
                        coefPrixDeVente: header.coefPrixDeVente)
    }
    
    static func docToDTO(doc : NSDictionary) -> HeaderFTDTO{
        return HeaderFTDTO(categorie: doc["categorie"] as? String ?? "",
                           coefCoutProduction: doc["coefCoutProduction"] as? Double ?? 0,
                           coefPrixDeVente: doc["coefPrixDeVente"] as? Double ?? 0,
                           coutForfaitaire: doc["coutForfaitaire"] as? Double ?? 0,
                           coutMatiere: doc["coutMatiere"] as? Double ?? 0,
                           coutMoyenHorraire: doc["coutMoyenHorraire"] as? Double ?? 0,
                           dureeTotal: doc["dureeTotal"] as? Double ?? 0,
                           isCalculCharge: doc["isCalculCharge"] as? Bool ?? true,
                           nbrCouvert: doc["nbrCouvert"] as? Int ?? 0,
                           nomAuteur: doc["nomAuteur"] as? String ?? "",
                           nomPlat: doc["nomPlat"] as? String ?? "")
    }
    
    static func transformToDTO(_ header : HeaderFT) -> [String : Any]{
        return [
            "nomPlat": header.nomPlat,
            "nomAuteur": header.nomAuteur,
            "nbrCouvert": header.nbrCouvert,
            "categorie": header.categorie,
            "isCalculCharge": header.isCalculCharge,
            "coutMatiere": header.coutMatiere,
            "dureeTotal": header.dureeTotal,
            "coutMoyenHoraire": header.coutMoyenHoraire,
            "coutForfaitaire": header.coutForfaitaire,
            "coefCoutProduction": header.coefCoutProduction,
            "coefPrixDeVente": header.coefPrixDeVente
        ]
    }
    
    
}
