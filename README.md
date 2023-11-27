# TMon
InnoTech: TMon, is an appointment Swift scheduling app that supports sign in, scheduling, and list view of every appointment.

Currently only way for app to work is having a Mac computer with XCode installed, having this availiable the app can be produced to different IOS devices. TMon can also be used as a desktop application on the Mac. 

## Features
- ** Profile Creation/Sign-in with Firebase:** Users can create profiles and sign in securely using Firebase Authentication.

- ** Appointment Creation through Supabase:** Users can create appointments, and the data is stored securely in Supabase.

- ** List View of Appointments:** Users can view a list of their appointments, including date and time.

## Installation 

### Prerequisites 
- Xcode installed
- CocoaPods installed for managing dependencies (you can install it using `sudo gem install cocoapods`)

### Getting Started
1. Copy Repository 
``` bash
https://github.com/InnoTechTmon/TMon.git
```
2. Click "Clone GIT Repository..." in XCode. 
   
3. In "Search or enter repository URL", enter copied Repo.

4. Select where to save TMon Folder and press "Clone".

5. Open file through TMon_4.xcodeproj

6. Make sure to add GoogleService-Info.plist to project.

7. Go to "File" -> "Add files to TMon4" 

8. Make sure to add dependicies for Supabase and Firebase through XCode "File" -> "Add Package Dependencies" 

In search bar copy URL Repo below and paste them in and press "Add Package"

   Supabase:
   ``` bash
   https://github.com/supabase-community/supabase-swift.git
   ```
   
   Firebase:
   ``` bash
   https://github.com/firebase/firebase-ios-sdk
   ```
      
9. Build and Run:
Press Cmd + B to build the project.
Press Cmd + R to run the project.


## Usage

1. ** Profile Creation/Sign-in:**
    - Launch the app and click on "Profile" to create/signin/view profile.
    - Sign in with your credentials.
    - Sign in/sign out/delete account through respective buttons. 

2. ** Appointment Creation:**
    - Navigate to the "Calendar" section.
    - Click on the "DAY "NUM" on calendar to pick a day.
    - Click on Time for which time you would like. 
    - Enter any extra details the done.
    - Click "Done" on confimration page to proceed back to calendar. 

3. ** List View of Appointments:**
    - Go to the "List" section to view a list of your appointments.
    - Appointments are displayed with date and time.
  
### Reporting Issues

When reporting issues, please provide a detailed description and include steps to reproduce the problem.


