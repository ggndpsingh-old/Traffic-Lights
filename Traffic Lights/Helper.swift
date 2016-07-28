//
//  Helper.swift
//  Traffic Lights
//
//  Created by Gagandeep Singh on 28/7/16.
//
//

import UIKit

//Enums results in a much cleaner & safer code than strings


//An enum to keep track of Signal Direction.
enum Direction {
    case east
    case west
    case north
    case south
}

//Enum for Signal Status along with the name of the corresponding Image for that status
enum SignalStatus: String {
    case red    = "red"
    case amber  = "amber"
    case green  = "green"
}
