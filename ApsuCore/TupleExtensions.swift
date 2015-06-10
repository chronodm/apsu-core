//
//  TupleExtensions.swift
//  ApsuCore
//
//  Created by David Moles on 6/9/15.
//  Copyright © 2015 David Moles. All rights reserved.
//

// MARK: - Equatable
extension (T:Equatable, T:Equatable): Equatable {}

public func == <T1:Equatable, T2:Equatable> (tuple1:(T1,T2),tuple2:(T1,T2)) -> Bool
{
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}