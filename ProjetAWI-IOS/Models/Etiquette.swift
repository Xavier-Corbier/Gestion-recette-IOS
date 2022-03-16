//
//  Etiquette.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

protocol EtiquetteObserver {
    func changed(dateCreation: String)
    func changed(idficheReference: String)
    func changed(nombreEtiquete: Int)
    func changed(nomPlat: String)
    func changed(listDenree: [DenreeEtiquette])
}

class Etiquette {
    var observer : EtiquetteObserver?
    var id : String?
    var dateCreation : String {
        didSet {
            if self.dateCreation != oldValue {
                if self.dateCreation.count == 10 {
                    self.observer?.changed(dateCreation: self.dateCreation)
                } else {
                    self.dateCreation = oldValue
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
    var nombreEtiquete : Int {
        didSet {
            if self.nombreEtiquete != oldValue {
                if self.nombreEtiquete > 0 {
                    self.observer?.changed(nombreEtiquete: self.nombreEtiquete)
                } else {
                    self.nombreEtiquete = oldValue
                }
            }
        }
    }
    var nomPlat : String {
        didSet {
            if self.nomPlat != oldValue {
                if self.nomPlat.count > 0 {
                    self.observer?.changed(nomPlat: self.nomPlat)
                } else {
                    self.nomPlat = oldValue
                }
            }
        }
    }
    var listDenree : [DenreeEtiquette] {
        didSet {
            self.observer?.changed(listDenree: self.listDenree)
        }
    }
    
    init(dateCreation :String, idficheReference : String, nombreEtiquete : Int, nomPlat : String, listDenree : [DenreeEtiquette], id : String? = nil ){
        self.dateCreation = dateCreation
        self.idficheReference = idficheReference
        self.nombreEtiquete = nombreEtiquete
        self.nomPlat = nomPlat
        self.listDenree = listDenree
        self.id = id
    }
    
    /**
                  Vérifie si un modèle est valide
     */
    var isValid : Bool{
        return dateCreation.count == 10 && idficheReference.count > 0 && nombreEtiquete > 0 && nomPlat.count > 0
    }
}
