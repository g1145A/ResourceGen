# ResourceGen

ResourceGen is a Swift command-line tool that converts design tokens exported from Figma into iOS-ready resources.

It is built for token files exported with the [Variables2CSS](https://www.figma.com/community/plugin/1261234393153346915/variables2css) plugin and generates:

- `CoreColors.xcassets` for Xcode color assets
- `UIConstants.swift` for numeric UI constants
- `UIFonts.swift` for typography definitions

## What It Generates

### Colors

The `colors` command reads token definitions from the exported file and creates a `CoreColors.xcassets` catalog.

Supported behavior:

- raw hex color tokens such as `--color-blue-10: #f3f8fe;`
- alias tokens such as `--background-primary: var(--color-grey-white);`
- light and dark theme variants when both modes are present
- nested asset folders based on token names

### Constants

The `constants` command generates a `UIConstants.swift` file with a `CGFloat` extension.

Each exported constant becomes a static property:

```swift
public extension CGFloat {
    /// value 12 px
    static let spacingM: CGFloat = 12
}
```

### Fonts

The `fonts` command generates a `UIFonts.swift` file containing:

- `FigmaFont` definitions for named typography styles
- `Family` and `Weight` enums
- `FigmaFontSize` definitions for dynamic type sizes

This is intended for projects that keep typography tokens in Figma and want strongly typed Swift output.

## Requirements

- macOS 10.15+
- Swift 6.0 toolchain

## Installation

Clone the repository and use Swift Package Manager directly:

```bash
git clone https://github.com/<your-org>/ResourceGen.git
cd ResourceGen
swift build
```

For day-to-day usage you can run the executable with `swift run ResourceGen`.

## Quick Start

Assume you exported a token file from Figma to `tokens.txt`.

Generate colors:

```bash
swift run ResourceGen colors --path ./tokens.txt --output ./Generated
```

Generate constants:

```bash
swift run ResourceGen constants --path ./tokens.txt --output ./Generated
```

Generate fonts:

```bash
swift run ResourceGen fonts --path ./tokens.txt --output ./Generated
```

Output files:

- `./Generated/CoreColors.xcassets`
- `./Generated/UIConstants.swift`
- `./Generated/UIFonts.swift`

## Input Format

ResourceGen expects a CSS-like token export containing sections such as `Mode 1`, `Light`, `Dark`, and `Mobile`.

Example input:

```css
[data-theme="Mode 1"] {
    /* color */
    --color-blue-10: #f3f8fe;
    --color-blue-100: #147bf1;

    /* number */
    --gap-16: 16px;
    --font-size-14: 14px;
    --font-line-height-20: 20px;
    --font-letter-spacing-0: 0px;
    --font-weight-medium: 500;

    /* string */
    --font-family-lora: Lora;
}

[data-theme="Light"] {
    /* color */
    --background-primary: var(--color-blue-10);
}

[data-theme="Dark"] {
    /* color */
    --background-primary: var(--color-blue-100);
}

[data-theme="Mobile"] {
    /* number */
    --spacing-m: var(--gap-16);
    --font-article-body-size: var(--font-size-14);
    --font-article-body-line-height: var(--font-line-height-20);
    --font-article-body-letter-spacing: var(--font-letter-spacing-0);
    --font-article-body-family: var(--font-family-lora);
    --font-article-body-weight: var(--font-weight-medium);
}

[data-theme="DynamicTypeSmall"] {
    /* number */
    --font-article-body-size: 14px;
    --font-article-body-line-height: 20px;
}

[data-theme="DynamicTypeMedium"] {
    /* number */
    --font-article-body-size: 16px;
    --font-article-body-line-height: 22px;
}

[data-theme="DynamicTypeXLarge"] {
    /* number */
    --font-article-body-size: 18px;
    --font-article-body-line-height: 24px;
}

[data-theme="DynamicTypeXXLarge"] {
    /* number */
    --font-article-body-size: 20px;
    --font-article-body-line-height: 28px;
}
```

## Commands

### `help`

Prints the built-in usage information.

```bash
swift run ResourceGen help
```

### `colors`

Generates an Xcode asset catalog from color tokens.

```bash
swift run ResourceGen colors --path ./tokens.txt --output ./Generated
```

Result:

- creates `CoreColors.xcassets`
- writes `Contents.json` files for each generated color set
- supports light and dark appearances when matching tokens exist

### `constants`

Generates Swift `CGFloat` constants from numeric mobile tokens.

```bash
swift run ResourceGen constants --path ./tokens.txt --output ./Generated
```

Result:

- creates `UIConstants.swift`
- writes a `public extension CGFloat` with camel-cased property names

### `fonts`

Generates Swift typography models from font tokens.

```bash
swift run ResourceGen fonts --path ./tokens.txt --output ./Generated
```

Result:

- creates `UIFonts.swift`
- writes named font styles
- writes font families and weights as enums
- writes dynamic type size presets for `DynamicTypeSmall`, `DynamicTypeMedium`, `DynamicTypeXLarge`, and `DynamicTypeXXLarge`

## Generated Output Example

Example constant output:

```swift
import Foundation

public extension CGFloat {
    /// value 16 px
    static let spacingM: CGFloat = 16
}
```

Example font output:

```swift
public struct FigmaFont: Equatable, Sendable {
    public let family: Family
    public let weight: Weight
    public let size: Double
    public let lineHeight: Double
    public let letterSpacing: Double

    public static var articleBody: FigmaFont {
        FigmaFont(
            family: .lora,
            weight: .medium,
            size: 14,
            lineHeight: 20,
            letterSpacing: 0
        )
    }
}
```

## Development

Run the test suite with:

```bash
swift test
```

## Notes

- The tool is designed around the structure of Variables2CSS exports.
- Output names are derived from token names and converted to camel case for Swift identifiers.
- Color asset names are expanded into nested folders based on token segments.
