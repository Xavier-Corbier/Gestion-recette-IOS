//
//  HeaderFT.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation

protocol HeaderFTObserver{
    func changed(nomPlat : String)
    func changed(nomAuteur : String)
    func changed(nbrCouvert : Int)
    func changed(isCalculCharge : Bool)
    func changed(coutMatiere : Double)
    func changed(dureeTotal : Double)
    func changed(coutMoyenHoraire : Double)
    func changed(coutForfaitaire : Double)
    func changed(coefCoutProduction : Double)
    func changed(coefPrixDeVente : Double)
    func changed(categorie : String)
}



class HeaderFT{
    
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool {
        return nomPlat.count > 1 && nomAuteur.count > 1 && nbrCouvert > 0 && categorie.count > 1
    }
    
    var observer : HeaderFTObserver?
    
    var nomPlat : String {
        didSet {
            if self.nomPlat != oldValue {
                if nomPlat.count > 1 {
                    self.observer?.changed(nomPlat: self.nomPlat)
                }
                else{
                    self.nomPlat = oldValue
                }
            }
        }
    }
    
    var nomAuteur : String{
        didSet {
            if self.nomAuteur != oldValue {
                if nomAuteur.count > 1 {
                    self.observer?.changed(nomAuteur: self.nomAuteur)
                }
                else{
                    self.nomAuteur = oldValue
                }
            }
        }
    }
    
    var nbrCouvert : Int {
        didSet {
            if self.nbrCouvert != oldValue {
                if nbrCouvert >= 0 {
                    self.observer?.changed(nbrCouvert: self.nbrCouvert)
                }
                else{
                    self.nbrCouvert = oldValue
                }
            }
        }
    }
    
    var isCalculCharge : Bool {
        didSet {
            self.observer?.changed(isCalculCharge : self.isCalculCharge)
        }
    }
    
    var coutMatiere : Double {
        didSet {
            if self.coutMatiere != oldValue {
                if coutMatiere >= 0 {
                    self.observer?.changed(coutMatiere: self.coutMatiere)
                }
                else{
                    self.coutMatiere = oldValue
                }
            }
        }
    }
    
    var dureeTotal : Double {
        didSet {
            if self.dureeTotal != oldValue {
                if dureeTotal >= 0 {
                    self.observer?.changed(dureeTotal: self.dureeTotal)
                }
                else{
                    self.dureeTotal = oldValue
                }
            }
        }
    }
    
    var coutMoyenHoraire : Double {
        didSet {
            if self.coutMoyenHoraire != oldValue {
                if coutMoyenHoraire >= 0 {
                    self.observer?.changed(coutMoyenHoraire: self.coutMoyenHoraire)
                }
                else{
                    self.coutMoyenHoraire = oldValue
                }
            }
        }
    }
    
    var coutForfaitaire : Double {
        didSet {
            if self.coutForfaitaire != oldValue {
                if coutForfaitaire >= 0 {
                    self.observer?.changed(coutForfaitaire: self.coutForfaitaire)
                }
                else{
                    self.coutForfaitaire = oldValue
                }
            }
        }
    }
    
    var coefCoutProduction : Double {
        didSet {
            if self.coefCoutProduction != oldValue {
                if coefCoutProduction >= 0 {
                    self.observer?.changed(coefCoutProduction: self.coefCoutProduction)
                }
                else{
                    self.coefCoutProduction = oldValue
                }
            }
        }
    }
    
    var coefPrixDeVente : Double {
        didSet {
            if self.coefPrixDeVente != oldValue {
                if coefPrixDeVente >= 0 {
                    self.observer?.changed(coefPrixDeVente: self.coefPrixDeVente)
                }
                else{
                    self.coefPrixDeVente = oldValue
                }
            }
        }
    }
    
    var id : String = ""
    
    var categorie : String {
        didSet{
            self.observer?.changed(categorie: self.categorie)
        }
    }
    
    init(nomPlat : String,
         nomAuteur : String,
         nbrCouvert : Int,
         id : String = "",
         categorie : String = "",
         isCalculCharge : Bool = true,
         coutMatiere : Double = 0,
         dureeTotal : Double = 0,
         coutMoyenHoraire : Double = 0,
         coutForfaitaire : Double = 0,
         coefCoutProduction : Double = 0,
         coefPrixDeVente : Double = 0
    ){
        self.nomPlat = nomPlat
        self.nomAuteur = nomAuteur
        self.nbrCouvert = nbrCouvert
        self.id = id
        self.categorie = categorie
        self.isCalculCharge = isCalculCharge
        self.coutMatiere = coutMatiere
        self.dureeTotal = dureeTotal
        self.coutMoyenHoraire = coutMoyenHoraire
        self.coutForfaitaire = coutForfaitaire
        self.coefCoutProduction = coefCoutProduction
        self.coefPrixDeVente = coefPrixDeVente
    }
    
    // setter
    
    func setStore(store : Store){
        self.coutMoyenHoraire = store.coûtMoyen
        self.coefCoutProduction = store.coefCoûtProduction
        self.coutForfaitaire = store.coûtForfaitaire
        self.coefPrixDeVente = store.coefPrixDeVente
    }
    
    // propriétés calculées
    
    var coutProduction : Double {
        if(self.isCalculCharge){
            return self.coutMatiereTotal + self.coutPersonnel + self.coutFluide
        }
        else{
            return self.coutMatiereTotal
        }
    }
    
    var coutFluide : Double {
        return self.coutForfaitaire
    }
    
    var coutMatiereTotal : Double {
        return self.coutMatiere * 1.05 /* +5% ASS */
    }
    
    var coutProductionPortion : Double {
        if (self.nbrCouvert == 0) {
            return 0
        }
        else{
            return self.coutProduction / Double(self.nbrCouvert)
        }
    }
    
    var dureeTotalHeure : Double {
        return self.dureeTotal / 60
    }
    
    var coutPersonnel : Double {
        return self.dureeTotalHeure * self.coutMoyenHoraire
    }
    
    var prixDeVenteTotalTTC : Double {
        if (self.isCalculCharge) {
            return self.coutProduction * self.coefCoutProduction
        }
        else {
            return self.coutProduction * self.coefPrixDeVente
        }
    }
    
    var prixDeVenteTotalHT : Double {
        return self.prixDeVenteTotalTTC / 1.1 /** TVA 10%*/
    }
    
    var prixDeVentePortionTTC : Double {
        if(self.nbrCouvert == 0){
            return 0
        }
        return self.prixDeVenteTotalTTC / Double(self.nbrCouvert)
    }
    
    var prixDeVentePortionHT :  Double {
        if(self.nbrCouvert == 0){
            return 0
        }
        return self.prixDeVenteTotalHT / Double(self.nbrCouvert)
    }
    
    var estBenefice : Bool {
        return self.beneficeTotal > 0
    }
    
    var beneficeTotal : Double {
        return self.prixDeVenteTotalHT - self.coutProduction
    }
    
    var beneficeParPortion : Double {
        return self.prixDeVentePortionHT - self.coutProductionPortion
    }
    
    
    /**
        Retourne le nombre au minimum de portion à vendre pour être rentable
     */
    var seuilRentabilite : Int {
        var i = 0
        if self.prixDeVenteTotalHT > 0 {
            var benef = -self.coutProduction
            while(benef < 0 ){
                benef += self.prixDeVentePortionHT
                i+=1
            }
            return i
        }
        else{
            return -1
        }
    }
    
    
}
