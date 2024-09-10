//
//  NewLogView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

import MapKit
struct NewLogView: View {
    @ObservedObject var viewModel : LogManagementViewModel
    @State var showAlert: Bool = false
    @State var showSheet: Bool = false
    @State var showSheet2: Bool = false
    @State var nameOfAccomplice: String = ""
    @State var whyWasTheCoinStolen: String = ""
    @State var howWasTheCoinStolen: String = ""
    @State var locationFled: CLLocationCoordinate2D? = nil
    @State var locationNow: CLLocationCoordinate2D? = nil
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Divider()
                    TextField("Name of Accomplice", text: $nameOfAccomplice)
                        .frame(width: 350, height: 20)
                    Divider()
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 350, height: 200)


                        TextEditor(text: $whyWasTheCoinStolen)
                            .padding(8)
                            .frame(width: 350, height: 200)


                        if whyWasTheCoinStolen.isEmpty {
                            Text("Why was the coin stolen?")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                                .padding(.top, 15)
                        }
                    }
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 350, height: 200)


                        TextEditor(text: $howWasTheCoinStolen)
                            .padding(8)
                            .frame(width: 350, height: 200)


                        if howWasTheCoinStolen.isEmpty {
                            Text("How was the coin stolen?")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                                .padding(.top, 15)
                        }
                    }
                    Button{
                        showSheet = true
                    }label: {
                        Text("Select Location Fled")
                    }
                    if !(locationFled==nil) {
                        VStack{
                            Text("Location Fled Coordinates")
                            Text("\(locationFled!.latitude)")
                            Text("\(locationFled!.longitude)")
                        }
                    }
                    Button{
                        showSheet2 = true
                    }label: {
                        Text("Select Where are they now")
                    }
                    if !(locationNow==nil) {
                        VStack{
                            Text("Location Now Coordinates")
                            Text("\(locationFled!.latitude)")
                            Text("\(locationFled!.longitude)")
                        }
                    }
                    Button{
                        guard !nameOfAccomplice.isEmpty else {
                            showAlert = true
                            return
                        }
                        guard !whyWasTheCoinStolen.isEmpty else {
                            showAlert = true
                            return
                        }
                        guard !howWasTheCoinStolen.isEmpty else {
                            showAlert = true
                            return
                        }
                        guard locationFled != nil else {
                            showAlert = true
                            return
                        }
                        guard locationNow != nil else {
                            showAlert = true
                            return
                        }
                        do{
                            try viewModel.add(name: nameOfAccomplice, why: whyWasTheCoinStolen, how: howWasTheCoinStolen, locationFledd: locationFled!, locationNoww: locationNow!)
                        }catch{
                            showAlert = true
                        }
                        dismiss()
                        nameOfAccomplice = ""
                        whyWasTheCoinStolen = ""
                        howWasTheCoinStolen = ""
                        locationNow = nil
                        locationFled = nil
                    }label: {
                        ZStack{
                            Capsule()
                                .frame(width: 350, height: 50)
                                .foregroundStyle(.blue)
                            VStack{                                Text("Add")
                                    .foregroundStyle(.black)
                                    .bold()
                                    .font(.system(size: 30))
                                
                            }
                        }

                    }
                }
            }
            .navigationBarTitle("New Log")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Please fill in all fields. If the error persists, please contact support!"))
        }
        .sheet(isPresented: $showSheet){
            LocationPickerView(selectedCoordinate: $locationFled)
        }
        .sheet(isPresented: $showSheet2){
            LocationPickerView2(selectedCoordinate: $locationNow)
        }
        
    }
}

struct LocationPickerView2: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)) //Location Set TO San Francisco
    
    var body: some View {
        VStack {
            Text("Please select a location")
            SearchBar(text: $searchText, onSearchButtonClicked: performSearch)
            
            
            SelectionMapView(selectedCoordinate: $selectedCoordinate, region: $region)
                .frame(height: 400)
            
            
            if let coordinate = selectedCoordinate {
                
                Button{
                    dismiss()
                }label: {
                    ZStack{
                        Capsule()
                            .frame(width: 350, height: 100)
                            .foregroundStyle(.green)
                        VStack{
                            Text("Selected Latitude: \(coordinate.latitude) ")
                                
                            Text("Selected Longtitude: \(coordinate.longitude)")
                                
                                
                            Text("Press to dismiss")
                        }
                    }
                    
                }
            }
            
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
                                                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)) //Shows Location with a 1km Radius
                }
            }
        }
    }
}
struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)) //Default Location is San Francisco
    
    var body: some View {
        VStack {
            Text("Please select a location")
            SearchBar(text: $searchText, onSearchButtonClicked: performSearch)
            
            
            SelectionMapView(selectedCoordinate: $selectedCoordinate, region: $region)
                .frame(height: 400)
            
            
            if let coordinate = selectedCoordinate {
                
                Button{
                    dismiss()
                }label: {
                    ZStack{
                        Capsule()
                            .frame(width: 350, height: 100)
                            .foregroundStyle(.green)
                        VStack{
                            Text("Selected Latitude: \(coordinate.latitude) ")
                                
                            Text("Selected Longtitude: \(coordinate.longitude)")
                                
                                
                            Text("Press to dismiss")
                        }
                    }
                    
                }
            }
            
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

