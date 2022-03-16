//
//  FicheTechniqueIntent.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 01/03/2022.
//

import Foundation
import Combine
import SwiftUI

enum FicheTechniqueListIntentState : Equatable {
    case ready
    case deleteFicheTechnique(Int)
}

enum FicheTechniqueIntentState : Equatable {
    case ready
    case updateFicheTechnique(Bool)
    case addFicheTechnique(String?)
    case deleteFicheTechnique
    
    case changingNomPlat(String)
    case changingNomAuteur(String)
    case changingCategorie(String)
    case changingNbrCouvert(Int)
    case changingMaterielSpecifique(String)
    case changingMaterielDressage(String)
    case changingCoefProd(Double)
    case changingCoefVente(Double)
    case changingCoutForfaitaire(Double)
    case changingCoutMoyenHoraire(Double)
    case changingIsCalculCharge(Bool)
    
    case moveEtape(IndexSet,Int)
    case deleteEtape(Int)
    case addEtape
    case addSousFicheTechnique(String)
    // changing
}



struct FicheTechniqueIntent {
    private var stateList = PassthroughSubject<FicheTechniqueListIntentState, Never>()
    private var stateElement = PassthroughSubject<FicheTechniqueIntentState, Never>()

    
    /* Function for update the database */
    
    func intentToDeleteFicheTechniqueFromList(id : Int){
        self.stateList.send(FicheTechniqueListIntentState.deleteFicheTechnique(id))
    }
    
    func intentToDeleteFicheTechniqueFromDetail(){
        self.stateElement.send(FicheTechniqueIntentState.deleteFicheTechnique)
    }
    
    func intentToAddFicheTechnique(newCategorie : String? = nil){
        self.stateElement.send(FicheTechniqueIntentState.addFicheTechnique(newCategorie))
    }
    
    func intentToUpdateFicheTechnique(isChangeCategorie : Bool = false){
        self.stateElement.send(FicheTechniqueIntentState.updateFicheTechnique(isChangeCategorie))
    }
    
    /* ---- Fiche technique (Header - liste étapes )--- */
    
    func intentToChange(nomPlat : String){
        self.stateElement.send(FicheTechniqueIntentState.changingNomPlat(nomPlat))
    }
    
    func intentToChange(nomAuteur : String){
        self.stateElement.send(FicheTechniqueIntentState.changingNomAuteur(nomAuteur))
    }
    
    func intentToChange(categorie : String){
        self.stateElement.send(FicheTechniqueIntentState.changingCategorie(categorie))
    }
    
    func intentToChange(nbrCouvert : Int){
        self.stateElement.send(FicheTechniqueIntentState.changingNbrCouvert(nbrCouvert))
    }
    
    func intentToChange(materielDressage : String){
        self.stateElement.send(FicheTechniqueIntentState.changingMaterielDressage(materielDressage))
    }
    
    func intentToChange(materielSpecifique : String){
        self.stateElement.send(FicheTechniqueIntentState.changingMaterielSpecifique(materielSpecifique))
    }

    func intentToMoveEtape(from : IndexSet, to : Int){
        self.stateElement.send(FicheTechniqueIntentState.moveEtape(from, to))
    }
    
    func intentToAddEtape(){
        self.stateElement.send(FicheTechniqueIntentState.addEtape)
    }
    
    func intentToAddSousFicheTechnique(id : String){
        self.stateElement.send(FicheTechniqueIntentState.addSousFicheTechnique(id))
    }
    
    func intentToRemoveEtape(id : Int){
        self.stateElement.send(FicheTechniqueIntentState.deleteEtape(id))
    }
    
    func intentToChange(coefProd : Double){
        self.stateElement.send(FicheTechniqueIntentState.changingCoefProd(coefProd))
    }
    
    func intentToChange(coutMoyenHoraire : Double){
        self.stateElement.send(FicheTechniqueIntentState.changingCoutMoyenHoraire(coutMoyenHoraire))
    }
    
    func intentToChange(coefVente : Double){
        self.stateElement.send(FicheTechniqueIntentState.changingCoefVente(coefVente))
    }
    
    func intentToChange(coutForfaitaire : Double){
        self.stateElement.send(FicheTechniqueIntentState.changingCoutForfaitaire(coutForfaitaire))
    }
    
    func intentToChange(isCalculCharge : Bool){
        self.stateElement.send(FicheTechniqueIntentState.changingIsCalculCharge(isCalculCharge))
    }
    
  
    // addObserver
    func addObserver (_ fiche : FicheTechniqueViewModel) {
        self.stateElement.subscribe(fiche)
    }
    
    func addObserver (_ ficheList : FicheTechniqueListViewModel){
        self.stateList.subscribe(ficheList)
    }
    
}
