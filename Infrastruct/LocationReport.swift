//
//  LocationReport.swift
//  Infrastruct
//
//  This class serves as the design of a LocationReport object. When our database is queried, it will turn each entry into a LocationReport object.
//  Created by devadmin on 11/8/22.
//

import SwiftUI


struct LocationReport: Identifiable {
    var id: String //ID for each report
    var latitude: String //Latitude of each repoort
    var longitude: String //Longitude of each report
    var reportType: String //The type of report (Pothole, etc)
    var date: String       //The String value of the date 
    var user: String //The email of the user who reported it
}
