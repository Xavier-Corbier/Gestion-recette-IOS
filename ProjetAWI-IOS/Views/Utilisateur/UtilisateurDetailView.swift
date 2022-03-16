//
//  UtilisateurDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 19/02/2022.
//


import Foundation
import SwiftUI


struct UtilisateurDetailView : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var utilisateurViewModel : UtilisateurViewModel
    @StateObject var user : UtilisateurService = UtilisateurService.instance
    @State private var isUpdate : Bool = false
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var isCreate : Bool
    @State private var isFromList : Bool
    
    var intent : UtilisateurIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    
    init(model : Utilisateur = Utilisateur(email: "", nom: "", prenom: "", type: .User, id: ""), isFromList : Bool = true){
        self._isCreate = State(initialValue:  (model.email.count == 0))
        self._isFromList = State(initialValue: isFromList)
        
        self.intent = UtilisateurIntent()
        self.utilisateurViewModel = UtilisateurViewModel(from: model)
    
        self.intent.addObserver(self.utilisateurViewModel)
    }
    
    var disabledTextField : Bool {
        return !isCreate && !isUpdate
    }
 
    var body : some View{
        VStack{
            Form {
                Section(header: Text("Informations")) {
                    HStack{
                        LazyVGrid(columns: columns, alignment: .leading){
                            Text("E-mail : ")
                            TextField("E-mail", text : $utilisateurViewModel.email).disabled(disabledTextField).onSubmit {
                                intent.intentToChange(email: utilisateurViewModel.email)
                            }
                        }
                    }
                    if (isCreate || isUpdate) && (!user.currentUtilisateur.estAdmin() || !isFromList) {
                        HStack{
                            LazyVGrid(columns: columns, alignment: .leading){
                                Text("Mot de passe : ")
                                SecureField("Mot de passe", text : $utilisateurViewModel.motDePasse).disabled(disabledTextField)
                                    .onSubmit {
                                        intent.intentToChange(password: utilisateurViewModel.motDePasse)
                                    }
                            }
                        }
                    }
                }
                Section {
                    HStack{
                        LazyVGrid(columns: columns, alignment: .leading){
                            Text("Nom : ")
                            TextField("Nom",text : $utilisateurViewModel.nom)
                                .disabled(disabledTextField)
                                .onSubmit {
                                    intent.intentToChange(name: utilisateurViewModel.nom)
                                }
                        }
                    }
                    HStack{
                        LazyVGrid(columns: columns, alignment: .leading){
                            Text("Prénom : ")
                            TextField("Prenom",text : $utilisateurViewModel.prenom)
                                .disabled(disabledTextField)
                                .onSubmit {
                                    intent.intentToChange(firstName: utilisateurViewModel.prenom)
                                }
                        }
                    }
                    if user.currentUtilisateur.estAdmin(){
                        HStack{
                            Picker("Rôle", selection : $utilisateurViewModel.type){
                                Text("User").tag(TypeUtilisateur.User)
                                Text("Admin").tag(TypeUtilisateur.Admin)
                            }.disabled(disabledTextField)
                                .onChange(of: utilisateurViewModel.type, perform: {
                                    value in
                                    intent.intentToChange(type: value)
                                })
                        }
                    }
                }
            }.autocapitalization(.none).padding(10)
            HStack{
                
                if !isCreate {
                    Spacer()
                    
                    Button("Supprimer"){
                        intent.intentToDeleteUser()
                        self.presentationMode.wrappedValue.dismiss()
                    }.padding(20)
                    
                    Spacer()
                    
                    Button("Enregistrer"){
                        intent.intentToUpdateDatabase()
                        utilisateurViewModel.motDePasse = ""
                    }.disabled(user.currentUtilisateur.estAdmin() ? isFromList ? !utilisateurViewModel.isValidForAdmin : !utilisateurViewModel.isValid : !utilisateurViewModel.isValid).padding(20)
                    
                    Spacer()
                    
                    Button(isUpdate ? "Terminer" : "Modifier"){
                        self.isUpdate = !self.isUpdate
                    }.padding(20)
                    
                    Spacer()
                }
                else {
                    Button("Créer le compte"){
                        intent.intentToCreateUser()
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }.disabled(!utilisateurViewModel.isValid).padding(20)
                }
            }
        }.navigationTitle("Détail \(utilisateurViewModel.nom)")
            .padding()
            .onChange(of: utilisateurViewModel.result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .updateError, .createError, .deleteError, .emailError, .errorName, .mdpError, .errorFirstName:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    case .noError,.connexioError :
                        return
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    utilisateurViewModel.result = .failure(.noError)
                }
            }.onAppear(){
                self.utilisateurViewModel.addObserverResult()
            }.onDisappear(){
                self.utilisateurViewModel.removeObserverResult()
            }
        
    }
}
