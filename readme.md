# Traffic Lights

A single view app that simulates a set of traffic signals at an intersection.

**This app has been in written in Swift 3.0. It requires XCode 8 Beta 3 on the machine and ios 10 on the device to run. **

#### Explicit requirements:  
1. The traffic lights should be arranged North-South & East-West.
2. The lights should change every 30 seconds.
3. The light turning from Green to Red must stay Amber for 5 seconds before going Red.



### 1.  Architecture

This app has deigned using Model-View-ViewModel (MVVM) pattern to provide a separation of concerns between them. It is also useful for maintainability and it also avoids the Massive-View controllers problem.

Typically the project structure has the followings:  
* ***Service*** – The core of the app that talks to the backend side via network calls
* ***Model*** – The data model to represent an entity. eg. FlickrPhoto
* ***View*** – The UI Elements which are contained within a View Controler and interact with UI. eg. Table View Cells
* ***View-Model*** – The model representing the data necessary for the view to display itself; but it’s also responsible for gathering, interpreting, and transforming that data by communicating with services layer  
* ***View-Controller*** – The controllers that directly interact with the UI and manage the UI state. The code for Views and View-Controllers have similar goals and they are commonly categorised into one category

There are no View-Models or Views in this app as this app has only a sinlge View Controller & does not have any network functions


### 2. Approach
My approch to this problem was to keep it Object Oriented. And the main object, needed by this app, is the Signal Model.
Each Signal Model has a Status variable, that keeps track of the current status of its lights. Red, Amber or Green.
Each Signal Model has an Image View, which holds the Image for its current status.

Each Signal Model has two methods:
    One to activate a Signal i.e Go from Red Signal to Green.
    Another to deactivate a Signal i.e. Go from Green to Red. The deactivate method, goes from Green to Red instantly and then waits for 5 seconds before going to Red.


### 3. User Interface Design
The app is supported in potrait mode only for all device families - iPhone SE, 5, 5s, 6, 6s, 6Plus, 6Plus s, iPad, iPad mini, iPad Pro. The user interface is adaptive accross all these devices.


##### Intersection View Controller:  
This is the main and only View Controller in the app.

It includes 4 Signal Views, which are UIImageViews, that hold the signal image for each direction.
It includes a Start/Stop button which can be used to Start or Stop the animation of changing lights.
It includes a Time Ticker label, that shows the countdown label, that counts down to the time when the lights will be changed next.
It also includes a status label that reads the current satus of Animation. Running or Stoppped.



***
### 4. Level of effort and time estimates
This app was built on part-time basis over two days. Following is the approximate break down of time spent in man-hours for various aspects of the design and developement process.

| Aspect                          |Approximate Time|
| ------------------------------------ |:---------:|
| Base project                         | 0.5 hours |
| App arechitecture planning           | 0.5 hours |
| Coding for the view models           | 0.5 hours |
| Coding for the view controllers      | 1.0 hour  |
| User interface design                | 1.0 hour  |
| Code commenting and documentation    | 2.0 hours |
| ReadMe.md documentation on Github    | 1.0 hour  |
| **Total**                            | **6.5 hours**  |



***
### Issues & Limitations
* The main issue or limitation that you might notice, is that if you Stop the animation when a signal has turned Amber, it will continue to go Red after its 5 seconds are up, despite the timer being stopped when the Stop button was pressed.
* This happens because going from Green to Amber to Red, all takes place in a single method and once the method has been called, the Stop button will not stop the method from completing its execution.
* But the animation will go no further after that signal has turned Red and the next signal has turned Green.












