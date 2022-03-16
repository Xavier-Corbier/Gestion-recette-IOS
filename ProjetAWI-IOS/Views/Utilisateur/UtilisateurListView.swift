//
//  UtilisateurListView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//

import Foundation
import SwiftUI


struct UtilisateurListView : View {
    
    @ObservedObject var utilisateurListViewModel : UtilisateurListViewModel
    @State private var searchText : String = ""
    @State var showingAlert : Bool = false
    @State var alertMessage = ""
    @State var isActiveCreateView = false
    
    private var intent : UtilisateurIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    var utilisateursFiltre: [Utilisateur] {
        if searchText.isEmpty {
            return utilisateurListViewModel.utilisateurs
        } else {
            return utilisateurListViewModel.utilisateurs.filter{ $0.nom.uppercased().contains(searchText.uppercased()) || $0.prenom.uppercased().contains(searchText.uppercased()) }
        }
    }
    
    init(vm : UtilisateurListViewModel){
        self.utilisateurListViewModel = vm
        self.intent = UtilisateurIntent()
        self.intent.addObserver(vm)
    }
    
    var body : some View {
        NavigationView{
            VStack{
                GestionCompteView()
                    List {
                        ForEach(Array(utilisateursFiltre.enumerated()), id: \.offset){index,utilisateur in
                            NavigationLink(destination:UtilisateurDetailView(model:utilisateur)){
                                VStack(alignment: .leading){
                                    Text(utilisateur.nom + " \(utilisateur.prenom)").bold()
                                    Text("\(utilisateur.type.rawValue)")
                                }
                            }
                        }.onDelete{indexSet in
                            for index in indexSet {
                                intent.intentToDeleteUserFromList(id: index)
                            }
                        }
                    }
                    .searchable(text: $searchText,placement:.navigationBarDrawer(displayMode:.always))
                    .navigationBarTitle(Text("Liste des utilisateurs"),displayMode: .inline)
                HStack{
                    LazyVGrid(columns: columns){
                        EditButton()
                        NavigationLink(destination:UtilisateurDetailView(isFromList:false), isActive: $isActiveCreateView){
                            Text("Créer un compte")
                        }
                    }
                }.padding()
            }
            .onChange(of: utilisateurListViewModel.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
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
                    if (alertMessage == "Création effectué"){

                        self.isActiveCreateView = false
                    }
                    utilisateurListViewModel.result = .failure(.noError)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle()) // résoud erreur de contrainte
    }
}
