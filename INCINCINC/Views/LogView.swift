//
//  LogView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

struct LogView: View {
    @State var showNewItemView: Bool = false
    @ObservedObject var viewModel : LogManagementViewModel
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
                            viewModel.deleteData(index: i)
                        }label:{
                            Text("Delete")
                        }
                    }
                }
            }
            .toolbar{
                Button{
                    showNewItemView.toggle()
                }label: {
                    Label("Add New Log", systemImage: "plus")
                }
            }
            .navigationTitle("Log View")
            
        }
        .sheet(isPresented: $showNewItemView){
            NewLogView(viewModel: viewModel)
        }
        
    }
}

