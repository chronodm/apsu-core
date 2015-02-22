//
//  EntityManager.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

public class EntityManager {

    // ------------------------------------------------------------
    // MARK: - Fields

    var nicknames = Dictionary<Entity, String>()
    var nicknamesReverse = Dictionary<String, Entity>()

    var nextId: Int = 0

    // ------------------------------------------------------------
    // MARK: - Initializers

    public init() {}

    // ------------------------------------------------------------
    // MARK: - Entity creation helpers

    public func newEntity() -> Entity {
        return Entity()
    }

    public func newEntity(nickname: String) -> Entity {
        let e = newEntity()
        setNickname(e, nickname: nickname)
        return e
    }

    // ------------------------------------------------------------
    // MARK: - Methods on single entities

    public func getNickname(e: Entity) -> String? {
        return nicknames[e]
    }

    public func setNickname(e: Entity, nickname: String) -> String? {
        if let other = nicknamesReverse[nickname] {
            NSException(name: Exceptions.DuplicateName, reason: "An entity with the nickname \(nickname) already exists", userInfo: nil).raise()
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

    public func clearNickname(e: Entity) -> String? {
        if let oldNickname = nicknames.removeValueForKey(e) {
            nicknamesReverse.removeValueForKey(oldNickname)
            return oldNickname
        }
        return nil
    }
}

