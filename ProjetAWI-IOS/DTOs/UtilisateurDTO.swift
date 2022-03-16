//
//  UserDTO.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import FirebaseFirestore

struct UtilisateurDTO : Identifiable{
    var id : String = UUID().uuidString
    var email : String
    var estAdmin : Bool
    var motDePasse : String
    var nom : String
    var prenom : String
    
    static func transformDTO(_ utilisateurDTO : UtilisateurDTO) -> Utilisateur{
        return Utilisateur(email: utilisateurDTO.email,
                           nom: utilisateurDTO.nom,
                           prenom: utilisateurDTO.prenom,
                           type: utilisateurDTO.estAdmin ? TypeUtilisateur.Admin : TypeUtilisateur.User,
                           id: utilisateurDTO.id)
    }
    
    static func docToDTO(doc : [String : Any], id : String, withPassword : Bool = false) -> UtilisateurDTO {
        return UtilisateurDTO( id : id,
                               email: doc["email"] as? String ?? "",
                               estAdmin: doc["estAdmin"] as? Bool ?? false,
                               motDePasse: withPassword ? doc["motdepasse"] as? String ?? "" : "",
                               nom: doc["nom"] as? String ?? "",
                               prenom: doc["prenom"] as? String ?? "")
    }
    
    
    static func transformToDTO(_ user : Utilisateur) -> [String : Any]{
        var tab : [String : Any] = [
            "email" : user.email,
            "estAdmin" : (user.type == .Admin) ? true : false,
            "nom" : user.nom,
            "prenom" : user.prenom
        ]
        
        if user.motDePasse != "" {
            tab["motdepasse"] = user.motDePasse
        }
        
        return tab
    }
}
