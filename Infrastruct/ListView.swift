//
//  ListView.swift
//  Infrastruct
//
//  Created by devadmin on 11/7/22.
//

import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
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
            .sheet(isPresented: $showPopup) {
                NewDbView()
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
