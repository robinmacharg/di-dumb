//
//  di_dumbTests.swift
//  di-dumbTests
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import XCTest
@testable import di_dumb

class di_dumbTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFailingResolution() throws {
        let resolver = Container()

        let result = resolver.resolve(Coffee.self)
        switch result {
        case .success(_):
            XCTFail()
        case .failure(let error as ContainerError):
            switch error {
            case .generalError(let string):
                XCTAssertEqual(string, ContainerError.errorTexts.noSuitableFactoryFound)
            }
        default:
            break
        }
    }

    func testCanRegisterAndResolveInstance() throws {
        let resolver = Container()
            .register(Coffee.self, instance: Caffeinated())
        XCTAssertTrue(try! resolver.resolve(Coffee.self).get() is Caffeinated)
    }

    func testCanRegisterAndResolveWithFactoryClosure() throws {
        let resolver = Container()
            .register(Coffee.self) { resolver in
                XCTAssertTrue(resolver is Container)
                return Caffeinated()
            }
        XCTAssertTrue(try! resolver.resolve(Coffee.self).get() is Caffeinated)
    }

    func testCanRegisterAndFailsWithUnregsiteredFactory() throws {
        let resolver = Container()
            .register(Coffee.self) { resolver in
                let factory = resolver.factory(for: Caffeinated.self)
                let result = factory()

                switch result {
                case .success(_):
                    XCTFail()
                case.failure(let error as ContainerError):
                    switch error {
                    case.generalError(let errorString):
                        fatalError(errorString)
                    }
                default:
                    fatalError("Unexpected execution")
                }
                fatalError("Unexpected execution")
            }
        expectFatalError(expectedMessage: ContainerError.errorTexts.noSuitableFactoryFound) {
            _ = try! resolver.resolve(Coffee.self).get()
        }
    }

    func testCanRegisterAndSucceedsWithRegsiteredFactory() throws {

        // Setup a container for injecting all the good things a a Mac programmer needs
        let macResolver = Container()
            // Coffee factory
            .register(Coffee.self) { _ in
                return Caffeinated()
            }
            .register(Computer.self, instance: Mac())
            .register(Programmer.self) { resolver in
                let programmer = Programmer()

                let coffeeFactory = resolver.factory(for: Coffee.self)
                programmer.coffeeFactory = coffeeFactory
                let computerFactory = resolver.factory(for: Computer.self)
                programmer.computer = try! computerFactory().get()

                return programmer
            }

        guard let aceProgrammer = try? macResolver.resolve(Programmer.self).get() else {
            XCTFail()
            return
        }

        XCTAssertTrue(aceProgrammer.coffee is Caffeinated)
        XCTAssertTrue(aceProgrammer.computer is Mac)

        let firstCoffee = aceProgrammer.brewCoffee()
        let secondCoffee = aceProgrammer.brewCoffee()
        XCTAssertFalse(firstCoffee as? Caffeinated === secondCoffee as? Caffeinated)

        let goodDayAtTheOffice = aceProgrammer.startTheDay()
        XCTAssertTrue(goodDayAtTheOffice)

        // PC
        let pcResolver = Container()
            .register(Coffee.self, instance: Decaf())
            .register(Computer.self, instance: PC())
            .register(Programmer.self) { resolver in
                let programmer = Programmer()

                let coffeeFactory = resolver.factory(for: Coffee.self)
                programmer.coffeeFactory = coffeeFactory
                let computerFactory = resolver.factory(for: Computer.self)
                programmer.computer = try! computerFactory().get()

                return programmer
            }

        guard let otherProgrammer = try? pcResolver.resolve(Programmer.self).get() else {
            XCTFail()
            return
        }

        XCTAssertTrue(otherProgrammer.coffee is Decaf)
        XCTAssertTrue(otherProgrammer.computer is PC)

        let firstPCCoffee = otherProgrammer.brewCoffee()
        let secondPCCoffee = otherProgrammer.brewCoffee()
        XCTAssertTrue(firstPCCoffee as? Caffeinated === secondPCCoffee as? Caffeinated)

        let notAGoodDayAtTheOffice = otherProgrammer.startTheDay()
        XCTAssertFalse(notAGoodDayAtTheOffice)
    }
}
