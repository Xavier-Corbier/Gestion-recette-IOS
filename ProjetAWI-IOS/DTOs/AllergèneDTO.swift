//
//  AllergèneDTO.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

struct AllergèneDTO {
    var id : String
    var nom : String
    static func transformDTO(_ allergène : AllergèneDTO) -> Allergène{
        return Allergène(nom: allergène.nom,
                         id: allergène.id)
    }
    
    static func transformToDTO(_ allergène : Allergène) -> [String : Any]{
        return [
            "nom" : allergène.nom,
        ]
    }
}
