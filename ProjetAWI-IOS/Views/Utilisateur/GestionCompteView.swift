//
//  GestionCompte.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 25/02/2022.
//

import Foundation
import SwiftUI

struct GestionCompteView : View {
    
    @ObservedObject var user : UtilisateurService = UtilisateurService.instance
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]

    var body : some View{
        if !user.currentUtilisateur.estAdmin(){
            NavigationView{
                HStack{
                    LazyVGrid(columns: columns){
                        NavigationLink(destination:UtilisateurDetailView(model:user.currentUtilisateur,isFromList:false)){
                            Text("Mon compte")
                        }
                        Button("Déconnexion"){
                            user.deconnexion()
                            
                        }
                    }
                }.padding()
            }.navigationTitle("Gestion du compte")
        }
        else{
            HStack{
                LazyVGrid(columns: columns){
                    NavigationLink(destination:UtilisateurDetailView(model:user.currentUtilisateur,isFromList:false)){
                        Text("Mon compte")
                    }
                    Button("Déconnexion"){
                        user.deconnexion()
                        
                    }
                }
            }.padding()
        }
    }
}
