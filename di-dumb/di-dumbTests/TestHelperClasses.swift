//
//  TestHelperClasses.swift
//  di-dumbTests
//
//  Created by Robin Macharg2 on 07/08/2021.
//

import Foundation

class Programmer {

    typealias DayStarted = Bool

    var computerFactory: () -> Result<Computer, Error> = { fatalError("Compuer factory must be injected") }
    var coffeeFactory: () -> Result<Coffee, Error> = { fatalError("Coffee factory must be injected") }

    var computer: Computer!
    var coffee: Coffee { try! coffeeFactory().get() }

    func startTheDay() -> DayStarted {

        if computer.turnOn() {
            coffee.percolate()
            let caffination = coffee.drink()
            if caffination > 20 {
                DispatchQueue.global().async {
                    self.codeLikeTheWind()
                }
                return true
            }
        }
        return false
    }

    public func brewCoffee() -> Coffee? {
        guard let coffee = try? coffeeFactory().get() else {
            return nil
        }
        return coffee
    }

    private func codeLikeTheWind() {
        print("Tappety tap tap McTapster.  Ship it.")
    }
}

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

class Caffeinated: Coffee {
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
