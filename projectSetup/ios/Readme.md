
# Xcode plugins

- SwiftLintXcode
- Xvim2

# Build phase scripts

## SwiftLint

```
"${PODS_ROOT}/SwiftLint/swiftlint"
```

## R.swift

```
"$PODS_ROOT/R.swift/rswift" generate "$SRCROOT/ProjectName/Assets/Rswift"
```

# Project structure

- ProjectName/
  - Assets/
    - Images/
      - AppResources.xcassets
    - Localization/
      - en.lproj/
        - Localizable.strings
    - Rswift/
      - R.generated.swift
  - Classes/
    - App/
      - AppDelegate.swift
    - Controllers/
    - Extensions/
    - Protocols/
    - Styles/
    - Utilities/
    - ViewControllers/
    - Views/
  - SupportingFiles/
    - Info.plist
    - Settings.bundle/
