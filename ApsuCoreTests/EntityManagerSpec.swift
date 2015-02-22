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
            var mgr: EntityManager?

            beforeEach { mgr = EntityManager() }

            it ("should create a unique entity each time") {
                let e1 = mgr!.newEntity()
                let e2 = mgr!.newEntity()
                expect(e1).notTo(equal(e2))
            }

            it ("should not require nicknames") {
                let e = mgr!.newEntity()
                expect(mgr!.getNickname(e)).to(beNil())
            }

            it ("should allow you to set a nickname at entity creation") {
                let nickname = "I am a nickname"
                let e = mgr!.newEntity(nickname)
                expect(mgr!.getNickname(e)).to(equal(nickname))
            }

            it ("should allow you to set a nickname after entity creation") {
                let e = mgr!.newEntity()
                let nickname = "I am a nickname"
                mgr!.setNickname(e, nickname: nickname)
                expect(mgr!.getNickname(e)).to(equal(nickname))
            }

            it ("should allow you to change a nickname") {
                let e = mgr!.newEntity("Elvis")
                mgr!.setNickname(e, nickname: "Priscilla")
                expect(mgr!.getNickname(e)).to(equal("Priscilla"))
            }
            
            it ("should free an old nickname when you change it") {
                let e1 = mgr!.newEntity("Elvis")
                mgr!.setNickname(e1, nickname: "Priscilla")
                let e2 = mgr!.newEntity("Elvis")
                expect(mgr!.getNickname(e2)).to(equal("Elvis"))
            }

            it ("should not allow setting a duplicate nickname at creation time") {
                let nickname = "I am a nickname"
                let e1 = mgr!.newEntity(nickname)
                expect({mgr!.newEntity("I am a nickname")}).to(raiseException(named:Exceptions.DuplicateName))
                expect(mgr!.getNickname(e1)).to(equal(nickname))
            }

            it ("should not allow setting a duplicate nickname after creation time") {
                let nickname = "I am a nickname"
                let e1 = mgr!.newEntity(nickname)
                let e2 = mgr!.newEntity()
                expect({mgr!.setNickname(e2, nickname:"I am a nickname")}).to(raiseException(named:Exceptions.DuplicateName))
                expect(mgr!.getNickname(e1)).to(equal(nickname))
                expect(mgr!.getNickname(e2)).to(beNil())
            }

            // TODO: - Test clearing nicknames
        }
    }
}