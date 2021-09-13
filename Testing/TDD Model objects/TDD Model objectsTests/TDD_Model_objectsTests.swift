//
//  TDD_Model_objectsTests.swift
//  TDD Model objectsTests
//
//  Created by Ryan Bitner on 9/13/21.
//

import XCTest
@testable import TDD_Model_objects

class TDD_Model_objectsTests: XCTestCase {
    
    
    override class func setUp() {
//        newPersonNoHeightNoWeight = Person(name: "Ryan", age: 20)
//        newPersonWithHeightWithWeight = Person(name: "Billy Bob", age: 37, height: 60, weight: 147)
    }
    
    override class func tearDown() {
        return
    }

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func test_Person_RequiredProperties() throws {
        let newPersonNoHeightNoWeight = Person(name: "Ryan", age: 20)
        XCTAssertTrue(newPersonNoHeightNoWeight.name == "Ryan")
        XCTAssertEqual(newPersonNoHeightNoWeight.age, 20)
    }

    func test_Person_AllProperties() throws {
        let newPersonWithHeightWithWeight = Person(name: "Billy Bob", age: 37, height: 60, weight: 147)
        
        XCTAssertTrue(newPersonWithHeightWithWeight.name == "Billy Bob")
        XCTAssertEqual(newPersonWithHeightWithWeight.age, 37)
        XCTAssertNotNil(newPersonWithHeightWithWeight.height)
        XCTAssertNotNil(newPersonWithHeightWithWeight.weight)
    }

}
