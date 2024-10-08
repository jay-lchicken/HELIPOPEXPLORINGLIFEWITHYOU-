//
//  SettingsView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/10/24.
//

import SwiftUI
import UniformTypeIdentifiers
struct SettingsView: View {
    @ObservedObject var viewModel: LogManagementViewModel
    @State private var selectedFileURL: URL? = nil
    @AppStorage("darkMode") var darkMode: Bool = false
    @State private var isImporting = false
    @State private var isExporting = false
    @State private var exportUrl: URL?
    @State var showSecondAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Toggle(isOn: $darkMode) {
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
                    
                    Button(action: {
                        isExporting = true
                    }) {
                        Label("Export Logs", systemImage: "square.and.arrow.up")
                    }
                    .padding()
                    .frame(width: 350)
                    .fileExporter(
                        isPresented: $isExporting,
                        document: ExportDocument(data: exportData()),
                        contentType: .json,
                        defaultFilename: "logs"
                    ) { result in
                        switch result {
                        case .success(let url):
                            print("Exported to: \(url)")
                        case .failure(let error):
                            print("Failed to export: \(error.localizedDescription)")
                        }
                    }
                    
                    Button(action: {
                        isImporting = true
                    }) {
                        Label("Import Logs", systemImage: "square.and.arrow.down")
                    }
                    .fileImporter(
                        isPresented: $isImporting,
                        allowedContentTypes: [.json],
                        allowsMultipleSelection: false
                    ) { result in
                        do {
                            guard let selectedFile: URL = try result.get().first else { return }
                            if selectedFile.startAccessingSecurityScopedResource(){
                                importLogs(from: selectedFile)
                            }
                            selectedFile.stopAccessingSecurityScopedResource()
                        } catch {
                            print("Failed to import: \(error.localizedDescription)")
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
    
    func exportData() -> Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(viewModel.logs)
        } catch {
            print("Error encoding logs: \(error)")
            return Data()
        }
    }
    
    func importLogs(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedLogs = try decoder.decode([log].self, from: data)
            viewModel.logs = importedLogs
            viewModel.sync()

        } catch {
            print("Error decoding logs: \(error)")
        }
    }
}
struct ExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        self.data = Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data)
    }
}
