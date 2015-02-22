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
        let id: CFUUID = CFUUIDCreate(nil)
        let e = Entity(id)
        XCTAssert(e == e)
    }

    func testEntitiesWithSameIdAreEqual() {
        let id: CFUUID = CFUUIDCreate(nil)
        let e = Entity(id)
        XCTAssert(e == Entity(e.id))
    }

    func testEqualEntitiesAreEqual() {
        let id: CFUUID = CFUUIDCreate(nil)
        XCTAssert(Entity(id) == Entity(id))
    }

    func testUnequalEntitiesAreUnequal() {
        let id1 = CFUUIDCreate(nil)
        let id2 = CFUUIDCreate(nil)
        XCTAssertFalse(Entity(id1) == Entity(id2))
    }

    func testEqualEntitiesHaveEqualHashCodes() {
        let id: CFUUID = CFUUIDCreate(nil)
        XCTAssert(Entity(id).hashValue == Entity(id).hashValue)
    }

    func testEntityCreationTakesLessThanFiveMicroseconds() {
        let runs = 17
        let count = 1000

        var times = [Double]()
        for i in 0..<runs {
            let start = CFAbsoluteTimeGetCurrent()
            for j in 0..<count {
                CFUUIDCreate(nil)
                // Entity()
            }
            let time = CFAbsoluteTimeGetCurrent() - start
            times.append(time)
        }
        times.sort { $0 < $1 }
        let median = times[runs / 2] / Double(count)
//        println(median)
        XCTAssert(median < 5e-6)
    }
}
