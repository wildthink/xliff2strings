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
                commandName: "xliff",
                abstract: "Create Localization string resources from .xliff",
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
        var input: [String]
        
        @Option(name: .shortAndLong, help: "The file to output to. Defaults to cwd.")
        var output: String?

        func run() throws {
            let workingDir = URL(
                fileURLWithPath: FileManager.default.currentDirectoryPath,
                isDirectory: true)
            
            for file in input {
                try process(file, in: workingDir)
            }
        }
        
        func process(_ file: String, in workingDir: URL) throws {
            
            guard let data = FileManager.default.contents(atPath: file)
            else { throw FileError.notExists(file) }
            
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
