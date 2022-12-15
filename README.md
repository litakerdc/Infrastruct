
# Infrastruct

Infrastruct is a lightweight iOS application that is designed to help users report
local Infrastructure problems and local property damage. Infrastruct is currently pending approval on the App Store.




## Authors

- [Alexander Harttree](https://www.github.com/JGDIFF)
- [Dylan Litaker](https://www.github.com/litakerdc)


## Features

- User sign in with fully functional Authentication.
- Responsive Application with a clean UI design and insightful alerts.
- Working Mapview which shows an interactive map.
- Map is able to obtain and show the users current location.
- Map is able to convert a user's current location to a readable Address.
- Fully functional Firebase Firestore database.
- Map view is able to write to the database with information obtained from the user.
- User information page that reads from the Database.
- Admin Panel that is able to query the Database and display reports from all users. 

The Admin Panel is seperate from our app and can be found in its own repository [here](https://github.com/JGDIFF/InfrastructAdminPanel)



## Installation

Infrastruct is unavaliable on Microsoft Windows/Android devices.

Once Infrastruct is approved on the App Store, you may install it on any iOS device by searching for
"Infrastruct" on the App Store and installing it like any other Application. 

If you're on macOS and looking to clone this project to XCode, then here is a step by step guide on how to do such.


Step 1: Copy this repositories clone link:

![Image](https://imgur.com/opRUEac.png)

Step 2: Clone the repo into a new Xcode project:

![Image](https://imgur.com/dqUVbuh.png)

![Image](https://imgur.com/x80hFtn.png)

Step 3: Navigate into whatever directory you've created the project in via Terminal, and run:

```pod install```

![Image](https://i.imgur.com/qV9Ia6G.png)


NOTE: If you get any Ruby errors while trying to run the above command, consult the following resources on how to fix it: 

https://handstandsam.com/2021/06/11/how-to-install-a-specific-ruby-version-for-cocoapods/

https://developer.apple.com/forums/thread/697220

https://guides.cocoapods.org/using/getting-started.html

Assuming the above step worked, you should see something like this:

![Image](https://imgur.com/61Lx7ut.png)

Step 4: Open the project in Xcode, and click on the Play/Run button in the top left:

NOTE: Building Infrastruct on a device for the first time will take a few minutes.

![Image](https://imgur.com/PeEvBwd.png)


Once it is done building, a simulator will open containing Infrastruct.

![Image](https://i.imgur.com/6Q4PkJW.png)

Congrautlations! You've installed the Infrastruct XCode project onto your macOS!


    
## Documentation/User Manual

Infrastruct is lightweight and easy to use, here we will show a few example use cases of how to use Infrastruct.

When you first open Infrastruct, you will be greeted with the Sign In page,
if you already have an account, go ahead and log in, otherwise click on "Create Account" at the bottom.

![Image](https://i.imgur.com/v2oW5cM.png)

Once you're on the Create Account page, enter an email address and password that you can remember.
There are currently no password restrictions, it can be as short or as long as you'd like. Then click Sign In.

![Image](https://i.imgur.com/Z5Jkoap.png)

You are automatically signed in upon creating a valid account. 

Once you are signed in, you arrive at the Home page, from here you have two options.
You may either open the Map page or the User Information page. 

![Image](https://i.imgur.com/ROywI01.png)

When you open the map page, the map will load the default view. Click the Location Button at the bottom of the screen
in order to get your current location, a popup may appear asking for your permission.

![Image](https://i.imgur.com/zfO4IP7.png)

Now your current location will be displayed on the map, with a blue dot in the center that represents you. You can hit the location button again for a second time and
notice that your currennt address will be displayed at the top of the Map as a String. 

Once you are at your current Location, you can press on the Report Menu if you'd like to report a problem. There are several options for you to choose from, 
for now Infrastruct only supports Potholes, Weather Damage, Street Obstructions and "Other" reports. Click on the type of report you'd like to make for it to be sent to the database

![Image](https://i.imgur.com/gSuebYl.png)

If you'd like to navigate back to the home page, you can slide the Map Sheet as if it were a popup. You can then navigate to the User Information Sheet to view previous user reports.

![Image](https://i.imgur.com/PJ3uzY1.png)

