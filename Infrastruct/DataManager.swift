//
//  DataManager.swift
//  Infrastruct
//
//  Created by devadmin on 11/7/22.
//

//THE CLASS THAT WILL HANDLE INSERTING ALL OF OUR DATA

import SwiftUI
import Firebase
import FirebaseFirestore

class DataManager : ObservableObject {
    @Published var dogs: [Dog] = []
    @Published var reports: [LocationReport] = []
    
    
    init ()
    {
        fetchReports()
    }
    
    func fetchReports()
    {
        reports.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Reports")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let latitude = data["latitude"] as? String ?? ""
                    let longitude = data["longitude"] as? String ?? ""
                    let reportType = data["reportType"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let user = data["user"] as? String ?? ""

                    let report = LocationReport(id: id, latitude: latitude, longitude: longitude, reportType: reportType, date: date, user: user)
                    self.reports.append(report)
                    
                }
            }
        }
    }
    
    func addReport(id: String, latitude: String, longitude: String, reportType: String, date: String, user: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Reports").document(id)
        ref.setData(["id" : id, "latitude" : latitude, "longitude": longitude, "reportType": reportType, "date": date, "user": user]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDogs() {
        dogs.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let breed = data["breed"] as? String ?? ""
                    
                    let dog = Dog(id: id, breed: breed)
                    self.dogs.append(dog)
                }
            }
        }
    }
    
    func addDog(dogBreed: String)
    {
        let db = Firestore.firestore()
        let ref = db.collection("Dogs").document(dogBreed)
        ref.setData(["breed" : dogBreed, "id" : 10]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
