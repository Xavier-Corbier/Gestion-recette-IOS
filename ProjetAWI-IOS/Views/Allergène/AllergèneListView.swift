//
//  AllergèneListView.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 24/02/2022.
//

import SwiftUI


struct AllergèneListView : View {
    
    @ObservedObject var allergèneListViewModel : AllergèneListViewModel
    @State var alertMessage = ""
    @State var showingAlert : Bool = false
    @State private var searchText : String = ""
    let columns : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    var intent: AllergèneIntent
    var allergènesFiltre: [Allergène] {
        if searchText.isEmpty {
            return allergèneListViewModel.tabAllergène
        } else {
            return allergèneListViewModel.tabAllergène.filter{ $0.nom.uppercased().contains(searchText.uppercased()) }
        }
    }
    
    init(vm : AllergèneListViewModel){
        self.allergèneListViewModel = vm
        self.intent = AllergèneIntent()
        self.intent.addObserver(vm)
    }
    
    var body : some View {
        NavigationView {
            VStack {
                
                List {
                    ForEach(Array(allergènesFiltre.enumerated()), id: \.offset) {
                        index, allergène in
                            HStack{
                                NavigationLink(destination: AllergèneDetailView(vm: self.allergèneListViewModel, indice: index)){
                                    VStack(alignment: .leading) {
                                        Text(allergène.nom).bold()
                                    }
                                }
                            }
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            intent.intentToDeleteAllergène(id: index)
                        }
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle(Text("Liste des allergènes"),displayMode: .inline)
                HStack{
                    LazyVGrid(columns: columns){
                        EditButton()
                        NavigationLink(destination: AllergèneCreateView()){
                            Text("Ajout")
                        }
                    }
                }.padding()
            }
            .onChange(of: allergèneListViewModel.result){
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
                    allergèneListViewModel.result = .failure(.noError)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle()) // résoud erreur de contrainte
    }
}
