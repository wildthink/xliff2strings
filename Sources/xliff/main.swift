import Foundation
import XMLCoder
import ArgumentParser
import xliff2strings

//
//  EchoCommand.swift
//
//  Created by Jason Jobe on 1/20/22.
//
extension Command {
    struct XliffCmd: ParsableCommand {
        static var configuration: CommandConfiguration {
            .init(
                commandName: "xliff2strings",
                abstract: "echos command line arguments for testing"
            )
        }
        
        @Argument(help: "The input")
        var input: [String]
        
        @Option(name: .shortAndLong, help: "The file to output to. Defaults to <stdout>.")
        var output: String?
        
//        @Option(name: .shortAndLong, help: "An array of args")
//        var argv: [String]
//
//        @Flag(name: .shortAndLong, help: "Flag check")
//        var flag: Bool = false

        func run() throws {
            for item in input {
                print("input -> \(item)")
            }
            if let output = output {
                print ("output ->", output)
            }
            echoProcessInfo()
        }
        

        func echoProcessInfo() {
            let p = Process()
            if let cwd = p.currentDirectoryURL?.path {
                print("cwd", cwd)
            }
            if let ewd = p.executableURL?.path {
                print("ewd", ewd)
            }
            if let env = p.environment?.enumerated() {
                for (key, value) in env {
                    print (key, value)
                }
            }
        }
    }
}

//let cli = CLI(singleCommand: XliffToStrings())
//cli.helpCommand = nil // no options, no help needed
//cli.helpFlag = nil

//let cli = CLI(name: "xliff2strings",
//              version: "0.1",
//              description: "A command line tool to generate .strings and .stringdict files from .xliff file",
//              commands: [XliffToStrings()])

//exit(cli.go(with: ["-h"]))
//cli.goAndExit()

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
                    Command.XliffCmd.self,
//                    Command.PluralsCommand.self,
//                    Command.Echo.self,
//                    Command.Xcloc.self,
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
//            let strings = xliff.getStringFiles(outFolder: out)
            let strings = try xliff.stringFiles(matching: filter, out: out)

            for st in strings {
                try st.encodeAndSave()
            }
        }

    }
}

Command.Main.main()
