//
//  NetworkServiceFactory.swift
//  Bdum Tish
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation
import di_dumb

struct NetworkServiceFactory<ServiceType>: ServiceFactory {

    private let factory: (Resolver) -> ServiceType

    init(_ type: ServiceType.Type, factory: @escaping (Resolver) -> ServiceType) {
        self.factory = factory
    }

    func resolve(_ resolver: Resolver) -> ServiceType {
        return factory(resolver)
    }
}
