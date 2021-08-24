//
//  Container.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

public enum ContainerError: Error {
    case generalError(String)
    case factoryError
    case registrationError
    case resolutionError(message: String)
    case res
    case circularDependency(message: String, chain: [Any.Type])

    public struct errorTexts {
        public static let generalError = "An Unknown Error occurred"
        public static let noSuitableFactoryFound = "No Suitable Factory Found"
        public static let duplicateRegistrationAttempted = "Attempted to register an already registered type"
    }
}

/**
 * A dependency container.
 * Includes dependency registration and resolution functions.
 * Supports instance and factory dependencies.
 * Supports chaining of registrations
 */
public struct Container: Resolver {
    var factories: [AnyServiceFactory] = []

    public init() {}

    private init(factories: [AnyServiceFactory]) {
        self.factories = factories
    }

    public func reset() -> Container {
        return .init(factories: [])
    }

    var state: [Any.Type] = []

    // MARK: Register

    /**
     * Register a single instance to be resolved for a type.
     *
     * - Parameters:
     *     - interface: The type to register the instance for resolution for.
     *     - instance: The specific instance to resolve for the supplied type.
     */
    @discardableResult
    public func register<T>(_ interface: T.Type, instance: T) throws -> Container  {
        do {
            return try register(interface) { _ in instance }
        }
        catch let e {
            throw e
        }
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
    @discardableResult
    public func register<ServiceType>(_ type: ServiceType.Type, tag: String? = nil, _ factory: @escaping (Resolver) -> ServiceType) throws -> Container   {
        // Check we're not already registered for this type
        if factories.contains(where: { $0.supports(type, tag) }) {
            throw ContainerError.registrationError
        }

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

    // TODO: Try throws
    // TODO: handle recursion

    public mutating func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType? {
        return try? self.resolveOrThrow(type)
    }

    // debug only
    public mutating func resolveOrThrow<ServiceType>(_ type: ServiceType.Type) throws -> ServiceType {

        // Circular dependency
        if true /* contains() */ {
            defer {
                state = []
            }
            throw ContainerError.circularDependency(message: "circular dependency detected:", chain: state)
        }

        else {
            state.append(type)
            guard let factory = factories.first(where: { $0.supports(type) }) else {
                throw ContainerError.resolutionError(message: "Resolution failed")
            }
            let resolvedInstance = factory.resolve(self) as ServiceType

            state = state.filter({ type in
                return type is ServiceType
            })


//            state = state.filter({ t in
//                resolvedInstance is t
//            })
            return resolvedInstance
        }
    }

    /**
     * Resolve a factory for a given type.
     *
     * - Parameters:
     *     - type: The type to resolve the dependency for
     * - Returns: The factory that can produce instances of `type`
     */
    public func factory<ServiceType>(for type: ServiceType.Type) -> () -> ServiceType?  {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
//            return failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
            fatalError(ContainerError.errorTexts.noSuitableFactoryFound)
        }

        return  { factory.resolve(self) }
    }
}
