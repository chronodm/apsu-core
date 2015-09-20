//
//  CFUUIDExtensions.swift
//  ApsuCore
//
//  Created by David Moles on 2/21/15.
//  Copyright (c) 2015 David Moles. All rights reserved.
//

// MARK: - Equatable
extension CFUUID: Equatable {}

public func == (lhs: CFUUID, rhs: CFUUID) -> Bool {
    return CFEqual(lhs, rhs)
}