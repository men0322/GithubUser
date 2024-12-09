//
//  Fonts.swift
//  DesignSystem
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation

/// Enum representing different font weights and styles for the design system.
/// Each case corresponds to a specific font weight or oblique style.
public enum FontWeight {
    /// Regular weight font.
    case regular
    /// Bold weight font.
    case bold
    /// Bold weight font with oblique styling.
    case boldOblique
    /// Light weight font.
    case light
    /// Light weight font with oblique styling.
    case lightOblique
    /// Regular weight font with oblique styling.
    case oblique
    
    /// The name of the font as used by the system.
    /// Maps each font weight or style to its corresponding font name.
    public var fontName: String {
        switch self {
        case .regular:
            return "Helvetica"
        case .bold:
            return "Helvetica-Bold"
        case .boldOblique:
            return "Helvetica-BoldOblique"
        case .light:
            return "Helvetica-Light"
        case .lightOblique:
            return "Helvetica-LightOblique"
        case .oblique:
            return "Helvetica-Oblique"
        }
    }
}
