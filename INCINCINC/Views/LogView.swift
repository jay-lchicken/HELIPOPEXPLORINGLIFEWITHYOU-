//
//  LogView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

struct LogView: View {
    @ObservedObject var viewModel : LogManagementViewModel
    @State var index = 0
    var body: some View {
        NavigationStack{
            List(viewModel.logs.indices, id: \.self){i in
                NavigationLink{
                    LogDetailsView(log: $viewModel.logs[i])
                }label: {
                    VStack{
                        HStack{
                            Text("Name of Accomplice: \(viewModel.logs[i].nameOfAccomplice)")
                            Spacer()
                        }
                        HStack{
                            Text("Date Added: \(Date(timeIntervalSince1970: viewModel.logs[i].dateAdded).formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                            Spacer()
                        }
                    }
                    .contextMenu{
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
                        viewModel.logs.remove(at: index)
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
            }
            .navigationTitle("Log View")
            
        }
        .sheet(isPresented: $viewModel.showNewItemView){
            informationField(model: viewModel)
        }
        
    }
}

