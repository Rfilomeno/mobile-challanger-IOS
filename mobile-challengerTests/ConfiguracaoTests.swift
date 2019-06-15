//
//  ConfiguracaoTests.swift
//  mobile-challengerTests
//
//  Created by Rodrigo Filomeno on 11/06/19.
//  Copyright © 2019 Filomeno. All rights reserved.
//

import XCTest
@testable import mobile_challenger

class ConfiguracaoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeveRetornarOCaminhoParaApiDoGitHub(){
        
        XCTAssertEqual("https://api.github.com/users/", Configuracao().getUrlGitHub())
    }

}
