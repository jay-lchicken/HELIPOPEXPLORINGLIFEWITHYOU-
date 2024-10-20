//
//  LogView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

struct LogView: View {
    @ObservedObject var viewModel : LogManagementViewModel
    @State var isPresented: Bool = false
    @State var index = 0
    var body: some View {
        NavigationStack{
            List(viewModel.logs.indices.sorted(by: {
                viewModel.logs[$0].dateAdded > viewModel.logs[$1].dateAdded
            }), id: \.self){i in
                NavigationLink{
                    LogDetailsView(log: $viewModel.logs[i])
                }label: {
                    VStack{
                        HStack{
                            Text("Name of Accomplice: \(viewModel.logs[i].nameOfAccomplice)")
                            Spacer()
                        }
                        HStack{
                            Text("Date occurred: \(Date(timeIntervalSince1970: viewModel.logs[i].dateHappened).formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                            Spacer()
                        }
                    }
                    .contextMenu{
                        
                        Button(){
                            viewModel.isEditing = true
                            index = i
                            viewModel.generator.notificationOccurred(.success)
                            viewModel.nameOfAccomplice = viewModel.logs[i].nameOfAccomplice
                            viewModel.whyWasTheCoinStolen = viewModel.logs[i].whyStolen
                            viewModel.howWasTheCoinStolen = viewModel.logs[i].howTheyStoleTheCoin
                            viewModel.locationFled = viewModel.logs[i].locationFled.toCLLocationCoordinate2D()
                            viewModel.locationNow = viewModel.logs[i].whereAreTheyNow.toCLLocationCoordinate2D()
                            viewModel.coinsCount = viewModel.logs[i].coinsCount
                            viewModel.dateHappened = Date(timeIntervalSince1970: viewModel.logs[i].dateHappened)
                        }label:{
                            Text("Edit")
                        }
                        Button(role:.destructive){
                            index = i
                            viewModel.showAlert = true
                            viewModel.generator.notificationOccurred(.warning)
                            
                        }label:{
                            Text("Delete")
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Confirm Deletion?"),
                    message: Text("Are you sure you want to delete this log?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteData(index: index)
                        
                        viewModel.generator.notificationOccurred(.success)
                    },
                    secondaryButton: .cancel()
                )
            }

            .toolbar{
                Button{
                    viewModel.showNewItemView.toggle()
                    viewModel.generator.notificationOccurred(.success)
                }label: {
                    Label("Add New Log", systemImage: "plus")
                }
                Button{
                    isPresented.toggle()
                }label: {
                    Label("Show Dashboard", systemImage: "point.3.connected.trianglepath.dotted")
                }

            }
            .navigationTitle("Log View")
            
        }
        .sheet(isPresented: $viewModel.showNewItemView){
            informationField(model: viewModel)
        }
        .sheet(isPresented: $viewModel.isEditing, content: {editInformationField(model: viewModel, editIndex: index)})
        .sheet(isPresented: $isPresented){
            ConnectedView(viewModel: viewModel)
        }
        
    }
}

