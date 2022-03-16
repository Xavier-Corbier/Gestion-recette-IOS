//
//  Allergène.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

protocol AllergèneObserver {
    func changed(nom : String)
}

class Allergène {
    var observer: AllergèneObserver?
    var id : String?
    var nom : String {
        didSet {
            if self.nom != oldValue {
                if self.nom.count >= 1 {
                    self.observer?.changed(nom: self.nom)
                } else {
                    self.nom = oldValue
                }
            }
        }
    }
    
    init(nom : String, id : String? = nil){
        self.nom = nom
        self.id = id
    }
    
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool{
        return nom.count > 1 
    }
}
