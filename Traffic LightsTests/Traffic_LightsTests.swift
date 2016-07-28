//
//  Traffic_LightsTests.swift
//  Traffic LightsTests
//

import XCTest
@testable import Traffic_Lights

class Traffic_LightsTests: XCTestCase {
    
    var ic: IntersectionController!
    
    override func setUp() {
        super.setUp()
        
        ic = IntersectionController()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEastToSouthSwitch() {
        ic.activeSignal = .east
        ic.switchSignal()
        
        XCTAssert(ic.activeSignal == .south)
    }
    
    func testSouthToWestSwitch() {
        ic.activeSignal = .south
        ic.switchSignal()
        
        XCTAssert(ic.activeSignal == .west)
    }
    
    func testWestToNorthSwitch() {
        ic.activeSignal = .west
        ic.switchSignal()
        
        XCTAssert(ic.activeSignal == .north)
    }
    
    func testNorthToEastSwitch() {
        ic.activeSignal = .north
        ic.switchSignal()
        
        XCTAssert(ic.activeSignal == .east)
    }
}
