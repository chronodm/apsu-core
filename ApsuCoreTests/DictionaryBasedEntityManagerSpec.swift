//
//  DictionaryBasedEntityManagerSpec.swift
//  ApsuCore
//
//  Created by David Moles on 2/21/15.
//  Copyright (c) 2015 David Moles. All rights reserved.
//

import ApsuCore
import Quick
import Nimble

class DictionaryBasedEntityManagerSpec: QuickSpec {
    override func spec() {
        describe("an entity manager") {
            var manager: DictionaryBasedEntityManager?

            beforeEach { manager = DictionaryBasedEntityManager() }

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

            // ------------------------------
            // MARK: - Components


            describe ("its set()/get() methods") {
                it ("should set/get a component") {
                    let entity = manager!.newEntity()
                    let component = SomeComponent(0)
                    manager!.setComponent(component, entity: entity)
                    expect(manager!.getComponentOfType(SomeComponent.self, entity: entity)).to(beIdenticalTo(component))
                }
            }

            describe ("its set() method") {
                it ("should replace existing components") {
                    let entity = manager!.newEntity()
                    let component0 = SomeComponent(0)
                    let component1 = SomeComponent(1)

                    manager!.setComponent(component0, entity: entity)
                    manager!.setComponent(component1, entity: entity)
                    expect(manager!.getComponentOfType(SomeComponent.self, entity: entity)).to(beIdenticalTo(component1))
                }

                it ("should support components of multiple types on an entity") {
                    let entity = manager!.newEntity()
                    let component0 = SomeComponent(0)
                    let component1 = OtherComponent(1)

                    manager!.setComponent(component0, entity: entity)
                    manager!.setComponent(component1, entity: entity)
                    expect(manager!.getComponentOfType(SomeComponent.self, entity: entity)).to(beIdenticalTo(component0))
                    expect(manager!.getComponentOfType(OtherComponent.self, entity: entity)).to(beIdenticalTo(component1))
                }
            }

        //  it should "support components of multiple types" in { mgr =>
        //    val e = mgr.newEntity()
        //    val c0 = SomeComponent(0)
        //    val c1 = OtherComponent(1)
        //    mgr.set(e, c0)
        //    mgr.set(e, c1)
        //    mgr.get[SomeComponent](e) should be(Some(c0))
        //    mgr.get[OtherComponent](e) should be(Some(c1))
        //  }
        //
        //  it should "disallow setting an entity as a component" in { mgr =>
        //    val e = mgr.newEntity()
        //    val e1 = Entity()
        //    evaluating({
        //      mgr.set(e, e1)
        //    }) should produce[IllegalArgumentException]
        //    evaluating({
        //      mgr.set(e1, e)
        //    }) should produce[IllegalArgumentException]
        //  }
        //
        //  "get()" should "return None for unset components" in { mgr =>
        //    val e = mgr.newEntity()
        //    mgr.get[SomeComponent](e) should be(None)
        //  }
        //
        //  "has()" should "return true for set components" in { mgr =>
        //    val e = mgr.newEntity()
        //    val c = SomeComponent(0)
        //
        //    mgr.set(e, c)
        //    mgr.has[SomeComponent](e) should be(true)
        //  }
        //
        //  it should "return false for unset components" in { mgr =>
        //    val e = mgr.newEntity()
        //    mgr.has[SomeComponent](e) should be(false)
        //  }
        //
        //  "remove()" should "return previous value for set component" in { mgr =>
        //    val e = mgr.newEntity()
        //    val c = SomeComponent(0)
        //
        //    mgr.set(e, c)
        //    mgr.remove[SomeComponent](e) should be(Some(c))
        //  }
        //
        //  it should "return None for unset components" in { mgr =>
        //    val e = mgr.newEntity()
        //    mgr.remove[SomeComponent](e) should be(None)
        //  }

        }
    }
}

private class SomeComponent {
    let id: Int
    private init(_ id: Int) {
        self.id = id
    }
}

private class OtherComponent {
    let id: Int
    private init(_ id: Int) {
        self.id = id
    }
}
