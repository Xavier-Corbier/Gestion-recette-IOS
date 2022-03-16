//
//  Store.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

protocol StoreObserver {
    func changed(coefCoûtProduction : Double)
    func changed(coefPrixDeVente : Double)
    func changed(coûtForfaitaire : Double)
    func changed(coûtMoyen : Double)
}

class Store {
    var id : String = "store"
    var coefCoûtProduction : Double {
        didSet {
            if self.coefCoûtProduction != oldValue {
                if self.coefCoûtProduction >= 0 {
                    self.observer?.changed(coefCoûtProduction: self.coefCoûtProduction)
                } else {
                    self.coefCoûtProduction = oldValue
                }
            }
        }
    }
    var coefPrixDeVente : Double {
        didSet {
            if self.coefPrixDeVente != oldValue {
                if self.coefPrixDeVente >= 0 {
                    self.observer?.changed(coefPrixDeVente: self.coefPrixDeVente)
                } else {
                    self.coefPrixDeVente = oldValue
                }
            }
        }
    }
    var coûtForfaitaire : Double {
        didSet {
            if self.coûtForfaitaire != oldValue {
                if self.coûtForfaitaire >= 0 {
                    self.observer?.changed(coûtForfaitaire: self.coûtForfaitaire)
                } else {
                    self.coûtForfaitaire = oldValue
                }
            }
        }
    }
    var coûtMoyen : Double {
        didSet {
            if self.coûtMoyen != oldValue {
                if self.coûtMoyen >= 0 {
                    self.observer?.changed(coûtMoyen: self.coûtMoyen)
                } else {
                    self.coûtMoyen = oldValue
                }
            }
        }
    }
    var observer : StoreObserver?
    init(coefCoûtProduction : Double, coefPrixDeVente: Double, coûtForfaitaire : Double, coûtMoyen: Double){
        self.coefCoûtProduction = coefCoûtProduction
        self.coefPrixDeVente = coefPrixDeVente
        self.coûtForfaitaire = coûtForfaitaire
        self.coûtMoyen = coûtMoyen
    }
}
