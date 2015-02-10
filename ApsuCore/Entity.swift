//
//  Entity.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

public struct Entity: Hashable {
    public let id: CFUUID
    public let hashValue: Int
//    public var hashValue: Int { return id.hashValue }

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

public func == (lhs: Entity, rhs: Entity) -> Bool {
    return CFEqual(lhs.id, rhs.id) != 0
}