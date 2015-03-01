//
//  Entity.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

public struct Entity: Hashable, Printable {
    // ------------------------------------------------------------
    // MARK: - Fields

    public let id: CFUUID
    public let hashValue: Int
    public var description: String {
        get {
            let idString: String = CFUUIDCreateString(nil, id)
            return "Entity(\(idString))"
        }
    }

    // ------------------------------------------------------------
    // MARK: - Initializers

    public init(_ id: CFUUID) {
        self.id = id
        self.hashValue = Int(CFHash(id))
    }

    public init() {
        let uuid = CFUUIDCreate(nil)
        self.id = uuid
        self.hashValue = Int(CFHash(uuid))
    }
}

// ------------------------------------------------------------
// MARK: - Equatable

public func == (lhs: Entity, rhs: Entity) -> Bool {
    return lhs.id == rhs.id
}
