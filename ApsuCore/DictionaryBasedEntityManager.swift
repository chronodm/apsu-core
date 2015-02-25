//
//  EntityManager.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

import Foundation

public class DictionaryBasedEntityManager {

    // ------------------------------------------------------------
    // MARK: - Fields

    private var nicknames: [Entity:String] = [:]
    private var nicknamesReverse: [String:Entity] = [:]
    private var components: [KeyForType:[Entity:AnyObject]] = [:]

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

    private func componentsForType<T: AnyObject>(type: T.Type) -> [Entity:AnyObject]? {
        return components[KeyForType(type)]
    }

    public func getComponentOfType<T: AnyObject>(type: T.Type, entity: Entity) -> T? {
        return componentsForType(type)?[entity] as T?
    }

    public func setComponentOfType<T: AnyObject>(type: T.Type, entity: Entity, component: T) {
        if var m = componentsForType(type) {
            m[entity] = component
        } else {
            components[KeyForType(type)] = [entity:component]
        }
    }

    public func removeComponentOfType<T: AnyObject>(type: T.Type, entity: Entity) -> T? {
        if var m = componentsForType(type) {
            return m.removeValueForKey(entity) as T?
        } else {
            return nil
        }
    }

    // TODO: replace the inner map with something generic that implements the Sequence protocol
    // cf. http://natashatherobot.com/swift-conform-to-sequence-protocol/

/*
  override def all[C1](implicit t: ru.TypeTag[C1]): Iterable[(Entity, C1)] = {
    mapFor[C1] match {
      case Some(m) => m
      case _ => Iterable.empty[(Entity, C1)]
    }
  }

  override def allComponents(e: Entity): Iterable[Any] = {
    components.values.map((m) => m.get(e)).flatten
  }
*/

    public func allComponentsOfType<T: AnyObject>(type: T.Type)

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

