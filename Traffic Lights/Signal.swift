//
//  Signal.swift
//  Traffic Lights
//
//  Created by Gagandeep Singh on 27/7/16.
//
//

import UIKit


/*
 
    Model for Traffic Signal, or one set of traffic lights
 
    Each signal includes:
        - A Status Variable that keeps track of Red, Amber or Green status.
        - A Signal View, which is a UIImageView, that holds the image corresponding to the current status
 
        - An 'activate' method, that switches the status to Green and displays the green image in the status view
        - A 'deactivate' method, thats switches the status from Green to Amber for 5 seconds and then to Red after 5 seconds are up.
 
 */


class Signal {
    
    //Signal Status
    /*
        Updates the Image in the StatusView, every time the status changes
     */
    var status: SignalStatus? {
        didSet {
            if let status = status {
                signalView.image = UIImage(named: status.rawValue)
            }
        }
    }
    
    //Signal View
    /*
        Holds the Image for the current status of the signal
     */
    var signalView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //Empty Initializer
    init() {
        
    }
    
    
    //Method to activate a signal, turns the status to Green
    func activate() {
        status = .green
    }
    
    //Method to deactivate a signal
    /*
        Turns the signal to Amber staright away
        And after 5 seconds, turns the signal to Red and calls the completion handler
        The completion handler is used to wait until the singal has turned red, to switch the next signal to green
     */
    func deActivate(_ completionHandler: () -> ()) {
        
        //Set status to Amber
        status = .amber
        
        //Wait for 5 seconds before switching to red
        let delayTime = DispatchTime.now() + 5
        DispatchQueue.main.after(when: delayTime) {
            self.status = .red
            completionHandler()
        }
    }
}
