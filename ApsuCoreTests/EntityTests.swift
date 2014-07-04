//
//  EntityTests.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

import XCTest
import ApsuCore

class EntityTests: XCTestCase {

    func testEntitiesAreEqualToThemselves() {
        let e = Entity(id: 17)
        XCTAssert(e == e)
    }

    func testEqualEntitiesAreEqual() {
        XCTAssert(Entity(id: 1) == Entity(id: 1))
    }

    func testUnequalEntitiesAreUnequal() {
        XCTAssertFalse(Entity(id: 1) == Entity(id: 2))
    }

    func testEqualEntitiesHaveEqualHashCodes() {
        XCTAssert(Entity(id: 1).hashValue == Entity(id: 1).hashValue)
    }
}
