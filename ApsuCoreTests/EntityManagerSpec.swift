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

            beforeEach {
                mgr = EntityManager()
            }

            // ------------------------------
            // MARK: - Entity creation

            it("should create a unique entity each time") {
                let e1 = mgr!.newEntity()
                let e2 = mgr!.newEntity()
                expect(e1).notTo(equal(e2))
            }

            // ------------------------------
            // MARK: - Nicknames

            describe("its nickname functionality") {
                it("should not require nicknames") {
                    let e = mgr!.newEntity()
                    expect(mgr!.getNicknameForEntity(e)).to(beNil())
                }

                it("should allow you to set a nickname at entity creation") {
                    let nickname = "I am a nickname"
                    let e = mgr!.newEntityWithNickname(nickname)
                    expect(mgr!.getNicknameForEntity(e)).to(equal(nickname))
                }

                it("should allow you to set a nickname after entity creation") {
                    let e = mgr!.newEntity()
                    let nickname = "I am a nickname"
                    mgr!.setNicknameForEntity(e, nickname: nickname)
                    expect(mgr!.getNicknameForEntity(e)).to(equal(nickname))
                }

                it("should allow you to change a nickname") {
                    let e = mgr!.newEntityWithNickname("Elvis")
                    mgr!.setNicknameForEntity(e, nickname: "Priscilla")
                    expect(mgr!.getNicknameForEntity(e)).to(equal("Priscilla"))
                }

                it("should free an old nickname when you change it") {
                    let e1 = mgr!.newEntityWithNickname("Elvis")
                    mgr!.setNicknameForEntity(e1, nickname: "Priscilla")
                    let e2 = mgr!.newEntityWithNickname("Elvis")
                    expect(mgr!.getNicknameForEntity(e2)).to(equal("Elvis"))
                }

                it("should not allow setting a duplicate nickname at creation time") {
                    let nickname = "I am a nickname"
                    let e1 = mgr!.newEntityWithNickname(nickname)
                    expect({ mgr!.newEntityWithNickname("I am a nickname") }()).to(raiseException(named: Exceptions.DuplicateNameException))
                    expect(mgr!.getNicknameForEntity(e1)).to(equal(nickname))
                }

                it("should not allow setting a duplicate nickname after creation time") {
                    let nickname = "I am a nickname"
                    let e1 = mgr!.newEntityWithNickname(nickname)
                    let e2 = mgr!.newEntity()
                    expect({ mgr!.setNicknameForEntity(e2, nickname: "I am a nickname") }()).to(raiseException(named: Exceptions.DuplicateNameException))
                    expect(mgr!.getNicknameForEntity(e1)).to(equal(nickname))
                    expect(mgr!.getNicknameForEntity(e2)).to(beNil())
                }

                it("should allow clearing a nickname") {
                    let nickname = "I am a nickname"
                    let e1 = mgr!.newEntityWithNickname(nickname)
                    let oldNickname = mgr!.clearNicknameForEntity(e1)
                    expect(oldNickname).to(equal(nickname))
                    expect(mgr!.getNicknameForEntity(e1)).to(beNil())
                }

                it("should allow reuse of cleared nicknames") {
                    let nickname = "I am a nickname"
                    let e1 = mgr!.newEntityWithNickname(nickname)
                    mgr!.clearNicknameForEntity(e1)
                    let e2 = mgr!.newEntityWithNickname(nickname)
                    expect(mgr!.getNicknameForEntity(e2)).to(equal(nickname))
                }
            }

            describe("its delete method") {
                it("should delete all components") {
                    let e = mgr!.newEntity()
                    let c0 = SomeComponent(0)
                    let c1 = OtherComponent(1)

                    mgr!.setComponent(c0, forEntity: e)
                    mgr!.setComponent(c1, forEntity: e)

                    mgr!.deleteEntity(e)

                    expect(mgr!.hasComponentOfType(SomeComponent.self, forEntity: e)).to(beFalse())
                    expect(mgr!.hasComponentOfType(OtherComponent.self, forEntity: e)).to(beFalse())
                }

                it("should clear nicknames") {
                    let nickname = "I am a nickname"
                    let e = mgr!.newEntityWithNickname(nickname)
                    mgr!.deleteEntity(e)
                    expect(mgr!.getNicknameForEntity(e)).to(beNil())
                }
            }

            // ------------------------------
            // MARK: - Components

            describe("its set/get methods") {
                it("should set/get a component") {
                    let e = mgr!.newEntity()
                    let c = SomeComponent(0)
                    mgr!.setComponent(c, forEntity: e)
                    expect(mgr!.getComponentOfType(SomeComponent.self, forEntity: e)).to(beIdenticalTo(c))
                }
            }

            describe("its set method") {
                it("should replace existing components") {
                    let e = mgr!.newEntity()
                    let c0 = SomeComponent(0)
                    let c1 = SomeComponent(1)

                    mgr!.setComponent(c0, forEntity: e)
                    mgr!.setComponent(c1, forEntity: e)

                    let actual = mgr!.getComponentOfType(SomeComponent.self, forEntity: e)
                    expect(actual).to(beIdenticalTo(c1))
                }

                it("should support components of multiple types on an entity") {
                    let e = mgr!.newEntity()
                    let c0 = SomeComponent(0)
                    let c1 = OtherComponent(1)

                    mgr!.setComponent(c0, forEntity: e)
                    mgr!.setComponent(c1, forEntity: e)
                    let value0 = mgr!.getComponentOfType(SomeComponent.self, forEntity: e)
                    expect(value0).to(beIdenticalTo(c0))
                    let value1 = mgr!.getComponentOfType(OtherComponent.self, forEntity: e)
                    expect(value1).to(beIdenticalTo(c1))
                }
            }

            //  it should "disallow setting an entity as a component" in { mgr =>
            //    val e = mgr!.newEntity()
            //    val e1 = Entity()
            //    evaluating({
            //      mgr!.set(e, e1)
            //    }) should produce[IllegalArgumentException]
            //    evaluating({
            //      mgr!.set(e1, e)
            //    }) should produce[IllegalArgumentException]
            //  }

            describe("its get method") {
                it("should return nil for unset components") {
                    let e = mgr!.newEntity()
                    expect(mgr!.getComponentOfType(SomeComponent.self, forEntity: e)).to(beNil())
                }
            }

            describe("its has method") {
                it("should return true for set components") {
                    let e = mgr!.newEntity()
                    let c = SomeComponent(0)

                    mgr!.setComponent(c, forEntity: e)
                    expect(mgr!.hasComponentOfType(SomeComponent.self, forEntity: e)).to(beTrue())
                }

                it("should return false for unset components") {
                    let e = mgr!.newEntity()
                    expect(mgr!.hasComponentOfType(SomeComponent.self, forEntity: e)).to(beFalse())
                }
            }

            describe("its remove method") {
                it("should remove components") {
                    let e = mgr!.newEntity()
                    let c = SomeComponent(0)
                    mgr!.setComponent(c, forEntity: e)
                    mgr!.removeComponentOfType(SomeComponent.self, forEntity: e)
                    expect(mgr!.getComponentOfType(SomeComponent.self, forEntity: e)).to(beNil())
                }

                it("should return previous value, if set") {
                    let e = mgr!.newEntity()
                    let c = SomeComponent(0)
                    mgr!.setComponent(c, forEntity: e)
                    let oldValue = mgr!.removeComponentOfType(SomeComponent.self, forEntity: e)
                    expect(oldValue).to(beIdenticalTo(c))
                }

                it("should return nil for unset components") {
                    let e = mgr!.newEntity()
                    let oldValue = mgr!.removeComponentOfType(SomeComponent.self, forEntity: e)
                    expect(oldValue).to(beNil())
                }
            }

//            describe ("its allComponentsOfType method") {
//                it ("should return all and only entities with specified component type") {
//                    let e0 = mgr!.newEntity()
//                    let e1 = mgr!.newEntity()
//                    let e2 = mgr!.newEntity()
//                    let sc0 = SomeComponent(0)
//                    let sc1 = SomeComponent(1)
//                    let oc2 = OtherComponent(2)
//
//                    mgr!.setComponent(sc0, forEntity: e0)
//                    mgr!.setComponent(sc1, forEntity: e1)
//                    mgr!.setComponent(oc2, forEntity: e2)
//
//                    mgr!.allComponentsOfType
//                }
//            }

//            // ------------------------------------------------------------
//            // all()
//
//            "all()" should "return all and only entities with specified component type" in { mgr =>
//                    val e0 = mgr!.newEntity()
//                val e1 = mgr!.newEntity()
//                val e2 = mgr!.newEntity()
//                val sc0 = SomeComponent(0)
//                val sc1 = SomeComponent(1)
//                val oc2 = OtherComponent(2)
//
//                mgr!.set(e0, sc0)
//                mgr!.set(e1, sc1)
//                mgr!.set(e2, oc2)
//
//                mgr!.all[SomeComponent].toStream should contain only((e0, sc0), (e1, sc1))
//                mgr!.all[OtherComponent].toStream should contain only ((e2, oc2))
//            }
//
//            // ------------------------------------------------------------
//            // forAll()
//
//            "forAll()" should "return result for all and only entities with specified component type" in { mgr =>
//                    val e0 = mgr!.newEntity()
//                val e1 = mgr!.newEntity()
//                val e2 = mgr!.newEntity()
//                val sc0 = SomeComponent(0)
//                val sc1 = SomeComponent(1)
//                val oc2 = OtherComponent(2)
//
//                mgr!.set(e0, sc0)
//                mgr!.set(e1, sc1)
//                mgr!.set(e2, oc2)
//
//                def f0(e: Entity, c: SomeComponent) = {
//                    s"$e $c"
//                }
//
//                def f1(e: Entity, c: OtherComponent) = {
//                    s"$e $c"
//                }
//
//                mgr!.forAll[SomeComponent, String](f0).toStream should contain only(s"$e0 $sc0", s"$e1 $sc1")
//                mgr!.forAll[OtherComponent, String](f1).toStream should contain only s"$e2 $oc2"
//            }
//
//            "forAll()" should "execute on all and only entities with specified component type" in { mgr =>
//                    val e0 = mgr!.newEntity()
//                val e1 = mgr!.newEntity()
//                val e2 = mgr!.newEntity()
//                val sc0 = SomeComponent(0)
//                val sc1 = SomeComponent(1)
//                val oc2 = OtherComponent(2)
//
//                mgr!.set(e0, sc0)
//                mgr!.set(e1, sc1)
//                mgr!.set(e2, oc2)
//
//                val f0: (Entity, SomeComponent) => Unit = mock[(Entity, SomeComponent) => Unit]
//                val f1: (Entity, OtherComponent) => Unit = mock[(Entity, OtherComponent) => Unit]
//
//                mgr!.forAll[SomeComponent](f0)
//                mgr!.forAll[OtherComponent](f1)
//
//                verify(f0).apply(e0, sc0)
//                verify(f0).apply(e1, sc1)
//                verifyNoMoreInteractions(f0)
//
//                verify(f1).apply(e2, oc2)
//                verifyNoMoreInteractions(f1)
//            }
//
//            // ------------------------------------------------------------
//            // allComponents
//
//            "allComponents" should "return all components for an entity" in { mgr =>
//                    val e = mgr!.newEntity()
//                val c0 = SomeComponent(0)
//                val c1 = OtherComponent(0)
//
//                mgr!.set(e, c0)
//                mgr!.set(e, c1)
//
//                mgr!.allComponents(e).toStream should contain only(c0, c1)
//            }
//
//            it should "return an empty iterator for entities with no components" in { mgr =>
//                    val e = mgr!.newEntity()
//                mgr!.allComponents(e).toStream shouldBe empty
//            }

        }
    }
}

private class SomeComponent: CustomStringConvertible {
    let id: Int
    let description: String
    private init(_ id: Int) {
        self.id = id
        self.description = "SomeComponent(\(id))"
    }
}

private class OtherComponent: CustomStringConvertible {
    let id: Int
    let description: String
    private init(_ id: Int) {
        self.id = id
        self.description = "OtherComponent(\(id))"
    }
}
