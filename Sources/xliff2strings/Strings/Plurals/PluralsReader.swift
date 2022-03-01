//
//  File.swift
//  
//
//  Created by Jason Jobe on 2/21/22.
//

import Foundation

enum ReadError: Error {
    case bad(Any)
    case empty
}

public extension Plurals {

    init(contentsOf url: URL) throws {
        try self.init(from: NSDictionary(contentsOf: url))
    }
    
    init(from dictionary: NSDictionary?) throws {
        guard let dictionary = dictionary else {
            throw ReadError.empty
        }
        var bag = [String: Plural]()
        
        for (key, value) in dictionary {
            guard let key = key as? String,
                  let dict = value as? NSDictionary
            else { throw ReadError.bad(key) }
            let pl = try Plural(key: key, from: dict)
            bag[key] = pl
        }
        contents = bag
//        contents = dictionary.map { key, value in
//            try (key, Plural(value as? NSDictionary)) }
    }
}


public extension Plural {
    init?(key: String, from dictionary: NSDictionary) throws {
//        guard let dictionary = dictionary else {
//            throw ReadError.empty
//        }
        var pls = [PluralElement]()
        
        for (key, value) in dictionary {
            print(key, value)
            if let dict = value as? NSDictionary {
                try pls.append(PluralElement(with: dict))
            }
        }
        
        self.init(key: key, plurals: pls)
//        self.key = ""
//        self.format = ""
//        self.values = [:]
//        self.valuesKey = .make(dictionaryKey)
    }
}

/*
 let key: String
 let path: [String]
 let translation: Translation
 */
//

public extension PluralElement {
    init(with dictionary: NSDictionary?) throws {
        self.key = ""
        self.path = [""]
        self.translation = .init(id: "", source: "", target: "", note: "")
    }
}

/*
 "GUESTS_SINGLE_PLURAL" => {
   "guests" => {
     "NSStringFormatSpecTypeKey" => "NSStringPluralRuleType"
     "NSStringFormatValueTypeKey" => "d"
     "one" => "%ld Guest"
     "other" => "%ld Guests"
   }
   "NSStringLocalizedFormatKey" => "%#@guests@"
 }
 */

//public extension Translation {
//    init(from dictionary: NSDictionary?) throws {
//    }
//}

