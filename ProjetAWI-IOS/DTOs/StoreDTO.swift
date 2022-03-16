//
//  StoreDTO.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

struct StoreDTO {
    var coefCoûtProduction : Double
    var coefPrixDeVente : Double
    var coûtForfaitaire : Double
    var coûtMoyen : Double
    
    static func transformDTO(_ storeDTO : StoreDTO) -> Store{
        return Store(coefCoûtProduction: storeDTO.coefCoûtProduction, coefPrixDeVente: storeDTO.coefPrixDeVente, coûtForfaitaire: storeDTO.coûtForfaitaire, coûtMoyen: storeDTO.coûtMoyen)
    }
    
    static func transformToDTO(_ store : Store) -> [String : Any]{
        return [
            "coefCoûtProduction" : store.coefCoûtProduction,
            "coefPrixDeVente" : store.coefPrixDeVente,
            "coûtForfaitaire" : store.coûtForfaitaire,
            "coûtMoyen" : store.coûtMoyen,
        ]
    }
}
