//
//  IngredientDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 25/02/2022.
//

import Foundation
import SwiftUI

struct IngredientDetailView: View {
    
    @ObservedObject var ingredient : IngredientViewModel
    @ObservedObject var categorieIngredientViewModel : CategorieIngredientViewModel
    @ObservedObject var allergèneViewModel : AllergèneListViewModel
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var selectedIndex : Int
    @State var ajoutCategorie : Bool = false
    var intent : IngredientIntent
    var intentAllergène : AllergèneIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    let formatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    init(vm: IngredientListViewModel, indice : Int, vmCategorie : CategorieIngredientViewModel, vmAllergene : AllergèneListViewModel){
        self.intent = IngredientIntent()
        self.intentAllergène = AllergèneIntent()
        self.ingredient = IngredientViewModel(ingrédientListViewModel: vm, indice: indice)
        self.categorieIngredientViewModel = vmCategorie
        self.allergèneViewModel = vmAllergene
        if let index = vmCategorie.tabCategorieIngredient.firstIndex(of:vm.tabIngredient[indice].categorie) {
            self.selectedIndex = index
        } else {
            self.selectedIndex = 0
        }
        self.intent.addObserver(self.ingredient)
        self.intentAllergène.addObserver(self.allergèneViewModel)
    }
    
    var body : some View {
        VStack {
            Form {
                Section(header: HStack {
                    Text("Informations")
                    Spacer()
                    Button () {
                        ajoutCategorie = !ajoutCategorie
                    } label : {
                        Label("Catégorie", systemImage: ajoutCategorie ? "slash.circle" : "plus.circle.fill")
                    }
                } ) {
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
                                    Text(self.categorieIngredientViewModel.tabCategorieIngredient[$0])
                                }
                            }.onChange(of: selectedIndex, perform: {
                                value in
                                self.intent.intentToChange(categorie: self.categorieIngredientViewModel.tabCategorieIngredient[value])
                            })
                        }

                    }
                    HStack {
                        NavigationLink(destination: MultipleSelectionAllergène(items: self.allergèneViewModel.tabAllergène,selections: $ingredient.listAllergene)){
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
                    
                }.onChange(of: ingredient.result){
                    result in
                    switch result {
                    case let .success(msg):
                        self.alertMessage = "\(msg)"
                        self.showingAlert.toggle()
                    case let .failure(error):
                        switch error {
                        case .updateError, .createError, .inputError :
                            self.alertMessage = "\(error)"
                            self.showingAlert = true
                        case .noError :
                            return
                        }
                    }
                }.alert(Text(alertMessage), isPresented: $showingAlert){
                    Button("OK", role: .cancel){
                        ingredient.result = .failure(.noError)
                        self.showingAlert = false
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
            }
            
            Spacer()
            Button("Modifier"){
                intent.intentToUpdateDatabase()
            }.padding(20)
        }
        .navigationBarTitle(Text("Détails de l'ingrédient"),displayMode: .inline)
        
    }}

