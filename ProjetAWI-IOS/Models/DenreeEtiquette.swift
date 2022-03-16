//
//  DenreeEtiquette.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

class DenreeEtiquette : Equatable {
    var nom : String
    var isAllergene : Bool
    init(nom : String, isAllergene : Bool){
        self.nom = nom
        self.isAllergene = isAllergene
    }
    
    static func == (lhs: DenreeEtiquette, rhs: DenreeEtiquette) -> Bool {
        return lhs.nom == rhs.nom && lhs.isAllergene == rhs.isAllergene
    }
}
