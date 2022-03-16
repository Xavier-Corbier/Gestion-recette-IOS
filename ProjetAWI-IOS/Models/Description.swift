//
//  Description.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation


protocol DescriptionObserver {
    func changed(nom : String)
    func changed(description : String)
    func changed(tempsPreparation : Double)
}

class Description {
    var observer : DescriptionObserver?
    
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool {
        return nom.count > 1 && description.count > 1 && tempsPreparation > 0
    }
    
    var nom : String {
        didSet {
            if self.nom != oldValue {
                if nom.count > 1 {
                    self.observer?.changed(nom: self.nom)
                }
                else{
                    self.nom = oldValue
                }
            }
        }
    }
    var description : String {
        didSet {
            if self.description != oldValue {
                if description.count > 1 {
                    self.observer?.changed(description: self.description)
                }
                else{
                    self.description = oldValue
                }
            }
        }
    }
    var tempsPreparation : Double {
        didSet {
            if self.tempsPreparation != oldValue {
                if tempsPreparation > 0 {
                    self.observer?.changed(tempsPreparation : self.tempsPreparation)
                }
                else{
                    self.tempsPreparation = oldValue
                }
            }
        }
    }
    
    init(nom : String, description : String, tempsPreparation : Double){
        self.nom = nom
        self.description = description
        self.tempsPreparation = tempsPreparation
    }
    
    
    
}
