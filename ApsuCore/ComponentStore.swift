//
// Created by David Moles on 3/1/15.
// Copyright (c) 2015 David Moles. All rights reserved.
//

import Foundation

// TODO is this just a marker or can we put some useful stuff on it
// TODO which methods / props don't need type specialization?
protocol ComponentStore: SequenceType {
}

// TODO name
class CS<T>: ComponentStore {

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

    func removeComponentFor(entity: Entity) {
        componentsForEntities.removeValueForKey(entity)
    }

    // ------------------------------------------------------------
    // SequenceType

    func generate() -> GeneratorOf<(Entity, T)> {
        return GeneratorOf(componentsForEntities.generate())
    }
}