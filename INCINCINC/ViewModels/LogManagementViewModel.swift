//
//  LogManagementViewModel.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//
import CoreLocation
import Foundation
import SwiftUICore
import DataSave
class LogManagementViewModel: ObservableObject {
    @Published var fontSize: ContentSizeCategory = .large
    @Published var logs: [log] = []
    private let key = "announcementList"
    init() {
//        if let data = UserDefaults.standard.data(forKey: key) {
//            let decoder = JSONDecoder()
//            if let decodedList = try? decoder.decode([log].self, from: data) {
//                self.logs = decodedList
//            }
//        }
        if let logss: [log] = DataSave.retrieveFromUserDefaults(forKey: key, as: [log].self) {
            logs = logss
        } else {
            print("No data found for the given key.")
        }
    }
    func addData(logging: log){
        logs.append(logging)
        let success = DataSave.saveToUserDefaults(logs, forKey: key)
        print("added data: \(success)")
        
    }
    func deleteData(index: Int){
        logs.remove(at: index)
        let success = DataSave.saveToUserDefaults(logs, forKey: key)
        print("deleted data \(success)")
    }
    func add(name: String, why: String, how: String, locationFledd: CLLocationCoordinate2D, locationNoww: CLLocationCoordinate2D){
        let currentData = log(nameOfAccomplice: name, locationFled: log.LocationData(from: CLLocation(latitude: locationFledd.latitude, longitude: locationFledd.longitude)), dateAdded: Date().timeIntervalSince1970, whyStolen: why, whereAreTheyNow: log.LocationData(from: CLLocation(latitude: locationNoww.latitude, longitude: locationNoww.longitude)), howTheyStoleTheCoin: how)
        addData(logging: currentData)
    }

}
