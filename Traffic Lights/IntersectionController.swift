//
//  IntersectionController.swift
//  Traffic Lights
//
//  Created by Gagandeep Singh on 27/7/16.
//
//

import UIKit

class IntersectionController: UIViewController {
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Signals
    //----------------------------------------------------------------------------------------------------
    
    //Signals
    let northSignal = Signal()
    let southSignal = Signal()
    let eastSignal  = Signal()
    let westSignal  = Signal()
    
    //Signal Views OR Traffic Lights for each signal
    var northSignalView : UIImageView!
    var southSignalView : UIImageView!
    var eastSignalView  : UIImageView!
    var westSignalView  : UIImageView!
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Constants
    //----------------------------------------------------------------------------------------------------
    
    struct Constants {
        static let signalDuration: Int = 30
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Variables
    //----------------------------------------------------------------------------------------------------
    
    //keep track of which signal is currently active
    var activeSignal: Direction = .north
    
    //enum for animation status
    enum AnimationStatus {
        case running
        case stopped
    }
    
    //update start stop button title and status label text when the animation status changes
    var animationStatus: AnimationStatus! {
        didSet {
            switch animationStatus! {
            case .running:
                startStopButton.setTitle("Stop", for: [])
                statusLabel.text = "Running"
            
            case .stopped:
                startStopButton.setTitle("Start", for: [])
                statusLabel.text = "Stopped"
            }
        }
    }
    
    //the countdown time that ticks until the next lights change
    var time: Int! {
        didSet {
            let secondsText = time! == 1 ? "second" : "seconds"
            ticker.text = "\(time!) \(secondsText)"
        }
    }
    
    //Timer to perform a method on a loop, every x seconds
    var timer: Timer!
    
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: UI Elements
    //----------------------------------------------------------------------------------------------------
    
    //Status Label. Reads the current status of animation
    let statusLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    
    //Title label, reads the time until next change in lights, along with the ticker label
    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "Lights will change in"
        return label
    }()
    
    
    //Ticker Label, reads the countdown
    var ticker: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray()
        label.textAlignment = .center
        return label
    }()
    
    
    //Container, contains the 4 traaffic lights and keep them in the a square container in the middle of the screen
    let container: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //The start stop button for the animation
    lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: [])
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(startStop), for: .touchUpInside)
        button.setTitleColor(.white(), for: [])
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.backgroundColor = .red()
        return button
    }()
    
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: View Controller Life Cycle
    //----------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white()
        
        setupViews()
        setupInitialStatus()
        startAnimation()
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Views
    //----------------------------------------------------------------------------------------------------
    func setupViews() {
        
        //container
        view.addSubview(container)
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        
        //timem ticker
        view.addSubview(ticker)
        ticker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        ticker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        ticker.heightAnchor.constraint(equalToConstant: 20).isActive = true
        ticker.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -10).isActive = true
        
        //title label
        view.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: ticker.topAnchor, constant: 0).isActive = true
        
        //statuslabel
        view.addSubview(statusLabel)
        statusLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        statusLabel.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //north signnal view
        northSignalView = northSignal.signalView
        container.addSubview(northSignalView)
        northSignalView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        northSignalView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        northSignalView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        northSignalView.heightAnchor.constraint(equalTo: northSignalView.widthAnchor, multiplier: 2).isActive = true
        
        //south signal view
        southSignalView = southSignal.signalView
        container.addSubview(southSignalView)
        southSignalView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        southSignalView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10).isActive = true
        southSignalView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        southSignalView.heightAnchor.constraint(equalTo: northSignalView.widthAnchor, multiplier: 2).isActive = true
        
        //east singnal view
        eastSignalView = eastSignal.signalView
        container.addSubview(eastSignalView)
        eastSignalView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        eastSignalView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10).isActive = true
        eastSignalView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        eastSignalView.heightAnchor.constraint(equalTo: northSignalView.widthAnchor, multiplier: 2).isActive = true
        
        //west signal view
        westSignalView = westSignal.signalView
        container.addSubview(westSignalView)
        westSignalView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        westSignalView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 10).isActive = true
        westSignalView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        westSignalView.heightAnchor.constraint(equalTo: northSignalView.widthAnchor, multiplier: 2).isActive = true
        
        //start/stop button
        view.addSubview(startStopButton)
        startStopButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        startStopButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startStopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Setup Initial status
    //----------------------------------------------------------------------------------------------------
    
    /*
        The app starts with a timer of 30 seconds until the next signal activates
        The North signal is green to begin with, and the rest are red.
     */
    func setupInitialStatus() {
        
        time = Constants.signalDuration
        
        northSignal.status = .green
        eastSignal.status  = .red
        southSignal.status = .red
        westSignal.status  = .red
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Start/Stop Animation Timer
    //----------------------------------------------------------------------------------------------------
    
    //Timer for run the time ticker method once every second
    func startAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickTime), userInfo: nil, repeats: true)
        animationStatus = .running
    }
    
    //Method for Start/Stop Button
    func startStop() {
        switch animationStatus! {
        case .running:
            animationStatus = .stopped
            timer.invalidate()
            
        case .stopped:
            startAnimation()
        }
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Update ticker label
    //----------------------------------------------------------------------------------------------------
    
    /*
        This method is run once every second. When the timer hits zero, we reset the timer and switch the traffic lights
     */
    func tickTime() {
        
        //Countdown time
        time = time - 1
        
        /*
            When there are 5 sconds left, start deactivation of active signal,
            It turns Amber with 5 seconds left on the timer and turns red when the timer hits zero
        */
        if time == 5 {
            switchSignal()
        }
        
        //When the timer hits zero, reset timer
        if time == 0 {
            time = Constants.signalDuration
        }
    }
    
    //----------------------------------------------------------------------------------------------------
    //MARK:
    //MARK: Method to switch Traffic Lights
    //----------------------------------------------------------------------------------------------------
    
    /*
        This  method runs once every 30 seconds and switches traffic lights
        It deactivates current signal, which stays Amber for 5 seconds and then goes Red
        When the current active signal goes red, the next signal activates and goes Green
     */
    
    func switchSignal() {
        
        //The signals are activated clockwise.
        
        switch activeSignal {
        case .north:
            self.activeSignal = .east
            northSignal.deActivate {
                self.eastSignal.activate()
            }
            
        case .east:
            self.activeSignal = .south
            eastSignal.deActivate {
                self.southSignal.activate()
            }
            
        case .south:
            self.activeSignal = .west
            southSignal.deActivate {
                self.westSignal.activate()
            }
            
        case .west:
            self.activeSignal = .north
            westSignal.deActivate {
                self.northSignal.activate()
            }
        }
    }
}
