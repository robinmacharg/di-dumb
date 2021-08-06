//
//  Resolver.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

public protocol Resolver {
    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType
}

public extension Resolver {
    func factory<ServiceType>(for type: ServiceType.Type) -> () -> ServiceType {
        return { self.resolve(type) }
    }
}
