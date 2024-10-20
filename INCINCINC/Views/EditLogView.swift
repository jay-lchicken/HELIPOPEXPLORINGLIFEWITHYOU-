//
//  NewLogView.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//

import SwiftUI

import MapKit
struct editInformationField: View {
    @ObservedObject var model: LogManagementViewModel
    @State var editIndex: Int
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
                            NavigationLink(destination: editSelectLocationFled(viewModel: model, editIndex: editIndex)) {
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
struct editSelectLocationFled: View {
    @ObservedObject var viewModel : LogManagementViewModel
    @State var editIndex: Int
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
                            NavigationLink(destination: editSelectWhereTheyAreNow(model: viewModel, editIndex: editIndex)) {
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
struct editSelectWhereTheyAreNow: View {
    @ObservedObject var model : LogManagementViewModel
    @State var editIndex: Int
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
                            NavigationLink(destination: editDateSelect(model: model, editIndex: editIndex)) {
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

                    
                }
                .padding(.top, 20)

            }
            
        }
        .alert(isPresented: $model.showAlert){
            Alert(title: Text("Error"), message: Text("Please select a location"))
        }
    }
}
struct editDateSelect: View {
    @ObservedObject var model: LogManagementViewModel
    @State var editIndex: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("When did it happen?")
                    .font(.headline)
                DatePicker("Date Happened", selection: $model.dateHappened)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: 350)
                
                Button(action: {
                    print("Saved")
                    let success = model.verify()
                    if success {
                        print("Success")
                        model.edit(editIndex: editIndex)
                        model.generator.notificationOccurred(.success)
                        model.isEditing.toggle()
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
                        Text("Save")
                            .foregroundColor(.black)
                            .bold()
                            .font(.system(size: 20))
                    }
                }
                .alert(isPresented: $model.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please select a date"))
                }
            }
            .padding(.top, 20)
        }
    }
}
