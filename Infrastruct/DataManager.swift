//
//  DataManager.swift
//  Infrastruct
//
//  This class serves as our "driver" to our Database, it handles anything involving reading or writing to the Database.
//
//  Created by devadmin on 11/7/22.
//


import SwiftUI
import Firebase
import FirebaseFirestore

class DataManager : ObservableObject {
    @Published var reports: [LocationReport] = []
    
    //Whenever we want to use our DataManager, we should call fetchReports() and update our list of reports. 
    init ()
    {
        fetchReports()
    }
    
    //This function fetches all our reports in our database and returns them an an Object.
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
    
    //This function is how a report is added to the Database, it takes in a bunch of different parameters to construct a Report object.
    func addReport(id: String, latitude: String, longitude: String, reportType: String, date: String, user: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Reports").document(id)
        ref.setData(["id" : id, "latitude" : latitude, "longitude": longitude, "reportType": reportType, "date": date, "user": user]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
