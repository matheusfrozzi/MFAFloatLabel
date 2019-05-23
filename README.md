# MFAFloatLabel

[![Version](https://img.shields.io/cocoapods/v/MFAFloatLabel.svg?style=flat)](https://cocoapods.org/pods/MFAFloatLabel)
[![License](https://img.shields.io/cocoapods/l/MFAFloatLabel.svg?style=flat)](https://cocoapods.org/pods/MFAFloatLabel)
[![Platform](https://img.shields.io/cocoapods/p/MFAFloatLabel.svg?style=flat)](https://cocoapods.org/pods/MFAFloatLabel)

## Installation

MFAFloatLabel is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MFAFloatLabel'
```

## Usage

The UI component can be used via the `MFAFloatLabel` or `MFATextViewFloatLabel` classes. This control can be used very similar to `UITextField` or `UITextView` - both from Interface Builder, or from code.

![](/Example/MFAFloatLabel/example.gif)

### Delegate
To use with `UITextFieldDelegate` methods you should implement `MFAFloatLabelDelegate` and set it on your `MFAFloatLabel`.
```swift
textField.floatLabelDelegate = self
```

### Font
You can change placeholder font name to be different from the text of your textField. Also change the font size of placeholder when typing.
```swift
textField.placeholderCustomFontName = "Menlo"
textField.placeholderEditingFontSize = 10
```

### Bottom border
```swift
textField.addBorder = true
textField.borderHeight = 1
textField.borderColor = .gray
```

### Placeholder
```swift
textField.placeholderColor = .gray
textField.topSpacingFromPlaceholder = 6 // set the spacing bettwing text and placeholder when typing
```

### Padding
```swift
textField.leftSpacing = 8 // left padding bettwing text/placeholder and left margin
textField.rightSpacing = 8 // right padding bettwing text/placeholder and right margin
```

### Icon
```swift
textField.icon = #imageLiteral(resourceName: "icon")
textField.iconAtTrailing = true // set it false if you want icon on right
textField.iconSpacing = 8 // spacing bettwing icon and margin
textField.iconWidth = 12
textField.iconHeight = 12
```

### Others
```swift
textField.onlyNumbers = false // set it true if your textField will accept only numbers
```

### Formatting
We also provide custom format. Just set the mask and the character to be replaced
```swift
textField.setFormatting("(__) _____.____", replacementChar: "_")
```
And you can set it as secure text
```swift 
textField.formatedSecureTextEntry = false
```

## Author

matheusfrozzi, matheusfrozzi@gmail.com

## License

MFAFloatLabel is available under the MIT license. See the LICENSE file for more info.
