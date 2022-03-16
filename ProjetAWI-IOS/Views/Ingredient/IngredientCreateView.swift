//
//  IngredientCreateView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 27/02/2022.
//

import Foundation
import SwiftUI

struct IngredientCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    var intent : IngredientIntent
    var intentAllergène : AllergèneIntent
    @ObservedObject var ingredient : IngredientViewModel
    @ObservedObject var categorieIngredientViewModel : CategorieIngredientViewModel
    @ObservedObject var allergèneViewModel : AllergèneListViewModel
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var selectedIndex : Int = 0
    @State var ajoutCategorie : Bool = false
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    init(vm: CategorieIngredientViewModel, vmAllergène : AllergèneListViewModel){
        self.intent = IngredientIntent()
        self.intentAllergène = AllergèneIntent()
        self.categorieIngredientViewModel = vm
        self.allergèneViewModel = vmAllergène
        self.ingredient = IngredientViewModel()
        self.intentAllergène.addObserver(vmAllergène)
        self.intent.addObserver(self.ingredient)
    }
    
    var body : some View {
        VStack {
            Form{
                Section(header:  HStack {
                    Text("Informations")
                    Spacer()
                    Button () {
                        ajoutCategorie = !ajoutCategorie
                    } label : {
                        Label("Catégorie", systemImage: ajoutCategorie ? "slash.circle" : "plus.circle.fill")
                    }
                }) {
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Nom :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Nom",text: $ingredient.nomIngredient)
                                .onSubmit {
                                    intent.intentToChange(nomIngrédient: ingredient.nomIngredient)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Prix unitaire :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Prix unitaire",value: $ingredient.prixUnitaire, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(prixUnitaire: ingredient.prixUnitaire)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Quantité :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Quantité",value: $ingredient.qteIngredient, formatter: formatter)
                                .onSubmit {
                                    intent.intentToChange(quantité: ingredient.qteIngredient)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Unité :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Unité",text: $ingredient.unite)
                                .onSubmit {
                                    intent.intentToChange(unite: ingredient.unite)
                                }
                        }
                    }
                    HStack {
                        if ajoutCategorie {
                            LazyVGrid(columns: columns){
                                Text("Categorie :").frame(maxWidth: .infinity, alignment: .leading)
                                TextField("Categorie",text: $ingredient.categorie)
                                    .onSubmit {
                                        intent.intentToChange(categorie: ingredient.categorie)
                                    }
                            }
                        } else {
                            Picker(selection: $selectedIndex, label: Text("Categorie :")) {
                                ForEach(0 ..< categorieIngredientViewModel.tabCategorieIngredient.count) {
                                    if categorieIngredientViewModel.tabCategorieIngredient.indices.contains($0) {
                                       Text(categorieIngredientViewModel.tabCategorieIngredient[$0])
                                    } else {
                                        Text("")
                                    }
                                }
                            }.onChange(of: selectedIndex, perform: {
                                value in
                                self.intent.intentToChange(categorie: self.categorieIngredientViewModel.tabCategorieIngredient[value])
                            })
                        }
                    }
                    HStack {
                        NavigationLink(destination: MultipleSelectionAllergène(items: self.allergèneViewModel.tabAllergène, selections: $ingredient.listAllergene)){
                            HStack {
                                Text("Liste allergènes :")
                                Spacer()
                                Text("Modifier")
                                    .foregroundColor(Color.gray)
                            }
                        }.onChange(of: ingredient.listAllergene, perform: { value in
                            self.intent.intentToChange(listIngredient: value)
                        })
                    }
                }
                Section(header: Text("Allergènes contenu")){
                    VStack(alignment: .leading){
                        if $ingredient.listAllergene.count == 0 {
                            Text("Cet ingrédient ne contient pas d'allergènes")
                        } else {
                            List {
                                ForEach(Array(ingredient.listAllergene.enumerated()), id: \.offset) {
                                    _, allergène in
                                    VStack(alignment: .leading) {
                                        Text(allergène)
                                    }.padding(2)
                                }
                            }
                        }
                    }
                }
            }.onChange(of: ingredient.result){
                    result in
                    switch result {
                    case let .success(msg):
                       self.alertMessage = msg
                       self.showingAlert = true
                        break
                    case let .failure(error):
                        switch error {
                        case .updateError, .createError , .inputError:
                            self.alertMessage = "\(error)"
                            self.showingAlert = true
                        case .noError :
                            return
                        }
                    }
                }
                .alert(Text(alertMessage), isPresented: $showingAlert){
                    Button("OK", role: .cancel){
                        ingredient.result = .failure(.noError)
                        self.showingAlert = false
                    }
                }
            Spacer()
            Button("Ajout"){
                intent.intentToAddIngredient()
                self.presentationMode.wrappedValue.dismiss()
            }.padding(20)
        }
        .navigationBarTitle(Text("Ajout d'ingredient"),displayMode: .inline)
        
    }}

