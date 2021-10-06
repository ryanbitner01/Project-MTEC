//
//  TestingArchitectureTests.swift
//  TestingArchitectureTests
//
//  Created by Ryan Bitner on 9/16/21.
//

import XCTest
@testable import TestingArchitecture

class TestingArchitectureTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Quote_QuoteNotNil() throws {
        let predicate = NSPredicate { (object, nil) -> Bool in
            guard let quoteManager = object as? QuoteManager else {return false}
            return quoteManager.quote != nil
        }
        let quoteManager = QuoteManager(quoteGen: MockNetwork())
        
        XCTAssertNil(quoteManager.quote)
        quoteManager.getRandomQuote()
        
        expectation(for: predicate, evaluatedWith: quoteManager, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(quoteManager.quote?.value, "Trump Said this")
        XCTAssertEqual(quoteManager.quote?.id, "Test0")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
