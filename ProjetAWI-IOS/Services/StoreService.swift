//
//  StoreService.swift
//  ProjetAWI-IOS
//
//  Created by etud on 22/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol StoreServiceObserver{
    func emit( to : Store)
    func emit(to: Result<String,StoreViewModelError>)
}

class StoreService {
    public static let instance = StoreService()
    private let firestore = Firestore.firestore()
    private var tabObserver : [StoreServiceObserver] = []
    var store : Store {
        didSet {
            for observer in tabObserver {
                observer.emit(to: store)
            }
        }
    }
    
    private init(){
        self.store = Store(coefCoûtProduction: 0, coefPrixDeVente: 0, coûtForfaitaire: 0, coûtMoyen: 0)
    }
    
    func addObserver(observer : StoreServiceObserver){
        self.tabObserver.append(observer)
        observer.emit(to: store)
    }
    
    func getStore(){
        firestore.collection("preferences").document("store")
            .addSnapshotListener{
                (data,error) in
                guard (data) != nil else{
                    return
                }
                self.store = StoreDTO.transformDTO(
                    StoreDTO(coefCoûtProduction: data?.data()!["coefCoûtProduction"] as? Double ?? 0 ,
                             coefPrixDeVente: data?.data()!["coefPrixDeVente"] as? Double ?? 0,
                             coûtForfaitaire: data?.data()!["coûtForfaitaire"] as? Double ?? 0,
                             coûtMoyen: data?.data()!["coûtMoyen"] as? Double ?? 0))
            }
    }
    
    func updateStore(store : Store) {
        let ref = firestore.collection("preferences").document("store")
        ref.updateData(StoreDTO.transformToDTO(store)) {
            (error) in
            if let _ = error {
                self.sendResult(result: .failure(.updateError))
            } else {
                self.sendResult(result: .success("Mise a jour effectué"))
            }
        }
    }
    
    private func sendResult(result : Result<String,StoreViewModelError>){
        for observer in self.tabObserver {
            observer.emit(to: result)
        }
    }
}
