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

    // This is actually [KeyForType<T>:[Entity:T]] but Swift generics aren't rich enough
    private var components: [ComponentTypeKey:[Entity:AnyObject]] = [:]

    // ------------------------------------------------------------
    // MARK: - Initializers

    public init() {}

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
        for (var componentMap) in components.values {
            componentMap.removeValueForKey(entity)
        }
        clearNicknameForEntity(entity)
    }

    // ------------------------------------------------------------
    // MARK: - Component methods

    public func getComponentOfType<T: AnyObject>(type: T.Type, entity: Entity) -> T? {
        return components[ComponentTypeKey(type)]?[entity] as T?
    }

    public func setComponent<T: AnyObject>(component: T, entity: Entity) {
        let type = T.self
        if var existingMap = components[ComponentTypeKey(type)] {
            existingMap[entity] = component
            components[ComponentTypeKey(type)] = existingMap // TODO why
        } else {
            components[ComponentTypeKey(type)] = [entity:component]
        }
    }

    public func removeComponentOfType<T: AnyObject>(type: T.Type, entity: Entity) -> T? {
        // TODO should this remove empty maps?
        if var m = components[ComponentTypeKey(type)] {
            return m.removeValueForKey(entity) as T?
        } else {
            return nil
        }
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

