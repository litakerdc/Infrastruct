//
//  ContentView.swift
//  Infrastruct
//
//  This class is our main file, it serves as the basis for most of Views, and is where the core of our GUI is displayed. 
//
//  Created by devadmin on 9/19/22.
//

import CoreLocationUI
import MapKit
import SwiftUI
import FirebaseAuth
import RealmSwift
import Firebase


class AppViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @EnvironmentObject var dataManager: DataManager

    @Published var signedIn = false
    @Published var mapShowing = false
    @Published var currUser: String = "Default User"
    @Published var showingAlert = false
    
    //MKCoordinateRegion initializer
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
    @State private var showingSheet = false
    
    //create locationmanager object
    let locationManager = CLLocationManager()
    
    //On init load set location manager
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //Request permissions from user on init load, needed to obtain the user's current location
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    //Output if error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //Getter for center location
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //Map view type toggle with mapView and mapType variables
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
    

    // Signed in bool init
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    //Sign in function using email and password to authenticate
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
    
    //Sign up function using email and password to create account for authentication
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
    
    //Sign out function to log out of system
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

//Map view struct that holds map data and creates live map view with current location and address
struct MyMapView: View {
    //@StateObject var mapData = ContentViewModel()
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    //geoCoder object used for converting location object to readable string address
    let geoCoder = CLGeocoder()
    
    weak var addressLabel: UILabel!
    
    //Function to add a report to the database, utilized the dataManager class.
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
    
    //On load initialize location string
    init() {
        locationString = "Test"
    }
    
    //Helper function to load string once CLGeocoder completes on new thread
    func addressHelper(loc: String) {
        locationString = loc
    }
    
    //Getter for address from a latitude and longitude
    //Uses placemarks to determine address parts,
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
            } else {
                cAddr = "Test2"
            }
            
            addressHelper(loc: cAddr)
        })
    }
        
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
    //Default map view fields, when the map is first opened, this is the default location to show.
    private enum MapDefaults {
        static let latitude = 36.2168
        static let longitude = 81.6746
        static let zoom = 1.0
    }
    
    //New location helper object
    @ObservedObject var locHelper = LocationHelper()
    
    //Buttons and features on VStack for screen location
    var body: some View {
        VStack {
            
            //Address string above map created from getAddress
            Text(locationString)
            .font(.subheadline)
            .padding()
            Map(coordinateRegion: $viewModel.region,
                            interactionModes: .all,
                            showsUserLocation: true
            )}
        
            //Our LocationButton gets the user's current location and converts it to a latitude and longitude.
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
            

            
            //Menu for reporting issues
            Menu("Report an issue")
            {
                Button("Pothole", action: { passReport(rtype: "Pothole") })
                Button("Street Obstruction", action: { passReport(rtype: "Street Obstruction") })
                Button("Weather Damage", action: { passReport(rtype: "Weather Damage") })
                Button("Other", action: { passReport(rtype: "Other") })
                
            }
        }
    }
//This is our View of the "landing page", it is the page where our Map Sheet is called from.
struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    //These vars determine which sheet is showing, they act as triggers for the sheets.
    @State private var showingSheet = false
    @State private var showingUserSheet = false;

    //Sign in view and navigation
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
                        .foregroundColor(Color.red)
                })
                }
                
            }
            //If we are signed in, and the map is supposed to be showing, show the map, otherwise have the user sign in.
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

//Struct for the sign in page, this is the very first page a user will see and it is how they log in. 
struct SignInView: View {
    
    //These are the fields to be used when the user signs in, an email and a a password.
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    //This view is where out input fields are.
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

//The view for the SignUp page, this is the page that is displayed when users want to sign up.
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

//Unused test location manager replaced with LocationHelper class file
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
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
