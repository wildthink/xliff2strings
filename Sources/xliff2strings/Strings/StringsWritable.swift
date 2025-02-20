//
//  TranslationWritable.swift
//  xliff2strings
//
//  Created by ivankolesnik on 03/06/2019.
//

import Foundation

public protocol StringsWritable {
    init(fileOrigin: FileOrigin, saveFolder: URL)
    var fileOrigin: FileOrigin { get }
    func encodeAndSave() throws
}
