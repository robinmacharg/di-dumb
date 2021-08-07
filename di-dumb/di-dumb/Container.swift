//
//  Container.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

public enum ContainerError: Error {
    case generalError(String)

    public struct errorTexts {
        public static let generalError = "An Unknown Error occurred"
        public static let noSuitableFactoryFound = "No Suitable Factory Found"
    }
}

public struct Container: Resolver {

    public struct Errors {
        public static let noSuitableFactoryFound = "No suitable factory found"
    }

    let factories: [AnyServiceFactory]

    public init() {
        self.factories = []
    }

    private init(factories: [AnyServiceFactory]) {
        self.factories = factories
    }

    // MARK: Register

    public func register<T>(_ interface: T.Type, instance: T) -> Container {
        return register(interface) { _ in instance }
    }

    public func register<ServiceType>(_ type: ServiceType.Type, _ factory: @escaping (Resolver) -> ServiceType) -> Container {
        assert(!factories.contains(where: { $0.supports(type) }))

        let newFactory = BasicServiceFactory<ServiceType>(type, factory: { resolver in
            factory(resolver)
        })
        return .init(factories: factories + [AnyServiceFactory(newFactory)])
    }

    // MARK: Resolver

    public func resolve<ServiceType>(_ type: ServiceType.Type) -> Result<ServiceType, Error> {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
            return .failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
//            fatalError(Errors.noSuitableFactoryFound)
        }
        return .success(factory.resolve(self))
    }

    public func factory<ServiceType>(for type: ServiceType.Type) -> () -> ServiceType  {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
//            return failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
            fatalError(Errors.noSuitableFactoryFound)
        }

        return  { factory.resolve(self) }
    }
}
