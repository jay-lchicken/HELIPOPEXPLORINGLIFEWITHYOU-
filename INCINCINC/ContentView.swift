//
//  ContentView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = LogManagementViewModel()
    @AppStorage("darkMode") var darkMode: Bool = false
    var body: some View {
        VStack {
            TabView{
                HomeView()
                    .tabItem({
                        Label("Home", systemImage: "house.circle")
                    })
                LogView(viewModel: model)
                    .tabItem { Label("Log", systemImage: "list.bullet") }
                SettingsView(viewModel: model)
                    .tabItem { Label("Settings", systemImage: "gearshape")
                    }
            }
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        .environment(\.sizeCategory, model.fontSize)
        
    }
}

#Preview {
    ContentView()
}
