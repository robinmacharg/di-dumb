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

/**
 * A dependency container.
 * Includes dependency registration and resolution functions.
 * Supports instance and factory dependencies.
 * Supports chaining of registrations
 */
public struct Container: Resolver {

    public struct ErrorTexts {
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

    /**
     * Register a single instance to be resolved for a type.
     *
     * - Parameters:
     *     - interface: The type to register the instance for resolution for.
     *     - instance: The specific instance to resolve for the supplied type.
     */
    public func register<T>(_ interface: T.Type, instance: T) -> Container {
        return register(interface) { _ in instance }
    }

    /**
     * Register a factory closure for producing dependencies on-demand.  Allows for external logic to be
     * applied to dependency resolution.
     *
     * - Parameters:
     *     - type: The dependency type to register for
     *     - factory: A factory closure that can generate instances of the type on demand.
     * - Returns: An instance of self
     */
    public func register<ServiceType>(_ type: ServiceType.Type, _ factory: @escaping (Resolver) -> ServiceType) -> Container {
        assert(!factories.contains(where: { $0.supports(type) }))

        let newFactory = BasicServiceFactory<ServiceType>(type, factory: { resolver in
            factory(resolver)
        })
        return .init(factories: factories + [AnyServiceFactory(newFactory)])
    }

    // MARK: Resolver

    /**
     * Resolve a dependency for a given type by calling the appropriate factory method.
     *
     * - Parameters:
     *     - type: The type to resolve the dependency for
     */
    public func resolve<ServiceType>(_ type: ServiceType.Type) -> Result<ServiceType, Error> {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
            return .failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
//            fatalError(Errors.noSuitableFactoryFound)
        }
        return .success(factory.resolve(self))
    }

    /**
     * Resolve a factory for a given type.
     *
     * - Parameters:
     *     - type: The type to resolve the dependency for
     * - Returns: The factory that can produce instances of `type`
     */
    public func factory<ServiceType>(for type: ServiceType.Type) -> () -> ServiceType  {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
//            return failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
            fatalError(ErrorTexts.noSuitableFactoryFound)
        }

        return  { factory.resolve(self) }
    }
}
