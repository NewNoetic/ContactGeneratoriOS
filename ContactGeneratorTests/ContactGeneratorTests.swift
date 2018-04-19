//
//  ContactGeneratorTests.swift
//  ContactGeneratorTests
//
//  Created by Sidhant Gandhi on 4/19/18.
//  Copyright © 2018 NewNoetic, Inc. All rights reserved.
//

import XCTest
@testable import ContactGenerator
import PromiseKit
import Alamofire

class ContactGeneratorTests: XCTestCase {
    func testGenerator() {
        let expectation = XCTestExpectation(description: "generate")
        
        ContactGenerator.generate().done { (contacts) in
            print(contacts)
            expectation.fulfill()
        }
            .catch { (error) in
                XCTFail()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
