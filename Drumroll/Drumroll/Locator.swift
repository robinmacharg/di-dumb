//
//  Locator.swift
//  Drumroll
//
//  Created by Robin Macharg2 on 07/08/2021.
//

// Implements a simple injected Service Locator-based Dependency Injection system
// Found here: https://www.vadimbulavin.com/dependency-injection-in-swift/, with modification

import Foundation

public protocol Locator {
    func resolve<T>() -> T?
    func register<T>(_ service: T)
}

public final class LocatorImpl: Locator {
    private var services: [ObjectIdentifier: Any] = [:]

    public init() {}

    public func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }

    public func resolve<T>() -> T? {
        if let service = services.compactMap({ $0.value as? T}).first {
            return service
        }
        return nil
    }

    private func key<T>(for type: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}

//class Client {
//    private let locator: Locator
//
//    init(locator: Locator) {
//        self.locator = locator
//    }
//
//    func doSomething() {
//        guard let service: Service = locator.resolve() else { return }
//        // do something with service
//    }
//}
//
//class Service {}
