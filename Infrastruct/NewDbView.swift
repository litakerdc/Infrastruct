//
//  NewDbView.swift
//  Infrastruct
//
//  Created by devadmin on 11/8/22.
//

import SwiftUI

struct NewDbView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newDog = ""
    
    
    var body: some View {
        VStack {
            TextField("Dog", text: $newDog)
            
            Button {
                dataManager.addDog(dogBreed: newDog)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
}

struct NewDbView_Previews: PreviewProvider {
    static var previews: some View {
        NewDbView()
    }
}
