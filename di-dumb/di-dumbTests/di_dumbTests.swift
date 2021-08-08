//
//  di_dumbTests.swift
//  di-dumbTests
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import XCTest
@testable import di_dumb

class di_dumbTests: XCTestCase {

    let container = Container()

    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    /**
     * Test that we can reset a container
     */
    func testContainerReset() throws {
        var resolver1 = Container()
        XCTAssertEqual(resolver1.factories.count, 0)
        resolver1 = try! resolver1.register(Computer.self, instance: Mac())
        XCTAssertEqual(resolver1.factories.count, 1)
        resolver1 = try!resolver1.register(Coffee.self, instance: Decaf())
        XCTAssertEqual(resolver1.factories.count, 2)

        var resolver2 = Container()
        XCTAssertEqual(resolver2.factories.count, 0)
        resolver2 = try!resolver2.register(Computer.self, instance: PC())
        XCTAssertEqual(resolver2.factories.count, 1)
        resolver2 = try! resolver2.register(Coffee.self, instance: Caffeinated())
        XCTAssertEqual(resolver2.factories.count, 2)

        resolver1 = resolver1.reset()
        XCTAssertEqual(resolver1.factories.count, 0)
        XCTAssertEqual(resolver2.factories.count, 2)

        resolver2 = resolver2.reset()
        XCTAssertEqual(resolver1.factories.count, 0)
        XCTAssertEqual(resolver2.factories.count, 0)

        resolver1 = try! resolver1.register(Computer.self, instance: Mac())
        XCTAssertEqual(resolver1.factories.count, 1)
    }

    func testFailingResolution() throws {
        let resolver = Container()

        if resolver.resolve(Coffee.self) != nil {
            XCTFail()
        }
//        switch result {
//        case .success(_):
//            XCTFail()
//        case .failure(let error as ContainerError):
//            switch error {
//            case .generalError(let string):
//                XCTAssertEqual(string, ContainerError.errorTexts.noSuitableFactoryFound)
//            default:
//                XCTFail()
//            }
//        default:
//            break
//        }
    }

    func testCanRegisterAndResolveInstance() throws {
        let resolver = try! Container()
            .register(Coffee.self, instance: Caffeinated())
            XCTAssertTrue(resolver.resolve(Coffee.self)! is Caffeinated)
    }

    func testDoubleRegistrationFails() throws {
        XCTAssertThrowsError(try Container()
            .register(Coffee.self, instance: Caffeinated())
            .register(Coffee.self, instance: Caffeinated()))
        { error in
            XCTAssertEqual(error as? ContainerError, .registrationError)
        }
    }

    func testCanRegisterAndResolveWithFactoryClosure() throws {
        let resolver = try! Container()
            .register(Coffee.self, { resolver in
                XCTAssertTrue(resolver is Container)
                return Caffeinated()
            })

        XCTAssertTrue(resolver.resolve(Coffee.self)! is Caffeinated)
    }

    func testCanRegisterAndFailsWithUnregsiteredFactory() throws {
        let resolver = try! Container()
            .register(Coffee.self) { resolver in
                let factory = resolver.factory(for: Caffeinated.self)
                let result = factory()

                if let result = factory() {
                    XCTFail()
                }


//                switch result {
//                case .success(_):
//                    XCTFail()
//                case.failure(let error as ContainerError):
//                    switch error {
//                    case.generalError(let errorString):
//                        fatalError(errorString)
//                    default:
//                        XCTFail()
//                    }
//                default:
//                    fatalError("Unexpected execution")
//                }
                fatalError("Unexpected execution")
            }
//        expectFatalError(expectedMessage: ContainerError.errorTexts.noSuitableFactoryFound) {
//            _ = try! resolver.resolve(Coffee.self).get()
//        }
    }

//    func testCanRegisterAndSucceedsWithRegsiteredFactory() throws {
//
//        // Setup a container for injecting all the good things a a Mac programmer needs
//        let macResolver = try! Container()
//            // Coffee factory
//            .register(Coffee.self) { _ in
//                return Caffeinated()
//            }
//            .register(Computer.self, instance: Mac())
//            .register(Programmer.self) { resolver in
//                let programmer = Programmer()
//
//                let coffeeFactory = resolver.factory(for: Coffee.self)
//                programmer.coffeeFactory = coffeeFactory
//                let computerFactory = resolver.factory(for: Computer.self)
//                programmer.computer = try! computerFactory().get()
//
//                return programmer
//            }
//
//        guard let macProgrammer = try? macResolver.resolve(Programmer.self).get() else {
//            XCTFail()
//            return
//        }
//
//        XCTAssertTrue(macProgrammer.coffee is Caffeinated)
//        XCTAssertTrue(macProgrammer.computer is Mac)
//
//        let firstCoffee = macProgrammer.brewCoffee()
//        let secondCoffee = macProgrammer.brewCoffee()
//        XCTAssertFalse(firstCoffee as? Caffeinated === secondCoffee as? Caffeinated)
//
//        let goodDayAtTheOffice = macProgrammer.startTheDay()
//        XCTAssertTrue(goodDayAtTheOffice)
//
//        // PC
//        let pcResolver = try! Container()
//            .register(Coffee.self, instance: Decaf())
//            .register(Computer.self, instance: PC())
//            .register(Programmer.self) { resolver in
//                let programmer = Programmer()
//
//                let coffeeFactory = resolver.factory(for: Coffee.self)
//                programmer.coffeeFactory = coffeeFactory
//                let computerFactory = resolver.factory(for: Computer.self)
//                programmer.computer = try! computerFactory().get()
//
//                return programmer
//            }
//
//        guard let pcProgrammer = try? pcResolver.resolve(Programmer.self).get() else {
//            XCTFail()
//            return
//        }
//
//        XCTAssertTrue(pcProgrammer.coffee is Decaf)
//        XCTAssertTrue(pcProgrammer.computer is PC)
//
//        let firstPCCoffee = pcProgrammer.brewCoffee()
//        let secondPCCoffee = pcProgrammer.brewCoffee()
//        XCTAssertTrue(firstPCCoffee as? Caffeinated === secondPCCoffee as? Caffeinated)
//
//        let notAGoodDayAtTheOffice = pcProgrammer.startTheDay()
//        XCTAssertFalse(notAGoodDayAtTheOffice)
//    }
}
