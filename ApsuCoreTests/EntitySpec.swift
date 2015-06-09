//
//  EntitySpec.swift
//  ApsuCore
//
//  Created by David Moles on 2/21/15.
//  Copyright (c) 2015 David Moles. All rights reserved.
//

import ApsuCore
import Quick
import Nimble

class EntitySpec: QuickSpec {
    override func spec() {
        describe("an entity") {
            let expected_μs = 2
            it("should take less than \(expected_μs)μs to create") {
                let runs = 37
                let count = 5000

                var timesSeconds = [Double]()
                for _ in 0..<runs {
                    let startSeconds = CFAbsoluteTimeGetCurrent()
                    for _ in 0..<count {
                        Entity()
                    }
                    let timeSeconds = CFAbsoluteTimeGetCurrent() - startSeconds
                    timesSeconds.append(timeSeconds)
                }
                timesSeconds.sortInPlace { $0 < $1 }
                let medianSeconds = timesSeconds[runs / 2] / Double(count)
                let median_μs = medianSeconds * 1e6
//                println(medianμs)
                expect(median_μs).to(beLessThan(expected_μs))
            }

            it("should be equal to itself") {
                let id: CFUUID = CFUUIDCreate(nil)
                let e = Entity(id)
                expect(e).to(equal(e))
            }

            it("should be equal to an entity with the same ID") {
                let id: CFUUID = CFUUIDCreate(nil)
                let e = Entity(id)
                expect(e).to(equal(Entity(id)))
            }

            it("should not be equal to an entity with a different ID") {
                let id1 = CFUUIDCreate(nil)
                let id2 = CFUUIDCreate(nil)
                expect(Entity(id1)).notTo(equal(Entity(id2)))
            }

            describe("its id") {
                it ("should be different for consecutively created entities") {
                    let e1 = Entity()
                    let e2 = Entity()
                    let id1 = e1.id
                    let id2 = e2.id
                    expect(id1).notTo(equal(id2))
                }
            }

            describe("its hashcode") {
                it ("should consistently be the same value") {
                    let e = Entity()
                    expect(e.hashValue).to(equal(e.hashValue))
                }

                it ("should be equal for equal entities") {
                    let e1 = Entity()
                    let e2 = Entity(e1.id)
                    expect(e1.hashValue).to(equal(e2.hashValue))
                }

                it ("should be different for different entities") {
                    let e1 = Entity()
                    let e2 = Entity()
                    expect(e1.hashValue).notTo(equal(e2.hashValue))
                }
            }
        }
    }
}
