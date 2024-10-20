//
//  NewLogView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

import MapKit
struct informationField: View {
    @ObservedObject var model: LogManagementViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ZStack {
                        Capsule()
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 350, height: 50)
                        
                        TextField("Name of Accomplice(s)", text: $model.nameOfAccomplice)
                            .padding(.horizontal)
                            .frame(width: 350, height: 50)
                    }
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 350, height: 200)
                        
                        TextEditor(text: $model.whyWasTheCoinStolen)
                            .padding(6)
                            .frame(width: 350, height: 200)
                        
                        if model.whyWasTheCoinStolen.isEmpty {
                            Text("Why was the coin stolen?")
                                .foregroundColor(.gray)
                                .padding(.leading, 16)
                                .padding(.top, 12)
                        }
                    }
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 350, height: 200)
                        
                        TextEditor(text: $model.howWasTheCoinStolen)
                            .padding(6)
                            .frame(width: 350, height: 200)
                        
                        if model.howWasTheCoinStolen.isEmpty {
                            Text("How was the coin stolen?")
                                .foregroundColor(.gray)
                                .padding(.leading, 16)
                                .padding(.top, 12)
                        }
                    }
                    
                    ZStack {
                        Capsule()
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 350, height: 50)
                        
                        HStack {
                            Spacer()
                            Text("Coins Stolen:")
                                .foregroundColor(.black)
                            TextField("Amount", text: Binding(
                                get: { String(model.coinsCount) },
                                set: { newValue in
                                    if let value = Int(newValue) {
                                        model.coinsCount = value
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .frame(width: 100)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack {
                        if !model.howWasTheCoinStolen.isEmpty && !model.whyWasTheCoinStolen.isEmpty && !model.nameOfAccomplice.isEmpty && model.coinsCount != 0{
                            NavigationLink(destination: selectLocationFled(viewModel: model)) {
                                ZStack {
                                    Capsule()
                                        .stroke(Color.black, lineWidth: 1)
                                        .frame(width: 350, height: 50)
                                    Text("Next")
                                        .foregroundColor(.black)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        } else {
                            Button(action: {
                                model.generator.notificationOccurred(.success)
                                model.showAlert.toggle()
                            }) {
                                ZStack {
                                    Capsule()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 350, height: 50)
                                    Text("Next")
                                        .foregroundColor(.gray)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .alert(isPresented: $model.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please fill in all fields"))
                }
            }
        }
    }
}
struct selectLocationFled: View {
    @ObservedObject var viewModel : LogManagementViewModel
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Where did the heist happen")
                    LocationPickerView(selectedCoordinate: $viewModel.locationFled)
                    if !(viewModel.locationFled==nil) {
                        VStack{
                            Text("Coordinates Selected")
                                .font(.headline)
                            Text("Latitude: \(viewModel.locationFled!.latitude)")
                                .font(.subheadline)
                            Text("Longtitude: \(viewModel.locationFled!.longitude)")
                                .font(.subheadline)
                        }
                    }
                    VStack {
                        if viewModel.locationFled != nil {
                            NavigationLink(destination: selectWhereTheyAreNow(model: viewModel)) {
                                ZStack {
                                    Capsule()
                                        .stroke(Color.black, lineWidth: 1)
                                        .frame(width: 350, height: 50)
                                    Text("Next")
                                        .foregroundColor(.black)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        } else {
                            Button(action: {
                                viewModel.generator.notificationOccurred(.error)
                                viewModel.showAlert.toggle()
                            }) {
                                ZStack {
                                    Capsule()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 350, height: 50)
                                    Text("Next")
                                        .foregroundColor(.gray)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
            .alert(isPresented: $viewModel.showAlert){
                Alert(title: Text("Error"), message: Text("Please select a location"))
            }
        }
    }
}
//struct selectLocationFled: View {
//    @ObservedObject var viewModel: LogManagementViewModel
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//                    Text("Where did the heist happen")
//                        .font(.headline)
//
//                    LocationPickerView(selectedCoordinate: $viewModel.locationFled)
//                        .frame(height: 300)
//
//                    if let location = viewModel.locationFled {
//                        VStack {
//                            Text("Selected Location:")
//                                .font(.subheadline)
//                            Text("Latitude: \(location.latitude)")
//                            Text("Longitude: \(location.longitude)")
//                        }
//                    }
//
//                    VStack {
//                        if viewModel.locationFled != nil {
//                            NavigationLink(destination: selectWhereTheyAreNow(model: viewModel)) {
//                                ZStack {
//                                    Capsule()
//                                        .stroke(Color.black, lineWidth: 1)
//                                        .frame(width: 350, height: 50)
//                                    Text("Next")
//                                        .foregroundColor(.black)
//                                        .bold()
//                                        .font(.system(size: 20))
//                                }
//                            }
//                        } else {
//                            Button(action: {
//                                viewModel.generator.notificationOccurred(.error)
//                                viewModel.showAlert.toggle()
//                            }) {
//                                ZStack {
//                                    Capsule()
//                                        .stroke(Color.gray, lineWidth: 1)
//                                        .frame(width: 350, height: 50)
//                                    Text("Next")
//                                        .foregroundColor(.gray)
//                                        .bold()
//                                        .font(.system(size: 20))
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.top, 20)
//                .alert(isPresented: $viewModel.showAlert) {
//                    Alert(title: Text("Error"), message: Text("Please select a location"))
//                }
//            }
//        }
//    }
//}
struct selectWhereTheyAreNow: View {
    @ObservedObject var model : LogManagementViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View{
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Where did the person flee to")
                    LocationPickerView(selectedCoordinate: $model.locationNow)
                    if !(model.locationNow==nil) {
                        VStack{
                            Text("Coordinates Selected")
                                .font(.headline)
                            Text("Latitude: \(model.locationNow!.latitude)")
                                .font(.subheadline)
                            Text("Longtitude: \(model.locationNow!.longitude)")
                                .font(.subheadline)
                        }
                    }
                    VStack {
                        if model.locationNow != nil {
                            NavigationLink(destination: dateSelect(model: model)) {
                                ZStack {
                                    Capsule()
                                        .stroke(Color.black, lineWidth: 1)
                                        .frame(width: 350, height: 50)
                                    Text("Next")
                                        .foregroundColor(.black)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        } else {
                            Button(action: {
                                model.generator.notificationOccurred(.error)
                                model.showAlert.toggle()
                            }) {
                                ZStack {
                                    Capsule()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 350, height: 50)
                                    Text("Next")
                                        .foregroundColor(.gray)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    }
//                    NavigationLink(destination: dateSelect(model: model)) {
//                        ZStack {
//                            Capsule()
//                                .frame(width: 350, height: 50)
//                                .foregroundStyle(.blue)
//                            Text("Next")
//                                .foregroundStyle(.black)
//                                .bold()
//                                .font(.system(size: 30))
//                        }
//                    }
                    
                }
                .padding(.top, 20)

            }
            
        }
        .alert(isPresented: $model.showAlert){
            Alert(title: Text("Error"), message: Text("Please select a location"))
        }
    }
}
struct dateSelect: View {
    @ObservedObject var model: LogManagementViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("When did it happen?")
                    .font(.headline)
                DatePicker("Date Happened", selection: $model.dateHappened)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: 350)
                
                Button(action: {
                    let success = model.verify()
                    if success {
                        print("Success")
                        model.add()
                        model.showNewItemView.toggle()
                        model.generator.notificationOccurred(.success)
                    } else {
                        print("Failure")
                        model.showAlert.toggle()
                        model.generator.notificationOccurred(.error)
                    }
                }) {
                    ZStack {
                        Capsule()
                            .stroke(Color.black, lineWidth: 1)
                            .frame(width: 350, height: 50)
                        Text("Add")
                            .foregroundColor(.black)
                            .bold()
                            .font(.system(size: 20))
                    }
                }
                .alert(isPresented: $model.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please select a location"))
                }
            }
            .padding(.top, 20)
        }
    }
}
struct LocationPickerView: View {
    @State private var searchText = ""
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) //Default Location is San Francisco
    
    var body: some View {
        VStack {
            Spacer()
            SearchBar(text: $searchText, onSearchButtonClicked: performSearch)
            
            
            SelectionMapView(selectedCoordinate: $selectedCoordinate, region: $region)
                .frame(height: 400)
            
            
            
            Spacer()
        }
        .padding()
    }
    
    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                let item = response.mapItems.first
                if let coordinate = item?.placemark.coordinate {
                    region = MKCoordinateRegion(center: coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)) //Show a 1km Radius
                }
            }
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearchButtonClicked: () -> Void
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar
        
        init(_ parent: SearchBar) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            parent.onSearchButtonClicked()
            searchBar.resignFirstResponder()
        }
    }
}

struct SelectionMapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapTap))
        mapView.addGestureRecognizer(tapGesture)
        

        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: SelectionMapView
        
        init(_ parent: SelectionMapView) {
            self.parent = parent
        }
        
        @objc func handleMapTap(gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            parent.selectedCoordinate = coordinate
        }
    }
}

