//
//  FicheTechniqueDetailViewModel.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import SwiftUI
import Combine

enum FicheTechniqueViewModelError : Error, Equatable, CustomStringConvertible {
    case noError
    case updateError
    case createError
    case inputError
    case deleteError
    case addEtapeError
    case noValid
    var description: String {
        switch self {
        case .noError : return "Aucune erreur"
        case .updateError : return "Erreur de mise à jour"
        case .createError : return "Erreur de création"
        case .deleteError : return "Erreur de suppression"
        case .noValid : return "Erreur : Il manque des champs à remplir pour la fiche technique"
        case .inputError : return "Input non valide"
        case .addEtapeError : return "L'ajout de l'étape a été refusé (duplication)"
        }
    }
}

class FicheTechniqueViewModel : ObservableObject, Subscriber, FicheTechniqueServiceObserver, HeaderFTObserver, FicheTechniqueObserver {
    private var ficheTechniqueService : FicheTechniqueService
    private var ficheTechnique : FicheTechnique
    
    var coutMatiereTotal : Double { return ficheTechnique.header.coutMatiereTotal }
    var ASS : Double {return ficheTechnique.header.coutMatiere * 0.05 }
    var coutPersonnel : Double { return ficheTechnique.header.coutPersonnel}
    var coutProductionTotal : Double {return ficheTechnique.header.coutProduction}
    var coutProductionPortion : Double {return ficheTechnique.header.coutProductionPortion}
    var seuilRentabilité : Int {return ficheTechnique.header.seuilRentabilite}
    var prixDeVente : Double {return ficheTechnique.header.prixDeVenteTotalHT}
    var prixDeVentePortion : Double {return ficheTechnique.header.prixDeVentePortionHT}
    var beneficeTotal : Double {return ficheTechnique.header.beneficeTotal}
    var beneficePortion : Double {return ficheTechnique.header.beneficeParPortion}
    var coutFluide : Double {return ficheTechnique.header.coutFluide}

    
    @Published var nomPlat : String
    @Published var categorie : String
    @Published var nomAuteur : String
    @Published var couvert : Int
    
    var headerValid : Bool {
        return ficheTechnique.header.isValid
    }
    
    var id : String {
        return ficheTechnique.header.id
    }
    
    @Published var isCalculCharge : Bool
    @Published var coutMatiere : Double
    @Published var dureeTotal : Double
    @Published var coutMoyenHoraire : Double
    @Published var coutForfaitaire : Double
    @Published var coefCoutProduction : Double
    @Published var coefPrixDeVente : Double
    
    @Published var progression : [EtapeFiche]
    var progressionValid : Bool{
        return ficheTechnique.isProgressionValid
    }
    
    @Published var materielSpecifique : String
    @Published var materielDressage : String
    
    @Published var result : Result<String, FicheTechniqueViewModelError> = .failure(.noError)
    
    init(ficheService : FicheTechniqueService, ficheTechniqueListViewModel : FicheTechniqueListViewModel? = nil, indice : Int? = nil) {
        if let indice = indice , let ficheTechniqueListViewModel = ficheTechniqueListViewModel{
            self.ficheTechnique = ficheTechniqueListViewModel.tabFicheTechnique[indice]
        } else {
            self.ficheTechnique = FicheTechnique(header: HeaderFT(nomPlat: "Fiche technique", nomAuteur: "", nbrCouvert: 1), progression: [])
            ficheTechnique.header.setStore(store: StoreService.instance.store)
        }
        
        self.ficheTechniqueService = ficheService
        
        self.nomPlat = self.ficheTechnique.header.nomPlat
        self.categorie = self.ficheTechnique.header.categorie
        self.nomAuteur = self.ficheTechnique.header.nomAuteur
        self.couvert = self.ficheTechnique.header.nbrCouvert
        self.isCalculCharge = self.ficheTechnique.header.isCalculCharge
        self.coutMatiere = self.ficheTechnique.header.coutMatiere
        self.dureeTotal = self.ficheTechnique.header.dureeTotal
        self.coutMoyenHoraire = self.ficheTechnique.header.coutMoyenHoraire
        self.coutForfaitaire = self.ficheTechnique.header.coutForfaitaire
        self.coefCoutProduction = self.ficheTechnique.header.coefCoutProduction
        self.coefPrixDeVente = self.ficheTechnique.header.coefPrixDeVente
        
        self.progression = self.ficheTechnique.progression
        self.materielSpecifique = self.ficheTechnique.materielSpecifique == nil ? "" : self.ficheTechnique.materielSpecifique!
        self.materielDressage = self.ficheTechnique.materielDressage == nil ? "" : self.ficheTechnique.materielDressage!
        
        self.ficheTechnique.header.observer = self
    }
    
    func isValidEtape(id : Int) -> Bool{
        return self.ficheTechnique.progression[id].isValid
    }
    
    func getListDenree() -> [Denree]{
        return ficheTechnique.getListDenree
    }
    
    func setObserverService(){
        self.ficheTechniqueService.setObserver(obs: self)
    }
    
    func removeObserverService(){
        self.ficheTechniqueService.removeObserver(obs: self)
    }
    
    func emit(to: Result<String, FicheTechniqueViewModelError>) {
        self.result = to
    }
    
    typealias Input = FicheTechniqueIntentState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: FicheTechniqueIntentState) -> Subscribers.Demand {
        switch input {
        case .ready:
            break
        case .addFicheTechnique(let newCategorie):
            self.ficheTechniqueService.addFicheTechnique(fiche: self.ficheTechnique, newCategorie: newCategorie)
            break
        case .deleteFicheTechnique:
            self.ficheTechniqueService.removeFicheTechnique(id: self.ficheTechnique.header.id, categorie: self.ficheTechnique.header.categorie)
            
            break
        case .updateFicheTechnique(let isChangeCategorie):
            self.ficheTechniqueService.updateFicheTechnique(fiche: self.ficheTechnique, isChangeCategorie: isChangeCategorie)
            break
        case .changingNomAuteur(let nom):
            self.ficheTechnique.header.nomAuteur = nom
            if self.ficheTechnique.header.nomAuteur != nom {
                self.nomAuteur = self.ficheTechnique.header.nomAuteur
                self.result = .failure(.inputError)
            }
        case .changingNomPlat(let nom):
                self.ficheTechnique.header.nomPlat = nom
                if self.ficheTechnique.header.nomPlat != nom {
                    self.nomPlat = self.ficheTechnique.header.nomPlat
                    self.result = .failure(.inputError)
                }
        case .changingCategorie(let nomCate):
            self.ficheTechnique.header.categorie = nomCate
            if self.ficheTechnique.header.categorie != nomCate {
                self.categorie = self.ficheTechnique.header.categorie
                self.result = .failure(.inputError)
            }
        case .changingNbrCouvert(let nbr):
            self.ficheTechnique.header.nbrCouvert = nbr
            if self.ficheTechnique.header.nbrCouvert != nbr {
                self.couvert = self.ficheTechnique.header.nbrCouvert
                self.result = .failure(.inputError)
            }
            
        case .changingMaterielSpecifique(let mat):
            let newVal : String? = mat == "" ? nil : mat
            self.ficheTechnique.materielSpecifique = newVal
            if self.ficheTechnique.materielSpecifique != newVal {
                self.materielSpecifique = self.ficheTechnique.materielSpecifique == nil ? "" : self.ficheTechnique.materielSpecifique!
                self.result = .failure(.inputError)
            }
            
        case .changingMaterielDressage(let mat):
            let newVal : String? = mat == "" ? nil : mat
            self.ficheTechnique.materielDressage = newVal
            if self.ficheTechnique.materielDressage != newVal {
                self.materielDressage = self.ficheTechnique.materielDressage == nil ? "" : self.ficheTechnique.materielDressage!
                self.result = .failure(.inputError)
            }
          
        case .changingCoefProd(let coef):
            self.ficheTechnique.header.coefCoutProduction = coef
            if self.ficheTechnique.header.coefCoutProduction != coef {
                self.coefCoutProduction = self.ficheTechnique.header.coefCoutProduction
                self.result = .failure(.inputError)
            }
            
        case .changingCoefVente(let coef):
            self.ficheTechnique.header.coefPrixDeVente = coef
            if self.ficheTechnique.header.coefPrixDeVente != coef {
                self.coefPrixDeVente = self.ficheTechnique.header.coefPrixDeVente
                self.result = .failure(.inputError)
            }
            
        case .changingCoutForfaitaire(let cout):
            self.ficheTechnique.header.coutForfaitaire = cout
            if self.ficheTechnique.header.coutForfaitaire != cout {
                self.coutForfaitaire = self.ficheTechnique.header.coutForfaitaire
                self.result = .failure(.inputError)
            }
            
        case .changingIsCalculCharge(let bool):
            self.ficheTechnique.header.isCalculCharge = bool
            if self.ficheTechnique.header.isCalculCharge != bool {
                self.isCalculCharge = self.ficheTechnique.header.isCalculCharge
                self.result = .failure(.inputError)
            }
            
        case .changingCoutMoyenHoraire(let cout):
            self.ficheTechnique.header.coutMoyenHoraire = cout
            if self.ficheTechnique.header.coutMoyenHoraire != cout {
                self.coutMoyenHoraire = self.ficheTechnique.header.coutMoyenHoraire
                self.result = .failure(.inputError)
            }
            
        // gestion etape
        case .addEtape:
            let count = self.ficheTechnique.progression.count
            self.ficheTechnique.progression.append(EtapeFiche(etapes: [Etape()]))
            if count < self.ficheTechnique.progression.count {
                self.progression.append(self.ficheTechnique.progression[count])
            }
            else{
                self.result = .failure(.inputError)
            }
        
        
        case .addSousFicheTechnique(let idFiche):
            if let fiche : FicheTechnique = self.ficheTechniqueService.getFicheTechnique(id: idFiche){
                let count = self.ficheTechnique.progression.count
                self.ficheTechnique.progression.append(EtapeFiche(etapes: fiche.progression.map{(etapeFiche : EtapeFiche) -> Etape in
                    return etapeFiche.etapes[0] // que la première case car elle ne contient pas de sous fiche technique
                }, nomSousFicheTechnique: fiche.header.nomPlat))
                if count < self.ficheTechnique.progression.count { // modification effectué
                    self.progression.append(self.ficheTechnique.progression[count]) // on l'ajoute au model du ViewModel
                    self.ficheTechnique.calculDenreeEtCoutMatiere()
                    
                }
                else{
                    self.result = .failure(.addEtapeError)
                }
            }
            else{
                self.result = .failure(.addEtapeError)
            }
            
        case .deleteEtape(let id):
            let count = self.ficheTechnique.progression.count
            self.ficheTechnique.progression.remove(at: id)
            if count > self.ficheTechnique.progression.count {
                self.progression.remove(at: id)
                self.ficheTechnique.calculDenreeEtCoutMatiere()
            }
            else{
                self.result = .failure(.inputError)
            }
        
        case .moveEtape(let from, let to):
            self.ficheTechnique.progression.move(fromOffsets: from, toOffset: to)
            self.progression.move(fromOffsets: from, toOffset: to)
        }
        return .none
    }
    
    func calculDenreeEtCoutMatiere(){
        self.ficheTechnique.calculDenreeEtCoutMatiere()
    }
    
    
    func changed(nomPlat: String) {
        self.nomPlat = nomPlat
    }
    
    func changed(nomAuteur: String) {
        self.nomAuteur = nomAuteur
    }
    
    func changed(nbrCouvert: Int) {
        self.couvert = nbrCouvert
    }
    
    func changed(isCalculCharge: Bool) {
        self.isCalculCharge = isCalculCharge
    }
    
    func changed(coutMatiere: Double) {
        self.coutMatiere = coutMatiere
    }
    
    func changed(dureeTotal: Double) {
        self.dureeTotal = dureeTotal
    }
    
    func changed(coutMoyenHoraire: Double) {
        self.coutMoyenHoraire = coutMoyenHoraire
    }
    
    func changed(coutForfaitaire: Double) {
        self.coutForfaitaire = coutForfaitaire
    }
    
    func changed(coefCoutProduction: Double) {
        self.coefCoutProduction = coefCoutProduction
    }
    
    func changed(coefPrixDeVente: Double) {
        self.coefPrixDeVente = coefPrixDeVente
    }
    
    func changed(categorie: String) {
        self.categorie = categorie
    }
    
    func changed(materielDressage: String?) {
        if let m = materielDressage {
            self.materielDressage = m
        }
        else{
            self.materielDressage = ""
        }
    }
    
    func changed(materielSpecifique: String?) {
        if let m = materielSpecifique {
            self.materielSpecifique = m
        }
        else{
            self.materielSpecifique = ""
        }
    }
    
}
