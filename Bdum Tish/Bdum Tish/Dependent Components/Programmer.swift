//
//  Programmer.swift
//  Bdum Tish
//
//  Created by Robin Macharg2 on 07/08/2021.
//

import Foundation
import di_dumb

//struct CoffeeFactory<ServiceType>: ServiceFactory {
//
//    typealias ServiceType = Coffee
//
//    private let factory: (Resolver) -> ServiceType
//
//    init(_ type: ServiceType.Type, factory: @escaping (Resolver) -> ServiceType) {
//        self.factory = factory
//    }
//
//    func resolve(_ resolver: Resolver) -> ServiceType {
//        return factory(resolver)
//    }
//}

//class Programmer {
//
//    typealias DayStarted = Bool
//
//    public struct Errors {
//        static let missingServices = "Not all required services are available"
//    }
//
//    private var computer: Computer
//    private var coffee: Coffee
//
//    init(_ locator: Locator? = nil) {
//
//        guard let computer: Computer = locator?.resolve(),
//              let coffee: Coffee = locator?.resolve() else
//        {
//            fatalError(Errors.missingServices)
//        }
//
//        self.coffee = coffee
//        self.computer = computer
//    }
//
//    func startTheDay() -> DayStarted {
//
//        if computer.turnOn() {
//            coffee.percolate()
//            let caffination = coffee.drink()
//            if caffination > 20 {
//                DispatchQueue.global().async {
//                    self.codeLikeTheWind()
//                }
//                return true
//            }
//        }
//        return false
//    }
//
//    private func codeLikeTheWind() {
//        print("Tappety tap tap McTapster.  Ship it.")
//    }
//}

// @objc requirement for protocol conformation check could be seen as a limitation
protocol Computer {
    func turnOn() -> Bool
}

class Mac: Computer {
    required init() {}
    func turnOn() -> Bool {
        print("<Godly Chime> It just works.")
        return true
    }
}

class PC: Computer {
    required init() {}
    func turnOn() -> Bool {
        print("<Bump and Grind> Where do you want to go today?")
        return false
    }
}

protocol Coffee {
    init()
    typealias Caffination = Int
    func percolate()
    func drink() -> Int
}

//extension Coffee {
//    init() {
//        self.init()
//    }
//}

class Caf: Coffee {
    required init() {}
    func percolate() {}

    func drink() -> Caffination {
        return 100
    }
}

class Decaf: Coffee {

    required init() {}
    func percolate() {}

    func drink() -> Caffination {
        return 0
    }
}

protocol Language {}
class SwiftLang: Language {}
class CSharpLang: Language {}
