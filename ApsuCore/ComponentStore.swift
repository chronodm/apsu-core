//
// Created by David Moles on 3/1/15.
// Copyright (c) 2015 David Moles. All rights reserved.
//

import Foundation

protocol ComponentStore {
    var count: Int { get }
    var isEmpty: Bool { get }

    mutating func removeComponentFor(entity: Entity) -> Any?
}


public class ComponentRef<T>: Equatable {
    public let entity: Entity
    public let component: T

    init(entity: Entity, component: T) {
        self.entity = entity
        self.component = component
    }
}

// ------------------------------------------------------------
// MARK: - Equatable

//public func == <T: Equatable> (lhs: ComponentRef<T>, rhs: ComponentRef<T>) -> Bool {
//    return lhs.entity == rhs.entity && lhs.component == rhs.component
//}

// TODO: get this working & change TypedComponentStore to return a sequence of it
public func == <T> (lhs: ComponentRef<T>, rhs: ComponentRef<T>) -> Bool {
    return (lhs.component === rhs.component) // && (lhs.entity == rhs.entity)
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

    func hasComponentFor(entity: Entity) -> Bool {
        return componentsForEntities[entity] != nil
    }

    // untyped to fit non-generic protocol
    func removeComponentFor(entity: Entity) -> Any? {
        return componentsForEntities.removeValueForKey(entity)
    }

    // ------------------------------------------------------------
    // SequenceType

    func generate() -> AnyGenerator<(Entity, T)> {
        return anyGenerator(componentsForEntities.generate())
    }
}
