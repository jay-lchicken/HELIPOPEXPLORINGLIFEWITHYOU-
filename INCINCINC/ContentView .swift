//
//  ContentView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = LogManagementViewModel()

    var body: some View {
        VStack {
            TabView{
                LogView(viewModel: model)
                    .tabItem { Label("Log", systemImage: "list.bullet") }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
