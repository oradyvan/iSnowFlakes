//
//  SnowflakesMakerTests.swift
//  SnowflakesMakerTests
//
//  Created by Oleksiy Radyvanyuk on 07/11/2017.
//  Copyright © 2017 Oleksiy Radyvanyuk. All rights reserved.
//

import XCTest

class SnowflakesMakerTests: XCTestCase {

    let maker: SnowflakesMaker! = SnowflakesMaker(
        size: CGSize(width: 200, height: 200),
        screenScale: 2.0
    )

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSingleImage() {
        let image = maker.createSnowflake()
        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size.width, 200)
        XCTAssertEqual(image?.size.height, 200)
    }
}
