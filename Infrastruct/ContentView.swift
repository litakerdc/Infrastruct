//
//  ContentView.swift
//  Infrastruct
//
//  Created by devadmin on 9/19/22.
//

import CoreLocationUI
import MapKit
import SwiftUI
import FirebaseAuth
import RealmSwift
import Firebase



//ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate

class AppViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @EnvironmentObject var dataManager: DataManager

    @Published var signedIn = false
    @Published var mapShowing = false
    @Published var currUser: String = "Default User"
    @Published var showingAlert = false
    
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
    @State private var showingSheet = false
    
    //@StateObject var mapData = ContentViewModel()
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    @Published var mapView = MKMapView()
    @Published var mapType : MKMapType = .standard
    
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    let auth = Auth.auth()
    

    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password)
            { [weak self] result, error in guard result != nil, error == nil else {
                self?.showingAlert = true;
                return
            }
        
            // Success
                DispatchQueue.main.async {
                    self?.currUser = email
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
                    self?.currUser = email
                }
            }
        }
    
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false;
    }
    
    func toggleMap()
    {
        self.mapShowing = !self.mapShowing;
    }
    
    func sendPing()
    {
        print("Hello");
    }
}

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    var color: Color?
    var tint: Color { color ?? .red }
    let id = UUID()
}

struct MyMapView: View {
    //@StateObject var mapData = ContentViewModel()
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    let geoCoder = CLGeocoder()
    
    weak var addressLabel: UILabel!
    
    func passReport(rtype: String)
    {
        // get the current date and time
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long

        // get the date time String from the date object
        let date1 = formatter.string(from: currentDateTime)
        let lat1:String = "\(LocationHelper.currentLocation.latitude)"
        let long1:String = "\(LocationHelper.currentLocation.longitude)"
        let uuid = UUID().uuidString
        let user = viewModel.currUser
        dataManager.addReport(id: uuid, latitude: lat1, longitude: long1, reportType: rtype, date: date1, user: user)
        
    }
    
    @State var locationString = ""
    
    init() {
        locationString = "Test"
    }
    
    func addressHelper(loc: String) {
        locationString = loc
    }
    
    func getAddress(lat: Double, long: Double) -> Void {
        let loc = CLLocation(latitude: lat, longitude: long)
        var cAddr = "a"
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
            if error != nil {
                cAddr = "Test1"
            }
            let pm = placemarks! as [CLPlacemark]
            if (pm.count > 0) {
                let pm = placemarks![0]
                
                cAddr = ""
                if (pm.subThoroughfare != nil) {
                    let subt = pm.subThoroughfare
                    cAddr += subt!
                    cAddr += " "
                }
                if (pm.thoroughfare != nil) {
                    let t = pm.thoroughfare
                    cAddr += t!
                    cAddr += ", "
                }
                if (pm.locality != nil) {
                    let locality = pm.locality
                    cAddr += locality!
                    cAddr += " "
                }
                if (pm.administrativeArea != nil) {
                    let adminArea = pm.administrativeArea
                    cAddr += adminArea!
                    cAddr += ", "
                }
                if (pm.postalCode != nil) {
                    let zip = pm.postalCode
                    cAddr += zip!
                    cAddr += ", "
                }
                if (pm.country != nil) {
                    let country = pm.country
                    cAddr += country!
                }
                //cAddr = subt! + " " + t! + ", " + locality! + " " + adminArea! + ", " + zip! + ", " + country!
            } else {
                cAddr = "Test2"
            }
            
            addressHelper(loc: cAddr)
        })
    }
        
        //@EnvironmentObject var viewModel: AppViewModel
    @StateObject var viewModel = AppViewModel()
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: LocationHelper.currentLocation.latitude, longitude: LocationHelper.currentLocation.longitude),
        span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoom, longitudeDelta: MapDefaults.zoom))
    
    let annotationItems = [MyAnnotationItem(
                            coordinate: CLLocationCoordinate2D(
                                latitude: MapDefaults.latitude,
                                longitude: MapDefaults.longitude)),
                           MyAnnotationItem(
                            coordinate: CLLocationCoordinate2D(
                                latitude: 45.8827419,
                                longitude: -1.1932383),
                            color: .yellow),
                           MyAnnotationItem(
                            coordinate: CLLocationCoordinate2D(
                                latitude: 45.915737,
                                longitude: -1.3300991),
                            color: .blue)]
    private enum MapDefaults {
        static let latitude = 36.2168
        static let longitude = 81.6746
        static let zoom = 1.0
    }
    
    @ObservedObject var locHelper = LocationHelper()
    
    var body: some View {
        VStack {
            
            Text(locationString)
            .font(.subheadline)
            .padding()
            Map(coordinateRegion: $viewModel.region,
                            interactionModes: .all,
                            showsUserLocation: true
            )}
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
                let lat = LocationHelper.currentLocation.latitude
                let long = LocationHelper.currentLocation.longitude
                getAddress(lat: lat, long: long)
                getAddress(lat: lat, long: long)
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.iconOnly)
            

            
	    /*Button(action: viewModel.updateMapType, label: {
	        Image(systemName: viewModel.mapType ==
		    .standard ? "network" : "map")
		    .font(.title2)
		    .padding(10)
		    .background(Color.primary)
		    .clipShape(Circle())
	    })

	    .frame(maxWidth: .infinity, alignment: .trailing)
	    .padding()*/
            
            Menu("Report an issue")
            {
                Button("Pothole", action: { passReport(rtype: "Pothole") })
                Button("Street Obstruction", action: { passReport(rtype: "Street Obstruction") })
                Button("Weather Damage", action: { passReport(rtype: "Weather Damage") })
                Button("Other", action: { passReport(rtype: "Other") })
                
            }
            /**
            LocationButton(.sendCurrentLocation) {
                return
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleOnly)
             **/
        }
    }

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingSheet = false
    @State private var showingUserSheet = false;

    var body: some View {
        NavigationView {
            if viewModel.signedIn && !viewModel.mapShowing {
                VStack {
                    Text("Hello " + viewModel.currUser + ", you are signed in")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    
                    
                    
                .padding()
                .padding()
                
                    Button("Open Map") {
                                showingSheet.toggle()
                            }
                            .sheet(isPresented: $showingSheet) {
                                MyMapView()
                            }
                            .padding()
                    
                    Button("User information") {
                        showingUserSheet.toggle()
                    }
                    .sheet(isPresented: $showingUserSheet) {
                        UserInfoView()
                    }
                    .padding()
                    
                Button(action: {
                    viewModel.signOut()
                }, label: {
                    Text("Sign Out")
                        .frame(width: 200, height: 50)
                        //.background(Color.green)
                        .foregroundColor(Color.red)
                })
                }
                
            }
            else if viewModel.signedIn && viewModel.mapShowing
            {
                MyMapView()
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
                    .alert("Incorrect login", isPresented: $viewModel.showingAlert)
                    {
                        Button("Ok", role: .cancel) {}
                    }
                    
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

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
    //@StateObject var mapData = ContentViewModel()
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    @Published var mapView = MKMapView()
    @Published var mapType : MKMapType = .standard
    
    func updateMapType() {
    if (mapType == .standard) {
        mapType = .hybrid
        mapView.mapType = mapType
    } else {
        mapType = .standard
        mapView.mapType = mapType
    }
}


}
