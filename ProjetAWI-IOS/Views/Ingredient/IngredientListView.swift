//
//  IngredientListView.swift
//  ProjetAWI-IOS
//
//  Created by etud on 23/02/2022.
//

import SwiftUI


struct IngredientListView : View {
    
    @ObservedObject var ingredientListViewModel : IngredientListViewModel
    @ObservedObject var categorieIngredientViewModel : CategorieIngredientViewModel
    @ObservedObject var allergèneViewModel : AllergèneListViewModel
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    @State private var selectedCategorie : String = "Choisir"
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    var intent: IngredientIntent
    var intentAllergène: AllergèneIntent
    var ingredientsFiltre: [Ingredient] {
        if searchText.isEmpty &&  selectedCategorie == "Choisir" {
            return ingredientListViewModel.tabIngredient
        } else {
            if selectedCategorie == "Choisir" {
                return ingredientListViewModel.tabIngredient.filter{ $0.nomIngredient.uppercased().contains(searchText.uppercased()) }
            } else if searchText.isEmpty {
                return ingredientListViewModel.tabIngredient.filter{ $0.categorie.uppercased().contains(selectedCategorie.uppercased()) }
            } else {
                return ingredientListViewModel.tabIngredient.filter{ $0.nomIngredient.uppercased().contains(searchText.uppercased()) && $0.categorie.uppercased().contains(selectedCategorie.uppercased()) }
            }
        }
    }
    
    init(vm : IngredientListViewModel, vmCategorie : CategorieIngredientViewModel, vmAllergene : AllergèneListViewModel){
        self.ingredientListViewModel = vm
        self.allergèneViewModel = vmAllergene
        self.intent = IngredientIntent()
        self.intentAllergène = AllergèneIntent()
        self.intentAllergène.addObserver(vmAllergene)
        self.intent.addObserver(vm)
        self.categorieIngredientViewModel = vmCategorie
    }
    
    var body : some View {
        NavigationView {
            VStack {
                Form {
                    Picker(selection: $selectedCategorie, label: Text("Categorie")) {
                        ForEach(self.categorieIngredientViewModel.tabCategorieIngredient, id: \.self) { categorie in
                            Text(categorie)
                        }
                    }
                }.frame(height: 100)
                List {
                    ForEach(Array(ingredientsFiltre.enumerated()), id: \.offset) {
                        index, ingredient in
                            HStack{
                                NavigationLink(destination: IngredientDetailView(vm: self.ingredientListViewModel, indice: index, vmCategorie: self.categorieIngredientViewModel, vmAllergene: self.allergèneViewModel)){
                                    VStack(alignment: .leading) {
                                        Text(ingredient.nomIngredient).bold()
                                        HStack {
                                            Text(String(format: "%.2f",ingredient.qteIngredient).replaceComa() + " " + ingredient.unite)
                                            Text("à " + String(format: "%.2f",ingredient.prixUnitaire).replaceComa())
                                            Text("€/" + ingredient.unite)
                                        }
                                    }
                                }
                            }
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            intent.intentToDeleteIngredient(id: index)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle(Text("Liste des ingrédients"),displayMode: .inline)
                HStack{
                    LazyVGrid(columns: columns){
                        EditButton()
                        NavigationLink(destination: IngredientCreateView(vm: CategorieIngredientViewModel(), vmAllergène: self.allergèneViewModel)){
                            Text("Ajout")
                        }
                    }
                }.padding()
            }
            .onChange(of: ingredientListViewModel.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                    //self.intentAllergène.intentToUpdateIngredientFromAllergène()
                case let .failure(error):
                    switch error {
                    case .noError :
                        return
                    case .deleteError:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    ingredientListViewModel.result = .failure(.noError)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle()) // résoud erreur de contrainte

        
    }
    
}
