//
//  ListView.swift
//  Infrastruct
//
//  This class serves as the "User Information Panel", it is ListView that displays all the reports from the user, it calls fetchReports(). 
//  Created by devadmin on 11/7/22.
//

import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        NavigationView {
            List(dataManager.reports) { x in
                Text("Reported " + x.reportType + " on " + x.date)
            }
            .navigationTitle("Previous user reports")
            .navigationBarItems(trailing: Button(action: {
                dataManager.fetchReports()
            }, label: {
                Image(systemName: "plus")
            }))
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
