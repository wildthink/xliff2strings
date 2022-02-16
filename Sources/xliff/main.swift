import Foundation
import XMLCoder
import ArgumentParser
import xliff2strings

enum Command {}

let BUILD_VERSION = "0.0.1"


extension Command {
    struct Main: ParsableCommand {
        static var configuration: CommandConfiguration {
            .init(
                commandName: "xliff2strings",
                abstract: "A program to create Localization string resources",
                version: BUILD_VERSION,
                subcommands: [
                ]
            )
        }
        
        @Flag(name: .shortAndLong, help: "List files from xliff")
        var list: Bool = false

        @Option(name: .shortAndLong, help: "Regex to select files")
        var filter: String = ".*"

        @Argument(help: "The input")
        var input: String
        
        @Option(name: .shortAndLong, help: "The file to output to. Defaults to <stdout>.")
        var output: String?

        func run() throws {
            let workingDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
            
            guard let data = FileManager.default.contents(atPath: input)
            else { throw FileError.notExists }
            
            let decoder = XMLDecoder()
            decoder.trimValueWhitespaces = false
            let xliff = try decoder.decode(Xliff.self, from: data)

            if list {
                try xliff.list(matching: filter).forEach {
                    print($0)
                }
                return
            }
            
            let out: URL
            
            if let output = output {
                out = createFileUrl(for: output,
                            isDirectory: true,
                             relativeTo: workingDir)
            } else {
                out = workingDir
            }
            let strings = try xliff.stringFiles(matching: filter, out: out)

            for st in strings {
                try st.encodeAndSave()
            }
        }

    }
}

Command.Main.main()
