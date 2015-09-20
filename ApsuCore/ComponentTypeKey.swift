//
// Created by David Moles on 2/24/15.
// Copyright (c) 2015 David Moles. All rights reserved.
//

import Foundation

public class ComponentTypeKey: Hashable {

    private let type: AnyClass

    public let hashValue: Int

    public let description: String

    init<T: AnyObject>(_ type: T.Type) {
        self.type = type
        self.hashValue = Int(CFHash(type))
        self.description = NSStringFromClass(type)
    }
}

public func == (lhs: ComponentTypeKey, rhs: ComponentTypeKey) -> Bool {
    return CFEqual(lhs.type, rhs.type)
}
