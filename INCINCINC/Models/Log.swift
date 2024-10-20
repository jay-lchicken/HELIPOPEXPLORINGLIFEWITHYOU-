//
//  Log.swift
//  HELIPOP
//
//  Created by Lai Hong Yu on 9/9/24.
//
import CoreLocation

struct log: Identifiable, Codable {
    let id = UUID()
    let nameOfAccomplice: String
    let locationFled: LocationData
    let dateAdded: TimeInterval
    let whyStolen: String
    let whereAreTheyNow: LocationData
    let howTheyStoleTheCoin: String
    let coinsCount: Int
    let dateHappened: TimeInterval
    struct LocationData: Codable {
        let latitude: Double
        let longitude: Double

        init(from location: CLLocation) {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }

        func toCLLocation() -> CLLocation {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}

