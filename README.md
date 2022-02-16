# xliff2strings

A command line tool to generate .strings and .stringdict files from .xliff file

### Prerequisites

You exported localizations from XCode, used 3rd party service (or dedicated person) to update your translations and XCode refuses to import your xliff correctly?
I know that pain, bro! That's why I created this tool so that you can just replace your files with new ones!

It uses Swift Package Manager and should be able to target 10.10 and later.

### Installing

1. Download this project.
2. Run `swift build`
3. Grab binary from `.build/x86_64-apple-macosx10.10/debug/xliff2strings`
4. Run

## Notes and Warnings

`stringsdict` generator uses some magic and hardcoded values since `xliff` does not contain all needed information. This includes following keys:

Key | Value
---- | -----
NSStringFormatSpecTypeKey | NSStringPluralRuleType
NSStringFormatValueTypeKey | d

## Xcloc

#### Directory Layout

```
fr.xcloc
├── Localized Contents
│   └── fr.xliff
├── Notes
├── Source Contents
│   └── en.lproj
│       ├── LocalCheck-InfoPlist.strings
│       └── Localizable.strings
└── contents.json
```

##### content.json

```json
{
  "developmentRegion" : "en",
  "project" : "LocalCheck.xcodeproj",
  "targetLocale" : "fr",
  "toolInfo" : {
    "toolBuildNumber" : "13C90",
    "toolID" : "com.apple.dt.xcode",
    "toolName" : "Xcode",
    "toolVersion" : "13.2"
  },
  "version" : "1.0"
}
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [Ivan Kolesnik](https://github.com/ivankolesnik/xliff2strings) - The author of the original project
* [Swift ArgumentParser](https://github.com/apple/swift-argument-parser) - Apple library for Swift CLI apps
* [XMLCoder](https://github.com/MaxDesiatov/XMLCoder) - wonderful library that did all heavy XML parsing for me
