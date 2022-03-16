//
//  EtapeDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import SwiftUI

struct EtapeDetailView : View{
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var etapeVM : EtapeViewModel
    @ObservedObject var ingredientLVM : IngredientListViewModel
    @ObservedObject var user : UtilisateurService = UtilisateurService.instance
    
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State var isUpdate : Bool = false
    @State var isCreate : Bool
    @State var isEtapeSousFicheTechnique : Bool
    
    var intent : EtapeIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let formatter : NumberFormatter = {
       let formatter = NumberFormatter()
       formatter.numberStyle = .decimal
       formatter.decimalSeparator = ","
       return formatter
    }()
    
    init(vm : FicheTechniqueViewModel, indice : Int, vmIngredient : IngredientListViewModel,indiceSousFicheTechnique : Int? = nil, isCreate : Bool = false){
        self.intent = EtapeIntent()
        self.ingredientLVM = vmIngredient
        self.etapeVM = EtapeViewModel(ficheTechViewModel: vm, ingredientVM: vmIngredient, indice: indice,indiceSousFiche: indiceSousFicheTechnique)
        if indiceSousFicheTechnique != nil {
            self._isEtapeSousFicheTechnique = State(initialValue: true)
        }
        else{
            self._isEtapeSousFicheTechnique = State(initialValue: false)
        }
        self._isCreate = State(initialValue: isCreate)
        self.intent.addObserver(etapeVM)
    }
    
    var body: some View{
        VStack{
            Form {
                Section(header : Text("Description")){
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Nom de l'étape :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Nom", text : $etapeVM.nomEtape).onSubmit {
                                intent.intentToChange(nomEtape: etapeVM.nomEtape)
                            }.disabled(!isUpdate && !isCreate || isEtapeSousFicheTechnique).textFieldStyle(.roundedBorder)
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Temps préparation :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Nom",value: $etapeVM.dureeEtape,formatter:formatter).onSubmit {
                                intent.intentToChange(dureeEtape: etapeVM.dureeEtape)
                            }.disabled(!isUpdate && !isCreate || isEtapeSousFicheTechnique).textFieldStyle(.roundedBorder)
                        }
                    }
                    VStack{
                        Text("Description : ")
                        TextEditor(text: $etapeVM.descriptionEtape)
                            .frame(minHeight:100)
                            .textFieldStyle(.roundedBorder)
                    }
                }
            
                Section(header:HStack {
                        Text("Liste des denrées")
                        Spacer()
                        if isUpdate || isCreate && !isEtapeSousFicheTechnique {
                            Button {
                                editMode?.wrappedValue.toggle()
                            } label : {
                                editMode?.wrappedValue.isActive() ?? false ?  Label("Terminer", systemImage: "pencil.slash") : Label("Modifier", systemImage: "pencil")
                            }.padding(.trailing, 8)
                            
                            NavigationLink(destination:ChoixAjoutIngredientView(intent: intent, lvmIngredient: ingredientLVM)){
                                Label("Ajouter", systemImage: "plus.circle.fill")
                            }.padding(.trailing, 8)
                            
                        }
                    }
                ){
                    List {
                        ForEach(Array(self.etapeVM.contenu.enumerated()), id: \.offset) {
                            index, denree in
                            VStack(alignment: .leading){
                                Text("\(denree.ingredient.nomIngredient)").bold()
                                LazyVGrid(columns: columns){
                                    TextField("Nombre ",value: $etapeVM.contenu[index].nombre,formatter:formatter).onSubmit {
                                        intent.intentToChange(id: index, denreeNumber: etapeVM.contenu[index].nombre )
                                    }.disabled(!isUpdate && !isCreate || isEtapeSousFicheTechnique).textFieldStyle(.roundedBorder)
                                    Text(" \(denree.ingredient.unite) à \(String(format: "%.2f",denree.ingredient.prixUnitaire).replaceComa())€/U")
                                }
                            }
                        }
                        .onDelete{ indexSet in
                            for index in indexSet {
                                if isUpdate || isCreate {
                                    intent.intentToRemoveDenree(id: index)
                                }
                              
                            }
                        }
                    }
                }
                
            }
            .onChange(of: etapeVM.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = "\(msg)"
                    self.showingAlert.toggle()
                case let .failure(error):
                    switch error {
                    case .inputError, .addDenreeError :
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError :
                        return
                    }
                }
            }.alert(Text(alertMessage), isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    etapeVM.result = .failure(.noError)
                    self.showingAlert = false
                }
            }
            
            if !isEtapeSousFicheTechnique && user.currentUtilisateur.estConnecte(){
                HStack{
                    Button("Enregistrer l'étape"){
                        intent.intentToChange(descriptionEtape: etapeVM.descriptionEtape)
                        self.presentationMode.wrappedValue.dismiss()
                    }.padding(20)
                    
                    if !isCreate {
                        Button("\(isUpdate ? "Terminer" : "Modifier")"){
                            self.isUpdate = !self.isUpdate
                            editMode?.wrappedValue.setFalse()
                        }.padding(20)
                    }
                }.padding(20)
            }
        }.navigationBarTitle(Text("Détails de l'étape"),displayMode: .inline)

    }
    
}
