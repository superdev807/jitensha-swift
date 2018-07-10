//
//  jitenshaTests.swift
//  jitenshaTests
//
//  Created by Benjamin Chris on 12/12/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import XCTest
@testable import jitensha

class jitenshaTests: XCTestCase {

    var placesTest: PlacesViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        placesTest = PlacesViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        placesTest = nil
    }
    
    func testPlacesLength() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        placesTest.loadPlaces()
        _ = placesTest.places.asObservable().subscribe(onNext: {(places) in
            XCTAssert(places.count == 20)
        })
    }
}
