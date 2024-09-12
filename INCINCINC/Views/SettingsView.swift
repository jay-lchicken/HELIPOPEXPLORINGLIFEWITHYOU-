//
//  SettingsView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/10/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel : LogManagementViewModel
    @AppStorage("darkMode") var darkMode: Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Toggle(isOn: $darkMode ){
                        Text("Dark Mode: \(darkMode ? "On" : "Off")")
                    }
                    
                    Picker("Font Size: \(viewModel.fontSize.hashValue)", selection: $viewModel.fontSize) {
                                    Text("Extra Small").tag(ContentSizeCategory.extraSmall)
                                    Text("Small").tag(ContentSizeCategory.small)
                                    Text("Medium").tag(ContentSizeCategory.medium)
                                    Text("Large").tag(ContentSizeCategory.large)
                                    Text("Extra Large").tag(ContentSizeCategory.extraLarge)
                                    Text("Extra Extra Large").tag(ContentSizeCategory.extraExtraLarge)
                                    Text("Extra Extra Extra Large").tag(ContentSizeCategory.extraExtraExtraLarge)
                                    Text("Accessibility Medium").tag(ContentSizeCategory.accessibilityMedium)
                                    Text("Accessibility Large").tag(ContentSizeCategory.accessibilityLarge)
                                    Text("Accessibility Extra Large").tag(ContentSizeCategory.accessibilityExtraLarge)
                                    Text("Accessibility XX Large").tag(ContentSizeCategory.accessibilityExtraExtraLarge)
                                    Text("Accessibility XXX Large").tag(ContentSizeCategory.accessibilityExtraExtraExtraLarge)
                                }
                                .pickerStyle(WheelPickerStyle())
                                .padding()
                                .frame(width: 350)
                }
            }
        
                
                
            
            .navigationTitle("Settings")
        }
    }
}


