//
//  EntityManager.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

import Foundation

public class EntityManager {

    // ------------------------------------------------------------
    // MARK: - Fields

    private var nicknames: [Entity:String] = [:]
    private var nicknamesReverse: [String:Entity] = [:]

    private var components: [ComponentTypeKey:ComponentStore] = [:]

    // ------------------------------------------------------------
    // MARK: - Initializers

    public init() {
    }

    // ------------------------------------------------------------
    // MARK: - Entity methods

    public func newEntity() -> Entity {
        return Entity()
    }

    public func newEntityWithNickname(nickname: String) -> Entity {
        let entity = newEntity()
        setNicknameForEntity(entity, nickname: nickname)
        return entity
    }

    public func deleteEntity(entity: Entity) {
        let keys = components.keys
        for (var componentKey) in keys {
            removeComponentOfType(componentKey, forEntity: entity)
        }
        clearNicknameForEntity(entity)
    }

    // ------------------------------------------------------------
    // MARK: - Private component methods

    private func getComponentStore<T:AnyObject>(forType type: T.Type) -> TypedComponentStore<T>? {
        return components[ComponentTypeKey(type)] as TypedComponentStore<T>?
    }

    private func getOrCreateComponentStore<T:AnyObject>(forType type: T.Type) -> TypedComponentStore<T> {
        if var store = getComponentStore(forType: type) {
            return store
        }
        var store = TypedComponentStore<T>()
        components[ComponentTypeKey(type)] = store
        return store
    }

    private func removeComponentOfType(type: ComponentTypeKey, forEntity entity: Entity) -> Any? {
        if var store = components[type] {
            let oldVal = store.removeComponentFor(entity)
            if (store.isEmpty) {
                components.removeValueForKey(type)
            }
            return oldVal
        }
        return nil
    }

    // ------------------------------------------------------------
    // MARK: - Public component methods

    public func getComponentOfType<T:AnyObject>(type: T.Type, forEntity entity: Entity) -> T? {
        return getComponentStore(forType: type)?.getComponentFor(entity)
    }

    public func setComponent<T:AnyObject>(component: T, forEntity entity: Entity) {
        let type = T.self
        var store = getOrCreateComponentStore(forType: type)
        store.setComponent(component, forEntity: entity)
    }

    public func removeComponentOfType<T:AnyObject>(type: T.Type, forEntity entity: Entity) -> T? {
        return removeComponentOfType(ComponentTypeKey(type), forEntity: entity) as T?
    }

    public func hasComponentOfType<T:AnyObject>(type: T.Type, forEntity entity: Entity) -> Bool {
        if var store = getComponentStore(forType: type) {
            return store.hasComponentFor(entity)
        }
        return false
    }

//    public func allComponentsOfType<T: AnyObject>(type: T.Type) -> SequenceOf<(Entity, T)> {
//        if let existingMap = components[KeyForType(type)] {
//            return SequenceOf(existingMap)
//        } else {
//            let emptyMap: [Entity:T] = [:]
//            return SequenceOf(emptyMap)
//        }
//    }
/*
  override def allComponents(e: Entity): Iterable[Any] = {
    components.values.map((m) => m.get(e)).flatten
  }
*/

    // ------------------------------------------------------------
    // MARK: - Convenience methods

    public func getNicknameForEntity(e: Entity) -> String? {
        return nicknames[e]
    }

    public func setNicknameForEntity(e: Entity, nickname: String) -> String? {
        if let other = nicknamesReverse[nickname] {
            NSException(name: Exceptions.DuplicateNameException, reason: "An entity with the nickname \(nickname) already exists", userInfo: nil).raise()
            return nil
        }

        let oldNickname: String? = nicknames[e]
        nicknames[e] = nickname
        nicknamesReverse[nickname] = e
        if let old = oldNickname {
            nicknamesReverse.removeValueForKey(old)
        }
        return oldNickname
    }

    public func clearNicknameForEntity(e: Entity) -> String? {
        if let oldNickname = nicknames.removeValueForKey(e) {
            nicknamesReverse.removeValueForKey(oldNickname)
            return oldNickname
        }
        return nil
    }


}

