//
//  Denree.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation

protocol DenreeObserver {
    func changed(nombre : Double)
}

class Denree {
    var observer : DenreeObserver?
    var ingredient : Ingredient
    var nombre : Double {
        didSet {
            if self.nombre != oldValue {
                if self.nombre > 0 {
                    self.observer?.changed(nombre: self.nombre)
                }
                else {
                    self.nombre = oldValue
                }
            }
        }
    }
    
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool {
        return nombre > 0 
    }
    
    init(ingredient : Ingredient, nombre : Double){
        self.ingredient = ingredient
        self.nombre = nombre
    }
    
}
