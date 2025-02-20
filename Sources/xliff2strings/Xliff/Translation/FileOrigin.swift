//
//  File.swift
//  xliff2strings
//
//  Created by ivankolesnik on 31/05/2019.
//

import Foundation

// <trans-unit> tag inside xliff file
private struct Body: Decodable {
    enum CodingKeys: String, CodingKey {
        case translations = "trans-unit"
    }
    
    let translations: [Translation]
}

public struct FileOrigin: Decodable {
    enum CodingKeys: String, CodingKey {
        case filePath = "original"
        case datatype
        case sourceLanguage = "source-language"
        case targetLanguage = "target-language"
        case translations = "body"
    }
    
    public let filePath: String
    public let datatype: String
    public let sourceLanguage: String
    public let targetLanguage: String?
    public let translations: [Translation]
    
    public var safeTargetLanguage: String {
        return sourceLanguage
    }
    
    public var isStringsDict: Bool {
        return filePath.hasSuffix(".stringsdict")
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        datatype = try container.decode(String.self, forKey: .datatype)
        sourceLanguage = try container.decode(String.self, forKey: .sourceLanguage)
        targetLanguage = try container.decodeIfPresent(String.self, forKey: .targetLanguage)
        
        var path = try container.decode(String.self, forKey: .filePath)
        if let target = targetLanguage {
            // WORKAROUND: sometimes path for target folder of non-en language is en.lproj
            // like this: <file original="en.lproj/InfoPlist.strings" source-language="en" datatype="plaintext" target-language="ru">
            // just try to replace this part using sourceLanguage and targetLanguage
            path = path.replacingOccurrences(of: "\(sourceLanguage).lproj", with: "\(target).lproj")
        }
        filePath = path
        
        let body = try container.decode(Body.self, forKey: .translations)
        translations = body.translations
    }
}
