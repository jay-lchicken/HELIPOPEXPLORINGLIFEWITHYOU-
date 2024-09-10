//
//  LogManagementViewModel.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//
import CoreLocation
import Foundation
import SwiftUICore
class LogManagementViewModel: ObservableObject {
    @Published var fontSize: ContentSizeCategory = .large
    @Published var logs: [log] = []
    private let key = "announcementList"
    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decodedList = try? decoder.decode([log].self, from: data) {
                self.logs = decodedList
            }
        }
    }
    func addData(logging: log){
        logs.append(logging)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(logs) {
                    UserDefaults.standard.set(encoded, forKey: key)
            }
    }
    func deleteData(index: Int){
        logs.remove(at: index)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(logs) {
                    UserDefaults.standard.set(encoded, forKey: key)
            }
    }
    func add(name: String, why: String, how: String, locationFledd: CLLocationCoordinate2D, locationNoww: CLLocationCoordinate2D){
        let currentData = log(nameOfAccomplice: name, locationFled: log.LocationData(from: CLLocation(latitude: locationFledd.latitude, longitude: locationFledd.longitude)), dateAdded: Date().timeIntervalSince1970, whyStolen: why, whereAreTheyNow: log.LocationData(from: CLLocation(latitude: locationNoww.latitude, longitude: locationNoww.longitude)), howTheyStoleTheCoin: how)
        addData(logging: currentData)
    }

}
