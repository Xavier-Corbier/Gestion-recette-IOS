//
//  FicheTechnique.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation

/**
    Classe qui contient les étapes principales de la fiche (les plus haute)
    Elle contient soit un tableau d'une case qui contient une étape si elle correspond à une simple étape
    soit un tableau de plusieurs étape correspondant à une sous-fiche-technique
 */
class EtapeFiche {
    
    var etapes : [Etape] // [0] si étape normale | [n] si sous-fiche-technique
    
    var nomSousFicheTechnique : String? // nom de la sous-fiche technique si présente
    
    var isValid : Bool {
        let validSousFiche : Bool = (nomSousFicheTechnique == nil && etapes.count == 1) || nomSousFicheTechnique != nil
        return validSousFiche && etapes.filter{$0.isValid}.count == etapes.count
    }
    
    init(etapes : [Etape], nomSousFicheTechnique : String? = nil){
        self.etapes = etapes
        self.nomSousFicheTechnique = nomSousFicheTechnique
    }
    
    var estSousFicheTechnique : Bool {
        return nomSousFicheTechnique != nil
    }
    
    var getDureeTotal : Double {
        if self.nomSousFicheTechnique != nil {
            var temps : Double = 0
            for etape in self.etapes {
                temps += etape.description.tempsPreparation
            }
            return temps
        }
        else{
            return self.etapes[0].description.tempsPreparation
        }
    }
    
}

protocol FicheTechniqueObserver {
    func changed(materielDressage : String?)
    func changed(materielSpecifique : String?)
}

class FicheTechnique {
    
    var isProgressionValid : Bool {
        return progression.filter{$0.isValid}.count == progression.count && progression.count > 0
    }
    
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool {
        return header.isValid && isProgressionValid
    }
    
    var header : HeaderFT
    var progression : [EtapeFiche] {
        didSet {
            let taille : Int = self.progression.count
            if taille > oldValue.count { // ajout d'étape
                if self.progression[taille-1].estSousFicheTechnique{ // on a ajouter une sous-fiche technique
                    // il faut vérifier qu'elle n'est pas déjà présente, et qu'on ne s'est pas ajouter nous-même
                    let nom : String = self.progression[taille-1].nomSousFicheTechnique!
                    
                    if nom == self.header.nomPlat { // on s'est ajouter nous-même => erreur
                        self.progression = oldValue
                        return
                    }
                    
                    let nbrFicheMemeNom : Int = self.progression.filter({ (etapeFiche) -> Bool in
                        if etapeFiche.estSousFicheTechnique {
                            return etapeFiche.nomSousFicheTechnique! == nom
                        }
                        else {
                            return false
                        }
                    }).count
                    
                    if nbrFicheMemeNom > 1 { // il y a une occurence => dupplication => erreur
                        self.progression = oldValue
                        return
                    }
                }
            }
        }
    }
    var materielSpecifique : String? {
        didSet {
            if self.materielSpecifique != oldValue {
                if self.materielSpecifique == "" {
                    self.materielSpecifique = nil
                }
                self.observer?.changed(materielSpecifique: self.materielSpecifique)
            }
        }
    }
    var materielDressage : String?{
        didSet {
            if self.materielDressage != oldValue {
                if self.materielDressage == "" {
                    self.materielDressage = nil
                }
                self.observer?.changed(materielDressage: self.materielDressage)
            }
        }
    }
    
    var observer : FicheTechniqueObserver?
    
    init(header : HeaderFT, progression : [EtapeFiche], materielSpecifique : String? = nil, materielDressage : String? = nil){
        self.header = header
        self.progression = progression
        self.materielDressage = materielDressage
        self.materielSpecifique = materielSpecifique
    }
    
    /**
            Get toutes les étapes de la fiche technique
     */
    var getEtape : [Etape] {
        var etapes : [Etape] = []
        for etapeFiche in self.progression {
            for etape in etapeFiche.etapes {
                etapes.append(etape)
            }
        }
        return etapes
    }
    
    /**
            Calcul la durée total des étapes ainsi que le coût matière
     */
    func calculDenreeEtCoutMatiere(){
        var coutMatiere : Double = 0
        var dureeTotal : Double = 0
        
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                dureeTotal += etape.description.tempsPreparation
                for denree in etape.contenu{
                    coutMatiere += denree.ingredient.prixUnitaire * denree.nombre
                   
                }
            }
        }
        
        self.header.dureeTotal = dureeTotal
        self.header.coutMatiere = coutMatiere
    }
    
    /**
            Renvoie vrai si la fiche contient tous les ingrédients de la liste
     */
    func contientIngrédients(tabIngrédient : [String]) -> Bool {
        var listNomsIngrédients : [String] = []
        for ingredient in tabIngrédient {
            listNomsIngrédients.append(ingredient)
        }
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                for denree in etape.contenu{
                    if listNomsIngrédients.contains(denree.ingredient.nomIngredient){
                        if let id : Int = listNomsIngrédients.firstIndex(of: denree.ingredient.nomIngredient) {
                            listNomsIngrédients.remove(at: id)
                            if listNomsIngrédients.count == 0 {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    /**
       * Recupère toute la liste des denrées de la fiche technique
    */
    var getListDenree : [Denree] {
        var denrees : [Denree] = []
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                for denree in etape.contenu{
                    if denrees.contains(where: {den in den.ingredient.nomIngredient == denree.ingredient.nomIngredient}) {
                        // on a déjà croisé l'ingrédient, on augmente son nombre
                        for denreeTab in denrees {
                            if denreeTab.ingredient.nomIngredient == denree.ingredient.nomIngredient {
                                denreeTab.nombre += denree.nombre
                            }
                        }
                    }
                    else{
                        // on avait pac croisé l'ingrédient encore, on l'ajoute
                        let nbr = denree.nombre
                        let ingredient : Ingredient = denree.ingredient.getCopyIngredient()
                        denrees.append(Denree(ingredient: ingredient, nombre: nbr))
                    }
                }
            }
        }
        
        return denrees
    }
    
    /**
            retourne vrai si l'ingrédient est contenue
     */
    func  isContientIngredient(ingredient : Ingredient) -> Bool {
        for etapeFiche in self.progression{
            for etape in etapeFiche.etapes {
                for denree in etape.contenu{
                    if ingredient.nomIngredient == denree.ingredient.nomIngredient {
                       return true
                    }
                }
            }
        }
        return false
    }
    
    
    
    
    
}
