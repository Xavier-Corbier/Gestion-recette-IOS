//
//  Etape.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation

class Etape {    
    var contenu : [Denree] {
        didSet {
            let taille : Int = self.contenu.count
            if taille > oldValue.count { // ajout de denrée
                let nom : String = self.contenu[taille-1].ingredient.nomIngredient
                
                let nbrIngredientMemeNom : Int = self.contenu.filter({ (denree) -> Bool in
                    return denree.ingredient.nomIngredient == nom
                }).count
                
                if nbrIngredientMemeNom > 1 { // il y a une occurence => dupplication => erreur
                    self.contenu = oldValue
                    return
                }
            }
        }
    }
    
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool {
        return description.isValid && contenu.count > 0 && contenu.filter {
            $0.isValid // toutes les denrées doivent être valide
        }.count == contenu.count
    }
    
    var description : Description
    
    init(contenu : [Denree] = [], description : Description = Description(nom: "etape", description: "description", tempsPreparation: 10)){
        self.contenu = contenu
        self.description = description
    }
    
    // fonction à voir
    func getCopyEtape() -> Etape{
        var dNew : [Denree] = []
        for denree in self.contenu {
            dNew.append(Denree(ingredient :denree.ingredient,nombre: denree.nombre))
        }
        return Etape(contenu: dNew, description: self.description)
    }
    
}
