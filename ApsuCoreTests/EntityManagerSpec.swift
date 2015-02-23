//
//  EntityManagerSpec.swift
//  ApsuCore
//
//  Created by David Moles on 2/21/15.
//  Copyright (c) 2015 David Moles. All rights reserved.
//

import ApsuCore
import Quick
import Nimble

class EntityManagerSpec: QuickSpec {
    override func spec() {
        describe("an entity manager") {
            var manager: EntityManager?

            beforeEach { manager = EntityManager() }

            // ------------------------------
            // MARK: - Entity creation

            it ("should create a unique entity each time") {
                let e1 = manager!.newEntity()
                let e2 = manager!.newEntity()
                expect(e1).notTo(equal(e2))
            }

            // ------------------------------
            // MARK: - Nicknames

            it ("should not require nicknames") {
                let e = manager!.newEntity()
                expect(manager!.getNicknameForEntity(e)).to(beNil())
            }

            it ("should allow you to set a nickname at entity creation") {
                let nickname = "I am a nickname"
                let e = manager!.newEntityWithNickname(nickname)
                expect(manager!.getNicknameForEntity(e)).to(equal(nickname))
            }

            it ("should allow you to set a nickname after entity creation") {
                let e = manager!.newEntity()
                let nickname = "I am a nickname"
                manager!.setNicknameForEntity(e, nickname: nickname)
                expect(manager!.getNicknameForEntity(e)).to(equal(nickname))
            }

            it ("should allow you to change a nickname") {
                let e = manager!.newEntityWithNickname("Elvis")
                manager!.setNicknameForEntity(e, nickname: "Priscilla")
                expect(manager!.getNicknameForEntity(e)).to(equal("Priscilla"))
            }
            
            it ("should free an old nickname when you change it") {
                let e1 = manager!.newEntityWithNickname("Elvis")
                manager!.setNicknameForEntity(e1, nickname: "Priscilla")
                let e2 = manager!.newEntityWithNickname("Elvis")
                expect(manager!.getNicknameForEntity(e2)).to(equal("Elvis"))
            }

            it ("should not allow setting a duplicate nickname at creation time") {
                let nickname = "I am a nickname"
                let e1 = manager!.newEntityWithNickname(nickname)
                expect({ manager!.newEntityWithNickname("I am a nickname")}).to(raiseException(named:Exceptions.DuplicateNameException))
                expect(manager!.getNicknameForEntity(e1)).to(equal(nickname))
            }

            it ("should not allow setting a duplicate nickname after creation time") {
                let nickname = "I am a nickname"
                let e1 = manager!.newEntityWithNickname(nickname)
                let e2 = manager!.newEntity()
                expect({ manager!.setNicknameForEntity(e2, nickname:"I am a nickname")}).to(raiseException(named:Exceptions.DuplicateNameException))
                expect(manager!.getNicknameForEntity(e1)).to(equal(nickname))
                expect(manager!.getNicknameForEntity(e2)).to(beNil())
            }

            it ("should allow clearing a nickname") {
                let nickname = "I am a nickname"
                let e1 = manager!.newEntityWithNickname(nickname)
                let oldNickname = manager!.clearNicknameForEntity(e1)
                expect(oldNickname).to(equal(nickname))
                expect(manager!.getNicknameForEntity(e1)).to(beNil())
            }
        }
    }
}