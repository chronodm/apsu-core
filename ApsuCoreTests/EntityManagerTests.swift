//
//  EntityManagerTests.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

import XCTest
import ApsuCore

class EntityManagerTests: XCTestCase {

    // ------------------------------------------------------------
    // Fixture

    let mgr = EntityManager()

    // ------------------------------------------------------------
    // Entities

    func testNewEntityCreatesUniqueEntity() {
        let e1 = mgr.newEntity()
        let e2 = mgr.newEntity()
        XCTAssert(e1 != e2)
    }

    // ------------------------------------------------------------
    // Nicknames

    func testNicknamesAreOptional() {
        let e = mgr.newEntity()
        XCTAssert(mgr.getNickname(e) == nil)
    }

    func testNewEntityWithNicknameSetsNickname() {
        let nickname = "I am a nickname"
        let e = mgr.newEntity(nickname)
        XCTAssert(mgr.getNickname(e)! == nickname)
    }

    func testSetNicknameSetsNickname() {
        let e = mgr.newEntity()
        let nickname = "I am a nickname"
        mgr.setNickname(e, nickname: nickname)
        XCTAssert(mgr.getNickname(e)! == nickname)
    }

    // TODO figure out how to test asserts

//    func newEntityDisallowsDuplicateNicknames() {
//        let nickname = "I am a nickname"
//        let e1 = mgr.newEntity(nickname)
//        let e2 = mgr.newEntity(nickname) // should blow up
//    }

//    func testSetNicknameDisallowsDuplicates() {
//        let nickname = "I am a nickname"
//        let e1 = mgr.newEntity(nickname)
//
//        let e2 = mgr.newEntity()
//        mgr.setNickname(e2, nickname: nickname)
//        XCTAssert(!mgr.getNickname(e2))
//    }
}
