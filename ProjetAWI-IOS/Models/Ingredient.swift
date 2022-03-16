//
//  Ingredient.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//
protocol IngredientObserver {
    func changed(nomIngredient: String)
    func changed(prixUnitaire: Double)
    func changed(qteIngredient: Double)
    func changed(unite: String)
    func changed(categorie: String)
    func changed(listAllergene: [String])
}

class Ingredient {
    
    var observer : IngredientObserver?
    var id : String?
    var nomIngredient : String {
        didSet {
            if self.nomIngredient != oldValue {
                if self.nomIngredient.count >= 1 {
                    self.observer?.changed(nomIngredient: self.nomIngredient)
                } else {
                    self.nomIngredient = oldValue
                }
            }
        }
    }
    var prixUnitaire : Double {
        didSet {
            if self.prixUnitaire != oldValue {
                if self.prixUnitaire >= 0 {
                    self.observer?.changed(prixUnitaire: self.prixUnitaire)
                } else {
                    self.prixUnitaire = oldValue
                }
            }
        }
    }
    var qteIngredient : Double {
        didSet {
            if self.qteIngredient != oldValue {
                if self.qteIngredient >= 0 {
                    self.observer?.changed(qteIngredient: self.qteIngredient)
                } else {
                    self.qteIngredient = oldValue
                }
            }
        }
    }
    var unite : String {
        didSet {
            if self.unite != oldValue {
                if self.unite.count >= 1 {
                    self.observer?.changed(unite: self.unite)
                } else {
                    self.unite = oldValue
                }
            }
        }
    }
    var categorie : String {
        didSet {
            if self.categorie != oldValue {
                self.observer?.changed(categorie: self.categorie)
            }
        }
    }
    var listAllergene : [String] {
        didSet {
            if self.listAllergene != oldValue {
               self.observer?.changed(listAllergene: self.listAllergene)
            }
        }
    }
    init(nomIngredient: String, prixUnitaire : Double, qteIngredient : Double, unite : String, categorie : String, listAllergene : [String], id : String? = nil){
        self.id = id
        self.nomIngredient = nomIngredient
        self.prixUnitaire = prixUnitaire
        self.qteIngredient = qteIngredient
        self.unite = unite
        self.categorie = categorie
        self.listAllergene = listAllergene
    }
    
    func getCopyIngredient() -> Ingredient {
        return Ingredient(nomIngredient: self.nomIngredient, prixUnitaire: self.prixUnitaire, qteIngredient: self.qteIngredient, unite: self.unite, categorie: self.categorie, listAllergene: self.listAllergene, id: self.id)
    }
    
    var coutStock : Double {
        return self.qteIngredient * self.qteIngredient
    }
    /**
                Vérifie si le model est valide
     
     */
    var isValid : Bool{
        return nomIngredient.count >= 1 && prixUnitaire >= 0 && prixUnitaire >= 0 && qteIngredient >= 0 && unite.count >= 1 && categorie.count >= 1
    }
}
