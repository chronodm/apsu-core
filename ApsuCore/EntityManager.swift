//
//  EntityManager.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

class EntityManager {

    // ------------------------------------------------------------
    // Fields

    var nicknames = Dictionary<Entity, String>()
    var nicknamesReverse = Dictionary<String, Entity>()

    var nextId: Int = 0

    // ------------------------------------------------------------
    // Entity creation helpers

    func newEntity() -> Entity {
        return Entity(id: nextId++)
    }

    func newEntity(nickname: String) -> Entity {
        let e = newEntity()
        setNickname(e, nickname: nickname)
        return e
    }

    // ------------------------------------------------------------
    // Methods on single entities

    func getNickname(e: Entity) -> String? {
        return nicknames[e]
    }

    func setNickname(e: Entity, nickname: String) -> String? {
        if let other = nicknamesReverse[nickname] {
            assert(false, "Nickname already in use")
            return nil
        }

        let oldNickname: String? = nicknames[e]
        nicknames[e] = nickname
        nicknamesReverse[nickname] = e
        return oldNickname
    }

    func clearNickname(e: Entity) -> String? {
        if let oldNickname = nicknames.removeValueForKey(e) {
            nicknamesReverse.removeValueForKey(oldNickname)
            return oldNickname
        }
        return nil
    }
}
