//
//  StoreIntent.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//
import Foundation
import Combine

enum StoreIntentState : Equatable {
    case ready
    case changingCoefCoûtProduction(Double)
    case changingCoefPrixDeVente(Double)
    case changingCoûtForfaitaire(Double)
    case changingCoûtMoyen(Double)
    case updateDatabase
}


struct StoreIntent  {
    private var state = PassthroughSubject<StoreIntentState,Never>()
    
    func intentToChange(coefCoûtProduction : Double){
        self.state.send(StoreIntentState.changingCoefCoûtProduction(coefCoûtProduction))
    }
    
    func intentToChange(coefPrixDeVente : Double) {
        self.state.send(StoreIntentState.changingCoefPrixDeVente(coefPrixDeVente))
    }
    
    func intentToChange(coûtForfaitaire : Double){
        self.state.send(StoreIntentState.changingCoûtForfaitaire(coûtForfaitaire))
    }
    
    func intentToChange(coûtMoyen : Double){
        self.state.send(StoreIntentState.changingCoûtMoyen(coûtMoyen))
    }
    
    func intentToUpdateDatabase(){
        self.state.send(StoreIntentState.updateDatabase)
    }
    
    func addObserver(_ storeViewModel : StoreViewModel){
        self.state.subscribe(storeViewModel)
    }
}
