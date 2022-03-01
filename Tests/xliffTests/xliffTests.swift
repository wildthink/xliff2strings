//
//  File.swift
//  
//
//  Created by Jason Jobe on 2/21/22.
//

import Foundation
import XCTest
import class Foundation.Bundle
import xliff2strings

final class xliffTests: XCTestCase {
    
    let url = URL(fileURLWithPath: "/Users/jjobe051/Opensource/l10n/xliff2strings/Localizable.stringsdict")
    
    func testPlurals() throws {
//        print (productsDirectory.path)
        let  pl = try Plurals(contentsOf: url)
        print (pl)
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}

