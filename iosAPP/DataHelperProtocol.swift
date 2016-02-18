//
//  DataHelperProtocol.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 17/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import Foundation

protocol DataHelperProtocol {
    typealias T
    static func createTable() throws -> Void
   static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
    static func find(id: Int64) throws -> T?
}