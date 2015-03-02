//
// Created by David Moles on 3/1/15.
// Copyright (c) 2015 David Moles. All rights reserved.
//

import Foundation

protocol ComponentStore {
    var count: Int { get }
    var isEmpty: Bool { get }

    mutating func removeComponentFor(entity: Entity)
}

class TypedComponentStore<T>: ComponentStore, SequenceType {

    // ------------------------------------------------------------
    // Fields

    private var componentsForEntities: [Entity:T] = [:]

    // ------------------------------------------------------------
    // Properties

    var count: Int {
        get {
            return componentsForEntities.count
        }
    }

    var isEmpty: Bool {
        get {
            return componentsForEntities.isEmpty
        }
    }

    // ------------------------------------------------------------
    // Constructors

    init() {
    }

    // ------------------------------------------------------------
    // Public methods

    func setComponent(component: T, forEntity entity: Entity) {
        componentsForEntities.updateValue(component, forKey: entity)
    }

    func getComponentFor(entity: Entity) -> T? {
        return componentsForEntities[entity]
    }

    func removeComponentFor(entity: Entity) {
        componentsForEntities.removeValueForKey(entity)
    }

    // ------------------------------------------------------------
    // SequenceType

    func generate() -> GeneratorOf<(Entity, T)> {
        return GeneratorOf(componentsForEntities.generate())
    }
}