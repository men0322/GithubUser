//
//  DSTextStyle.swift
//  DesignSystem
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import UIKit

/// A protocol defining the basic text style properties for the design system.
public protocol DesignSystemTextStyle {
    /// The font size of the text.
    var fontSize: CGFloat { get }
    /// The font weight of the text.
    var weight: FontWeight { get }
}

/// A protocol extending `DesignSystemTextStyle` to include color properties.
public protocol DSTextStyle: DesignSystemTextStyle {
    /// The color of the text.
    var color: UIColor { get }
}

/// An extension of `DesignSystemTextStyle` to provide a default implementation for the `font` property.
extension DesignSystemTextStyle {
    /// Returns a `UIFont` based on the font size and weight.
    /// - If the custom font is not found, it defaults to the system font with the specified weight and size.
    public var font: UIFont {
        UIFont(
            name: weight.fontName,
            size: fontSize
        )
        ?? UIFont.systemFont(
            ofSize: fontSize,
            weight: .regular
        )
    }
}

/// A namespace for the design system's text styles.
public enum DS {
    
    /// A style for large display text, typically used for prominent headers.
    public struct DisplayLarge: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 20
        public let weight: FontWeight = .bold
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.black`.
        public init(color: UIColor = DSColor.black) {
            self.color = color
        }
    }
    
    /// A style for medium display text, used for less prominent headers.
    public struct DisplayMedium: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 20
        public let weight: FontWeight = .regular
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray600`.
        public init(color: UIColor = DSColor.gray600) {
            self.color = color
        }
    }
    
    /// A style for large titles, typically used for primary section headings.
    public struct TitleLarge: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 16
        public let weight: FontWeight = .bold
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray600`.
        public init(color: UIColor = DSColor.gray600) {
            self.color = color
        }
    }
    
    /// A style for medium titles, used for secondary section headings.
    public struct TitleMedium: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 16
        public let weight: FontWeight = .regular
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray600`.
        public init(color: UIColor = DSColor.gray600) {
            self.color = color
        }
    }
    
    /// A style for large body text, used for important content.
    public struct BodyLarge: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 14
        public let weight: FontWeight = .bold
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray400`.
        public init(color: UIColor = DSColor.gray400) {
            self.color = color
        }
    }
    
    /// A style for medium body text, used for general content.
    public struct BodyMedium: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 14
        public let weight: FontWeight = .regular
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray400`.
        public init(color: UIColor = DSColor.gray400) {
            self.color = color
        }
    }
    
    /// A style for large captions, used for important annotations.
    public struct CaptionLarge: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 12
        public let weight: FontWeight = .bold
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray300`.
        public init(color: UIColor = DSColor.gray300) {
            self.color = color
        }
    }
    
    /// A style for medium captions, used for less prominent annotations.
    public struct CaptionMedium: DSTextStyle {
        public let color: UIColor
        public let fontSize: CGFloat = 12
        public let weight: FontWeight = .regular
        
        /// Initializes the text style with a custom color.
        /// - Parameter color: The text color. Defaults to `DSColor.gray300`.
        public init(color: UIColor = DSColor.gray300) {
            self.color = color
        }
    }
}
