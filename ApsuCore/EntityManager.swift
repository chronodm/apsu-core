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

    var nicknames: [Entity:String] = [:]
    var nicknamesReverse: [String:Entity] = [:]

//   private val components = new mutable.OpenHashMap[ru.TypeTag[_], mutable.OpenHashMap[Entity, _]]()

    // ------------------------------------------------------------
    // MARK: - Initializers

    public init() {}

    // ------------------------------------------------------------
    // MARK: - Entity creation helpers

    public func newEntity() -> Entity {
        return Entity()
    }

    public func newEntityWithNickname(nickname: String) -> Entity {
        let entity = newEntity()
        setNicknameForEntity(entity, nickname: nickname)
        return entity
    }

    // ------------------------------------------------------------
    // MARK: - Component methods

    //   def get[C1](e: Entity)(implicit t: ru.TypeTag[C1]): Option[C1]

/*
func get<T: LGComponent>(type: T.Type) -> T?
{
    return components[type.type()] as? T
}
*/

//    func getComponentOfType<T: AnyObject>(type: T.Type, entity: Entity) -> T? {
//        let typeName = NSStringFromClass(type)
//        return nil
//    }

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

