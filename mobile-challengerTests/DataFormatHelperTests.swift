//
//  DataFormatHelperTests.swift
//  mobile-challengerTests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class DataFormatHelperTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeveRetornarUmaStringComADataEmFormatoddMMyyyy(){
        
        XCTAssertEqual("12/10/1980", DataFormatHelper().formata("1980-10-12:blabla"))
        XCTAssertEqual("01/06/2019", DataFormatHelper().formata("2019-06-01:testetesteteste"))
    }

}
