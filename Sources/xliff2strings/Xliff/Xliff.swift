//
//  XLIFF.swift
//  xliff2strings
//
//  Created by ivankolesnik on 29/05/2019.
//

import Foundation

// jmj
extension FileOrigin {
    func stringsWritable(to out: URL) -> StringsWritable {
        self.isStringsDict
            ? StringsDictFile(fileOrigin: self, saveFolder: out)
            : StringsFile(fileOrigin: self, saveFolder: out)
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

struct Xliff: Decodable {
    enum CodingKeys: String, CodingKey {
        case files = "file"
    }
    
    let files: [FileOrigin]
    
    func list(matching: String) throws -> [String] {
        let regex = try! NSRegularExpression(pattern: matching)
        return files.filter({regex.matches($0.filePath)}).map(\.filePath)
    }

    func stringFiles(matching: String, out: URL) throws -> [StringsWritable] {
        let regex = try! NSRegularExpression(pattern: matching)
        return files.filter({regex.matches($0.filePath)})
            .map{ $0.stringsWritable(to: out) }
    }

    func getStringFiles(outFolder out: URL) -> [StringsWritable] {
        return files.map({ file -> StringsWritable in
            // check if file is .strings or .stringsdict
            return file.isStringsDict
                ? StringsDictFile(fileOrigin: file, saveFolder: out)
                : StringsFile(fileOrigin: file, saveFolder: out)
        })
    }
}
