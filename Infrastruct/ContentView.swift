//
//  ContentView.swift
//  Infrastruct
//
//  Created by devadmin on 9/19/22.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password)
            { [weak self] result, error in guard result != nil, error == nil else {
                return
            }
        
            // Success
                DispatchQueue.main.async {
                    self?.signedIn = true
                }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password)
            { [weak self]result, error in guard result != nil, error == nil else {
                return
            }
            
            // Success
            
                DispatchQueue.main.async {
                    self?.signedIn = true
                }
            }
        }
    
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false;
    }
    }




struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                
                Button(action: {
                    viewModel.signOut()
                }, label: {
                    Text("Sign Out")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(Color.blue)
                })
                Text("You are signed in")
                
            }
            else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
        
    }
}

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack {
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        
                        viewModel.signIn(email: email, password: password)
                        
                    }, label: {
                        Text("Sign In")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .cornerRadius(8)
                            .background(Color.init(UIColor(red: 31/255, green: 55/255, blue: 99/255, alpha: 1.00)))
                    })
                    
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Sign In")
    }
}

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack {
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        
                        viewModel.signUp(email: email, password: password)
                        
                    }, label: {
                        Text("Sign Up")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .cornerRadius(8)
                            .background(Color.init(UIColor(red: 31/255, green: 55/255, blue: 99/255, alpha: 1.00)))
                    })
                }
                .padding()
            }
            .navigationTitle("Sign Up")
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

