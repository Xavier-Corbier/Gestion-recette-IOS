//
//  FicheTechniqueService.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 28/02/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FicheTechniqueListServiceObserver {
    func emit(to: [FicheTechnique])
    func emit(to: Result<String,FicheTechniqueListViewModelError>)
}

protocol FicheTechniqueServiceObserver {
    func emit(to : Result<String, FicheTechniqueViewModelError>)
}

class FicheTechniqueService {
    private let firestore = Firestore.firestore()
    private var tabFicheTechnique : [FicheTechnique] {
        didSet {
            self.observerList?.emit(to: tabFicheTechnique)
        }
    }
    
    
    private var observerList : FicheTechniqueListServiceObserver? = nil
    private var observerElement : FicheTechniqueServiceObserver? = nil
    
    
    
    init(){
        self.tabFicheTechnique = []
    }
    
    func setObserver(obs : FicheTechniqueListServiceObserver){
        self.observerList = obs
        obs.emit(to: tabFicheTechnique)
    }
    
    func setObserver(obs : FicheTechniqueServiceObserver){
        self.observerElement = obs
    }
    
    func removeObserver(obs : FicheTechniqueServiceObserver){
        self.observerElement = nil
    }
    
    private func sendResultElement(result : Result<String,FicheTechniqueViewModelError>){
        self.observerElement?.emit(to: result)
    }
    
    private func sendResultList(result : Result<String,FicheTechniqueListViewModelError>){
        self.observerList?.emit(to: result)
    }
    
    
    func getAllFicheTechnique(){
        firestore.collection("fiche-techniques").addSnapshotListener {
            (data, error) in
            guard let documents = data?.documents else {
                return
            }
            self.tabFicheTechnique = documents.map{
                (doc) -> FicheTechnique in
                return FicheTechniqueDTO.transformDTO(
                    FicheTechniqueDTO.docToDTO(doc: doc))
            }
        }
    }
    
    func addFicheTechnique(fiche : FicheTechnique, newCategorie : String? ){
        if fiche.isValid {
            firestore.collection("fiche-techniques").addDocument(data: FicheTechniqueDTO.transformToDTO(fiche)){
                (error) in
                if let _ = error {
                    self.sendResultElement(result: .failure(.createError))
                }
                else{
                    self.sendResultList(result: .success("Ajout effectué !"))
                    if let cate = newCategorie {
                        CategorieRecetteService().addCategorie(nom: cate)
                    }
                }
            }
        }
        else{
            self.sendResultElement(result: .failure(.noValid))
        }
    }
    
    func removeFicheTechnique(id : String, categorie : String ){
        firestore.collection("fiche-techniques").document("\(id)").delete() {
            (error) in if let _ = error {
                self.sendResultElement(result: .failure(.deleteError))
            }
            else{
                self.sendResultList(result: .success("Supression effectuée !"))
                self.checkIfDeleteCategorieRecette(categorie: categorie)
            }
        }
      
    }
    
    func updateFicheTechnique(fiche : FicheTechnique,isChangeCategorie : Bool = false){
        if fiche.isValid {
            if isChangeCategorie { // on récupère son ancienne catégorie pour voir si on la supprime
                var oldCategorie : String = ""
                getFicheTechniqueBD(id: fiche.header.id){ficheGet in
                    oldCategorie = ficheGet.header.categorie
                    self.updateFicheTechniqueBD(fiche: fiche, oldCategorie: oldCategorie)
                }
            }
            else{
                self.updateFicheTechniqueBD(fiche: fiche)
            }
        }
        else{
            self.sendResultElement(result: .failure(.noValid))
        }
    }
    
    private func updateFicheTechniqueBD(fiche : FicheTechnique, oldCategorie : String?=nil){
        firestore.collection("fiche-techniques").document("\(fiche.header.id)").updateData(FicheTechniqueDTO.transformToDTO(fiche)){
            (error) in
            if let _ = error {
                self.sendResultElement(result: .failure(.createError))
            }
            else{
                self.sendResultList(result: .success("Modification enregistrée !"))
                if let old = oldCategorie {
                    CategorieRecetteService().addCategorie(nom: fiche.header.categorie)
                    self.checkIfDeleteCategorieRecette(categorie: old)
                }
            }
        }
    }
    
    
    func getFicheTechniqueBD(id : String, action : ((FicheTechnique) -> Void)?){
        firestore.collection("fiche-techniques").document("\(id)").getDocument(){
            (querySnapshot, err) in
            if let err = err {
                print("Error getting document : \(err)")
                self.sendResultElement(result: .failure(.inputError))
            }
            else{
                if let data = querySnapshot?.data() {
                    action?(FicheTechniqueDTO.transformDTO(
                        FicheTechniqueDTO.docToDTO(doc: data, id:querySnapshot!.documentID)))
                }
                else{
                    self.sendResultElement(result: .failure(.inputError))
                }
            }
        }
    }
    
    // Récupère une fiche technique pour la mettre en étape d'une autre fiche
    // Elle ne doit pas contenir de sous-fiche technique
    func getFicheTechnique(id : String) -> FicheTechnique?{
        let fiches : [FicheTechnique] = tabFicheTechnique.filter{ (fiche) -> Bool in
            fiche.header.id == id && fiche.progression.filter { (etapeFiche) -> Bool in
                etapeFiche.estSousFicheTechnique
            }.count == 0 // on est sûr qu'elle ne contient pas de sous fiche technique
        }
        if fiches.count == 1 {
            return fiches[0]
        }
        else {
            return nil
        }
    }
    
    
    /*
        Regarde si une catégorie est vide, si c'est le cas elle le supprime
     */
    
    func checkIfDeleteCategorieRecette(categorie : String){
        firestore.collection("fiche-techniques").whereField("header.categorie", isEqualTo: categorie)
            .getDocuments(){
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting document : \(err)")
                }
                else{
                    if querySnapshot!.documents.count == 0 {
                        // 0 fiche technique avec cette recette => on supprime
                        CategorieRecetteService().deleteCategorie(nom:categorie)
                    }
                }
            }
    }
    
    
    
    

}
