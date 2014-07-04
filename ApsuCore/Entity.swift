//
//  Entity.swift
//  ApsuCore
//
//  Created by David Moles on 7/4/14.
//  Copyright (c) 2014 David Moles. All rights reserved.
//

struct Entity: Hashable {
    let id: Int
    var hashValue: Int { return id.hashValue }

    init(id: Int) {
        self.id = id
    }
}

func == (lhs: Entity, rhs: Entity) -> Bool {
    return lhs.id == rhs.id
}