//
//  FatalErrorUtil.swift
//  Bdum Tish
//
//  Created by Robin Macharg2 on 07/08/2021.
//
// https://stackoverflow.com/a/68496755/2431627
//

import Foundation


//// overrides Swift global `fatalError`
//func fatalError(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> Never {
//    FatalErrorUtil.fatalErrorClosure(message(), file, line)
//}
//
///// Utility functions that can replace and restore the `fatalError` global function.
//enum FatalErrorUtil {
//    typealias FatalErrorClosureType = (String, StaticString, UInt) -> Never
//    // Called by the custom implementation of `fatalError`.
//    static var fatalErrorClosure: FatalErrorClosureType = defaultFatalErrorClosure
//
//    // backup of the original Swift `fatalError`
//    private static let defaultFatalErrorClosure: FatalErrorClosureType = { Swift.fatalError($0, file: $1, line: $2) }
//
//    /// Replace the `fatalError` global function with something else.
//    static func replaceFatalError(closure: @escaping FatalErrorClosureType) {
//        fatalErrorClosure = closure
//    }
//
//    /// Restore the `fatalError` global function back to the original Swift implementation
//    static func restoreFatalError() {
//        fatalErrorClosure = defaultFatalErrorClosure
//    }
//}
