//
//  Connexion.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 22/02/2022.
//@

import Foundation
import SwiftUI

struct ConnexionView : View, UserServiceResultObserver{
    func emit(to: Result<String, UserError>) {
        self.result = to
    }
    
    @State var email : String = ""
    @State var motDePasse : String = ""
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    
    @State var result : Result<String, UserError> = .success("")
    
    var body: some View{
        
        VStack(alignment:.center){
            Spacer()
            VStack(alignment:.center){
                Text("E-mail : ")
                TextField("test@gmail.com",text: $email).textFieldStyle(.roundedBorder).autocapitalization(.none).padding(10)
                Text("Mot de passe :")
                SecureField("Mot de passe", text: $motDePasse).textFieldStyle(.roundedBorder).autocapitalization(.none).padding(10)
                
                Button("Connexion"){
                    UtilisateurService.instance.connexion(email: email, mdp: motDePasse)
                    email = ""
                    motDePasse = ""
                }.padding(10)
                    .disabled(!email.isValidEmail() || !motDePasse.isValidPassword())
            }.padding(20).background(.gray)// 
           
            Spacer()
        }.padding()
            .onChange(of: result){
                result in
                switch result {
                case let .success(msg):
                    self.alertMessage = msg
                    self.showingAlert = true
                case let .failure(error):
                    switch error {
                    case .connexioError:
                        self.alertMessage = "\(error)"
                        self.showingAlert = true
                    default :
                        return
                    }
                }
            }
            .alert("\(alertMessage)", isPresented: $showingAlert){
                Button("OK", role: .cancel){
                    result = .failure(.noError)
                }
            }
            .onAppear(){
                UtilisateurService.instance.addObserverResult(obs: self)
            }
        
    }
    
}
