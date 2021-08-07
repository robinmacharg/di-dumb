//
//  OtherTestHelperFunctionality.swift
//  di-dumbTests
//
//  Created by Robin Macharg2 on 07/08/2021.
//

import XCTest

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

// overrides Swift global `fatalError`
func fatalError(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

/// Utility functions that can replace and restore the `fatalError` global function.
enum FatalErrorUtil {
    typealias FatalErrorClosureType = (String, StaticString, UInt) -> Never
    // Called by the custom implementation of `fatalError`.
    static var fatalErrorClosure: FatalErrorClosureType = defaultFatalErrorClosure

    // backup of the original Swift `fatalError`
    private static let defaultFatalErrorClosure: FatalErrorClosureType = { Swift.fatalError($0, file: $1, line: $2) }

    /// Replace the `fatalError` global function with something else.
    static func replaceFatalError(closure: @escaping FatalErrorClosureType) {
        fatalErrorClosure = closure
    }

    /// Restore the `fatalError` global function back to the original Swift implementation
    static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}

