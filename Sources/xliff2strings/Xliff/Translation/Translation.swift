//
//  Translation.swift
//  xliff2strings
//
//  Created by ivankolesnik on 31/05/2019.
//

import Foundation

public struct Translation: Decodable {
    public let id: String
    public let source: String
    public let target: String?
    public let note: String?
    
     var safeTarget: String {
        // WORKAROUND: for en target can be empty, use source
        return (target ?? source).escaped
    }
    
    var safeNote: String {
        // WORKAROUND: if note does not exist, use source as comment
        return (note ?? source).escaped
    }
}
