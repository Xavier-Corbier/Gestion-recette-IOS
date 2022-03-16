//
//  Vente.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

protocol VenteObserver {
    func changed(dateAchat: String)
    func changed(idficheReference: String)
    func changed(nbrPlatVendu: Int)
}

class Vente {
    
    var observer : VenteObserver?
    var id : String?
    var dateAchat : String {
        didSet {
            if self.dateAchat != oldValue {
                if self.dateAchat.count == 10 {
                    self.observer?.changed(dateAchat: self.dateAchat)
                } else {
                    self.dateAchat = oldValue
                }
            }
        }
    }
    var idficheReference : String {
        didSet {
            if self.idficheReference != oldValue {
                if self.idficheReference.count > 0 {
                    self.observer?.changed(idficheReference: self.idficheReference)
                } else {
                    self.idficheReference = oldValue
                }
            }
        }
    }
    var nbrPlatVendu : Int {
        didSet {
            if self.nbrPlatVendu != oldValue {
                if self.nbrPlatVendu > 0 {
                    self.observer?.changed(nbrPlatVendu: self.nbrPlatVendu)
                } else {
                    self.nbrPlatVendu = oldValue
                }
            }
        }
    }
    
    init(dateAchat : String, idficheReference : String, nbrPlatVendu : Int, id : String? = nil){
        self.dateAchat = dateAchat
        self.idficheReference = idficheReference
        self.nbrPlatVendu = nbrPlatVendu
        self.id = id
    }
    /**
                Vérifie si le modèle est valide
     */
    var isValid : Bool{
        return dateAchat.count == 10 && idficheReference.count > 0 && nbrPlatVendu > 0
    }
}
