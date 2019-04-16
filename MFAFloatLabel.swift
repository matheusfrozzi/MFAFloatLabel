//
//  MFAFloatLabel.swift
//  TagLivros
//
//  Created by Matheus Frozzi Alberton on 24/12/16.
//  Copyright © 2016 flockr. All rights reserved.
//

import UIKit

@objc public protocol MFAFloatLabelDelegate {
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
    @objc optional func textDidChange(text: String)
}

class MFAFloatLabel: UITextField, UITextFieldDelegate {

    @IBInspectable var placeholderColor: UIColor = .gray
    @IBInspectable var topSpacingFromPlaceholder: CGFloat = 6
    @IBInspectable var leftSpacing: CGFloat = 8
    @IBInspectable var rightSpacing: CGFloat = 8

    @IBInspectable var fontNameCustom: String!
    @IBInspectable var fontSizeCustom: CGFloat = 12

    @IBInspectable var changeFontSizeOnWrite: Bool = false
    @IBInspectable var addBorder: Bool = false

    @IBInspectable var icon: UIImage?
    @IBInspectable var iconIsRight: Bool = true
    @IBInspectable var iconSpacing: CGFloat = 8
    @IBInspectable var iconWidth: CGFloat = 12
    @IBInspectable var iconHeight: CGFloat = 12


    override var text: String? {
        set {
            super.text = newValue
            textDidChange()
            if text != "" {
                _ = self.textFieldShouldBeginEditing(self)
            }
        }
        
        get {
            if case .noFormatting = formatting {
                return super.text
            } else {
                // Because the UIControl target action is called before NSNotificaion (from which we fire our custom formatting), we need to
                // force update finalStringWithoutFormatting to get the latest text. Otherwise, the last character would be missing.
                textDidChange()
                return finalStringWithoutFormatting
            }
        }
    }
    var placeholderNew: String? {
        didSet {
            placeholderLabel.text = placeholderNew
            placeholder = nil
        }
    }
    var bottomBorder: UIView = UIView()
    var placeholderLabel = UILabel()
    var imageViewIcon = UIImageView()

    var yConstraint: NSLayoutConstraint?

    @IBOutlet open weak var customDelegate: MFAFloatLabelDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        delegate = self
        registerForNotifications()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        delegate = self
        registerForNotifications()
    }

    override func awakeFromNib() {

        self.commonInit()
    }

    override func draw(_ rect: CGRect) {
    }

    private func commonInit() {
        if addBorder {
            bottomBorder = self.addBorder(withColor: UIColor(hexa: "#A7D0FF"), andEdge: .bottom)
        }

        if self.placeholder != nil {
            placeholderNew = self.placeholder
        }
        
        setupIcon()

        yConstraint = NSLayoutConstraint(item: placeholderLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

        let titleConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: placeholderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: leftSpacing),
            NSLayoutConstraint(item: placeholderLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: leftSpacing),
            yConstraint!
        ]

        placeholderLabel.numberOfLines = 0
        placeholderLabel.textAlignment = .left
        placeholderLabel.text = placeholderNew
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.sizeToFit()

        addConstraints(titleConstraints)

        if let fontNameCustom = fontNameCustom {
            if changeFontSizeOnWrite {
                if let myFont = self.font, let fontCustom = UIFont(name: fontNameCustom, size: myFont.pointSize) {
                    placeholderLabel.font = fontCustom
                } else {
                    placeholderLabel.font = self.font
                }
            } else {
                if let fontCustom = UIFont(name: fontNameCustom, size: fontSizeCustom) {
                    placeholderLabel.font = fontCustom
                }
            }
        } else {
            placeholderLabel.font = self.font
        }

        placeholderLabel.textColor = placeholderColor

        if self.text != "" {
            _ = self.textFieldShouldBeginEditing(self)
        }

        self.placeholder = ""
        self.addSubview(placeholderLabel)
        self.sendSubviewToBack(placeholderLabel)
    }

    func setupIcon() {
        guard let icon = icon else { return }
        let alignConstraint: NSLayoutConstraint

        if iconIsRight {
            alignConstraint = NSLayoutConstraint(item: imageViewIcon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -iconSpacing)
        } else {
            alignConstraint = NSLayoutConstraint(item: imageViewIcon, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: iconSpacing)
        }

        let titleConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: imageViewIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageViewIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconWidth),
            NSLayoutConstraint(item: imageViewIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconHeight),
            alignConstraint
        ]

        imageViewIcon.contentMode = .scaleAspectFit
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.sizeToFit()

        imageViewIcon.image = icon
        addConstraints(titleConstraints)

        self.addSubview(imageViewIcon)
        self.sendSubviewToBack(imageViewIcon)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            if self.changeFontSizeOnWrite {
                if let myFont = self.font, let fontCustom = UIFont(name: myFont.familyName, size: self.fontSizeCustom) {
                    self.placeholderLabel.font = fontCustom
                }
            }

            self.yConstraint?.constant = -self.topSpacingFromPlaceholder
            self.layoutIfNeeded()
        })
        
        return customDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.text!.count <= 0 {
            self.layoutIfNeeded()

            UIView.animate(withDuration: 0.2, animations: { () -> Void in

                if self.changeFontSizeOnWrite {
                    if let myFont = self.font, let fontCustom = UIFont(name: myFont.familyName, size: myFont.pointSize) {
                        self.placeholderLabel.font = fontCustom
                    } else {
                        self.placeholderLabel.font = self.font
                    }
                }

                self.yConstraint?.constant = 0
                self.layoutIfNeeded()
            })
        }

        customDelegate?.textFieldDidEndEditing?(textField)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {

        return CGRect(x: bounds.origin.x + leftSpacing, y: bounds.origin.y + topSpacingFromPlaceholder, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: bounds.origin.x + leftSpacing, y: bounds.origin.y + topSpacingFromPlaceholder, width: bounds.width, height: bounds.height)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = customDelegate?.textFieldShouldReturn?(textField)
        return true
    }
    
    // MASK
    public enum TextFieldFormatting {
        case uuid
        case socialSecurityNumber
        case phoneNumber
        case cpf
        case birth
        case custom
        case noFormatting
    }

    /**
     Set a formatting pattern for a number and define a replacement string. For example: If formattingPattern would be "##-##-AB-##" and
     replacement string would be "#" and user input would be "123456", final string would look like "12-34-AB-56"
     */
    public func setFormatting(_ formattingPattern: String, replacementChar: Character) {
        self.formattingPattern = formattingPattern
        self.replacementChar = replacementChar
        self.formatting = .custom
    }
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    public var replacementChar: Character = "*"
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    public var secureTextReplacementChar: Character = "\u{25cf}"
    
    /**
     True if input number is hexadecimal eg. UUID
     */
    public var isHexadecimal: Bool {
        return formatting == .uuid
    }
    
    /**
     Max length of input string. You don't have to set this if you set formattingPattern.
     If 0 -> no limit.
     */
    public var maxLength = 0
    
    /**
     Type of predefined text formatting. (You don't have to set this. It's more a future feature)
     */
    public var formatting : TextFieldFormatting = .noFormatting {
        didSet {
            switch formatting {
                
            case .socialSecurityNumber:
                self.formattingPattern = "***-**-****"
                self.replacementChar = "*"
                
            case .phoneNumber:
                self.formattingPattern = "***-***-****"
                self.replacementChar = "*"
                
            case .uuid:
                self.formattingPattern = "********-****-****-****-************"
                self.replacementChar = "*"
                
            case .cpf:
                self.formattingPattern = "***.***.***-**"
                self.replacementChar = "*"
                
            case .birth:
                self.formattingPattern = "**/**/****"
                self.replacementChar = "*"
                
            default:
                self.maxLength = 0
            }
        }
    }
    
    /**
     String with formatting pattern for the text field.
     */
    public var formattingPattern: String = "" {
        didSet {
            self.maxLength = formattingPattern.count
        }
    }
    
    /**
     Provides secure text entry but KEEPS formatting. All digits are replaced with the bullet character \u{25cf} .
     */
    public var formatedSecureTextEntry: Bool {
        set {
            _formatedSecureTextEntry = newValue
            super.isSecureTextEntry = false
        }
        
        get {
            return _formatedSecureTextEntry
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Final text without formatting characters (read-only)
     */
    public var finalStringWithoutFormatting : String {
        return _textWithoutSecureBullets.keepOnlyDigits(isHexadecimal: isHexadecimal)
    }
    
    // MARK: - INTERNAL
    fileprivate var _formatedSecureTextEntry = false
    
    // if secureTextEntry is false, this value is similar to self.text
    // if secureTextEntry is true, you can find final formatted text without bullets here
    fileprivate var _textWithoutSecureBullets = ""

    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: self)
    }

    @objc public func textDidChange() {
        var superText: String { return super.text ?? "" }
        customDelegate?.textDidChange?(text: superText)

        // TODO: - Isn't there more elegant way how to do this?
        let currentTextForFormatting: String
        
        if superText.count > _textWithoutSecureBullets.count {
            currentTextForFormatting = _textWithoutSecureBullets + superText[superText.index(superText.startIndex, offsetBy: _textWithoutSecureBullets.count)...]
        } else if superText.count == 0 {
            _textWithoutSecureBullets = ""
            currentTextForFormatting = ""
        } else {
            currentTextForFormatting = String(_textWithoutSecureBullets[..<_textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: superText.count)])
        }
        
        if formatting != .noFormatting && currentTextForFormatting.count > 0 && formattingPattern.count > 0 {
            let tempString = currentTextForFormatting.keepOnlyDigits(isHexadecimal: isHexadecimal)
            
            var finalText = ""
            var finalSecureText = ""
            
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
                if formattingPattern[formattingPatternRange] != String(replacementChar) {
                    
                    finalText = finalText + formattingPattern[formattingPatternRange]
                    finalSecureText = finalSecureText + formattingPattern[formattingPatternRange]
                    
                } else if tempString.count > 0 {
                    
                    let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)
                    
                    finalText = finalText + tempString[pureStringRange]
                    
                    // we want the last number to be visible
                    if tempString.index(tempIndex, offsetBy: 1) == tempString.endIndex {
                        finalSecureText = finalSecureText + tempString[pureStringRange]
                    } else {
                        finalSecureText = finalSecureText + String(secureTextReplacementChar)
                    }
                    
                    tempIndex = tempString.index(after: tempIndex)
                }
                
                formatterIndex = formattingPattern.index(after: formatterIndex)
                
                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }
            
            _textWithoutSecureBullets = finalText
            
            let newText = _formatedSecureTextEntry ? finalSecureText : finalText
            if newText != superText {
                super.text = _formatedSecureTextEntry ? finalSecureText : finalText
            }
        }
        
        // Let's check if we have additional max length restrictions
        if maxLength > 0 {
            if superText.count > maxLength {
                super.text = String(superText[..<superText.index(superText.startIndex, offsetBy: maxLength)])
                _textWithoutSecureBullets = String(_textWithoutSecureBullets[..<_textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: maxLength)])
            }
        }
    }
}

@objc public protocol MFATextViewFloatLabelDelegate {
    @objc func textViewDidChange(_ textView: UITextView)
    @objc func textViewShouldBeginEditing(_ textView: UITextView)
}

class MFATextViewFloatLabel: UITextView, UITextViewDelegate {
    
    @IBInspectable var placeholderText: String = "" {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = .gray
    @IBInspectable var topSpacing: CGFloat = 6
    @IBInspectable var topSpacingFromPlaceholder: CGFloat = 6
    @IBInspectable var leftSpacing: CGFloat = 8
    @IBInspectable var rightSpacing: CGFloat = 8
    
    @IBInspectable var fontNameCustom: String!
    @IBInspectable var fontSizeCustom: CGFloat = 12
    
    @IBInspectable var changeFontSizeOnWrite: Bool = true
    @IBInspectable var hidePlaceholder: Bool = true

    @IBOutlet open weak var customDelegate: MFATextViewFloatLabelDelegate?

    override public var text : String? {
        didSet {
            if (text == "" || text == nil) {
                placeholderLabel.alpha = 1
            } else if (text != "" || text != nil) && hidePlaceholder {
                placeholderLabel.alpha = 0
            }
        }
    }

    var placeholderLabel = UILabel()
    var bottomBorder: UIView = UIView()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        delegate = self
    }

    override func awakeFromNib() {

        self.commonInit()
    }

    override func draw(_ rect: CGRect) {
    }

    private func commonInit() {

        let titleConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: placeholderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: leftSpacing),
            NSLayoutConstraint(item: placeholderLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: leftSpacing),
            NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: topSpacing),
            NSLayoutConstraint(item: placeholderLabel, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: placeholderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0)
        ]

        placeholderLabel.numberOfLines = 0
        placeholderLabel.textAlignment = .left
        placeholderLabel.text = self.placeholderText
        placeholderLabel.font = self.font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        sendSubviewToBack(placeholderLabel)
        addConstraints(titleConstraints)

        self.textContainer.lineFragmentPadding = 0
//        self.textContainerInset = UIEdgeInsets.zero
        self.textContainerInset = UIEdgeInsets(top: topSpacingFromPlaceholder, left: leftSpacing, bottom: 0, right: rightSpacing)
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        customDelegate?.textViewShouldBeginEditing(textView)
        return true
    }

    func textViewDidChange(_ textView: UITextView) {

        if textView.text!.count <= 0 {
            placeholderLabel.alpha = 1
        } else if hidePlaceholder {
            placeholderLabel.alpha = 0
        }

        customDelegate?.textViewDidChange(textView)
    }
}


extension String {
    
    func keepOnlyDigits(isHexadecimal: Bool) -> String {
        let ucString = self.uppercased()
        let validCharacters = isHexadecimal ? "0123456789ABCDEF" : "0123456789"
        let characterSet: CharacterSet = CharacterSet(charactersIn: validCharacters)
        let stringArray = ucString.components(separatedBy: characterSet.inverted)
        let allNumbers = stringArray.joined(separator: "")
        return allNumbers
    }
}


// Helpers
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
