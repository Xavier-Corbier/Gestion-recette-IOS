//
//  AllergèneDetailView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import Foundation
import SwiftUI

struct AllergèneCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var allergène : AllergèneViewModel
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    var intent : AllergèneIntent
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    
    init(){
        self.intent = AllergèneIntent()
        self.allergène = AllergèneViewModel()
        self.intent.addObserver(self.allergène)
    }
    
    var body : some View {
        VStack {
            Form {
                Section(header: Text("Informations")) {
                    HStack{
                        LazyVGrid(columns: columns){
                            Text("Nom de l'allergène :").frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Nom de l'allergène",text: $allergène.nom)
                                .onSubmit {
                                    intent.intentToChange(nom: allergène.nom)
                                }
                        }
                    }.onChange(of: allergène.result){
                            result in
                            switch result {
                            case let .success(msg):
                               self.alertMessage = msg
                               self.showingAlert = true
                                break
                            case let .failure(error):
                                switch error {
                                case .updateError, .createError, .inputError :
                                    self.alertMessage = "\(error)"
                                    self.showingAlert = true
                                case .noError :
                                    return
                                }
                            }
                        }
                        .alert(Text(alertMessage), isPresented: $showingAlert){
                            Button("OK", role: .cancel){
                                allergène.result = .failure(.noError)
                                self.showingAlert = false
                            }
                        }
                }
            }
            Spacer()
            Button("Ajout"){
                intent.intentToAddAllergène()
                self.presentationMode.wrappedValue.dismiss()
            }.padding(20)
        }
        .navigationBarTitle(Text("Ajout d'allergène"),displayMode: .inline)
    }
}
