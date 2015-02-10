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

    /*
      classOf[Entity].getSimpleName should "generate entities with unique UUIDs" in {
    val count: Int = 100
    val uuids: Set[UUID] = (for (i <- 0 until count) yield Entity().id).toSet
    uuids.size should be(count)
  }

  it should "be final" in {
    Modifier.isFinal(classOf[Entity].getModifiers) should be(true)
  }

  it should "take < 5us to create an Entity" in {
    val runs: Int = 11
    val count: Int = 1000

    val times = new Array[Long](runs)
    for (i <- 0 until runs) {
      val start = System.nanoTime()
      for (j <- 0 until count) {
        Entity()
      }
      times(i) = System.nanoTime() - start
    }
    util.Arrays.sort(times)
    val median = times(runs / 2) / count.asInstanceOf[Double]
    median should be < 5000.0
  }

    */
}
