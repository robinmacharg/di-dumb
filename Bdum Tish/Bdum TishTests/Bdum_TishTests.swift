//
//  Bdum_TishTests.swift
//  Bdum TishTests
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import XCTest
@testable import Bdum_Tish
//import Drumroll
import di_dumb

protocol ProgrammerFactory {
    func makeCoffee() -> Coffee
    func makeComputer() -> Computer
}

class Bdum_TishTests: XCTestCase {

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
            .register(Coffee.self, instance: Caf())
        XCTAssertTrue(try! resolver.resolve(Coffee.self).get() is Caf)
    }

    func testCanRegisterAndResolveWithFactoryClosure() throws {
        let resolver = Container()
            .register(Coffee.self) { resolver in
                XCTAssertTrue(resolver is Container)
                return Caf()
            }
        XCTAssertTrue(try! resolver.resolve(Coffee.self).get() is Caf)
    }

    func testCanRegisterAndFailsWithUnregsiteredFactory() throws {
        let resolver = Container()
            .register(Coffee.self) { resolver in
                let factory = resolver.factory(for: Caf.self)
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



        let resolver = Container()
//            .register(Coffee.self) { <#Resolver#> in
//                <#code#>
//            }


//            { resolver in
//                let factory = resolver.factory(for: Caf.self)
//                let result = factory()
//
//                switch result {
//                case .success(let caf):
//                    XCTFail()
//                case.failure(let error as ContainerError):
//                    switch error {
//                    case.generalError(let errorString):
//                        fatalError(errorString)
//                    }
//                default:
//                    fatalError("Unexpected execution")
//                }
//                fatalError("Unexpected execution")
//            }
//        expectFatalError(expectedMessage: ContainerError.errorTexts.noSuitableFactoryFound) {
//            try! resolver.resolve(Coffee.self).get()
//        }
    }


// Drumroll tests

//    func testNoServicesRegisteredFails() throws {
//        expectFatalError(expectedMessage: Programmer.Errors.missingServices) {
//            let programmer = Programmer()
//        }
//    }
//
//    func testPartialServicesRegisteredFails() throws {
//        let locator = LocatorImpl()
//        locator.register(Mac.self)
//        expectFatalError(expectedMessage: Programmer.Errors.missingServices) {
//            let programmer = Programmer()
//        }
//    }
//
//    func testServicesRegistered() throws {
//        let locator = LocatorImpl()
//        locator.register(Mac.self)
//        locator.register(Caf.self)
//        let programmer = Programmer(locator)
//        XCTAssertTrue(programmer.startTheDay())
//    }
//
//    func testPCRegisteredFailsToStart() throws {
//        let locator = LocatorImpl()
//        locator.register(PC.self)
//        locator.register(Caf.self)
//        let programmer = Programmer(locator)
//        XCTAssertFalse(programmer.startTheDay())
//    }

}

// https://stackoverflow.com/a/68496755/2431627
extension XCTestCase {
    func expectFatalError(expectedMessage: String, testcase: @escaping () -> Void) {

        // arrange
        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String? = nil

        // override fatalError. This will terminate thread when fatalError is called.
        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            // Terminate the current thread after expectation fulfill
            Thread.exit()
            // Since current thread was terminated this code never be executed
            fatalError("It will never be executed")
        }

        // act, perform on separate thread to be able terminate this thread after expectation fulfill
        Thread(block: testcase).start()

        waitForExpectations(timeout: 0.1) { _ in
            // assert
            XCTAssertEqual(assertionMessage, expectedMessage)

            // clean up
            FatalErrorUtil.restoreFatalError()
        }
    }
}
