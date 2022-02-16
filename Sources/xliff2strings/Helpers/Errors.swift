//
//  Errors.swift
//  xliff2strings
//
//  Created by ivankolesnik on 03/06/2019.
//

import Foundation

public struct FileError: Error, LocalizedError, CustomDebugStringConvertible {
    let msg: String
    let file: String
    
    public static func notExists(_ file: URL) -> FileError {
        .init(msg: "Does not exist", file: file.path)
    }
    
    public static func createFail(_ file: URL) -> FileError {
        .init(msg: "Cannot create", file: file.path)
    }
    
    public static func notExists(_ file: String) -> FileError {
        .init(msg: "Does not exist", file: file)
    }
    
    public static func createFail(_ file: String) -> FileError {
        .init(msg: "Cannot create", file: file)
    }

    public var errorDescription: String? {
        "\(msg) \(file)"
    }
    
    public var debugDescription: String {
        return errorDescription ?? "Unknown error happened"
    }
}
