//
//  Resolver.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

public enum ResolverError: Error {
    case generalError(String)

    struct errorTexts {
        static let generalError = "An Unknown Error occurred"
    }
}

public protocol Resolver {
    func resolve<ServiceType>(_ type: ServiceType.Type) -> Result<ServiceType, Error>
}

public extension Resolver {
    func factory<ServiceType>(for type: ServiceType.Type) -> () -> Result<ServiceType, Error> {
        return { self.resolve(type) }
    }
}
