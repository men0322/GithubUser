//
//  DSLabel.swift
//  DesignSystem
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import UIKit

/// A custom UILabel subclass with additional features such as padding insets and a minimum width.
open class DSLabel: UILabel {
    
    /// The padding to apply to the label's text content.
    /// - Default: `UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)`.
    /// - When set, it invalidates the intrinsic content size to ensure proper layout.
    public var paddingInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0) {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    /// The minimum width for the label.
    /// - Default: `0.0`.
    /// - When set, it invalidates the intrinsic content size to ensure proper layout.
    public var minWidth: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: paddingInset))
    }
    
    /// Overrides the intrinsic content size calculation to account for padding and minimum width.
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += paddingInset.top + paddingInset.bottom
        let width = intrinsicSuperViewContentSize.width + (paddingInset.left + paddingInset.right)
        intrinsicSuperViewContentSize.width = max(minWidth, width)
        return intrinsicSuperViewContentSize
    }
    
    override public var text: String? {
        get { super.text }
        set {
            super.text = newValue
        }
    }
}


/// An extension to UILabel for setting styles conveniently.
extension UILabel {
    /// Applies a custom text style to the label.
    ///
    /// - Parameter style: A `DSTextStyle` object containing font and color information.
    public func setStyle(_ style: DSTextStyle) {
        self.font = style.font
        self.textColor = style.color
    }
}
