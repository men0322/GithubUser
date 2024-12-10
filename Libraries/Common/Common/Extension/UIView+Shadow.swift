//
//  UIView+Shabow.swift
//  Common
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit

public extension UIView {
    func setShadowStyle(_ shadowStyle: DSShadowStyle, path: UIBezierPath? = nil) {
        let style = shadowStyle.style
        layer.shadowColor = style.color
        if let path = path {
            layer.shadowPath = path.cgPath
        }
        layer.shadowOffset = style.offset
        layer.shadowOpacity = style.opacity
        layer.shadowRadius = style.radius / UIScreen.main.scale
    }
}

public enum DSShadowStyle {
    case shadow4
    case none
}

public extension DSShadowStyle {

    var style: ShadowStyle {
        switch self {
        case .shadow4: return Shadow.Shadow4()
        case .none: return Shadow.None()
        }
    }
}

public protocol ShadowStyle {
    var color: CGColor { get }
    var offset: CGSize { get }
    var opacity: Float { get }
    var radius: CGFloat { get }
}

public enum Shadow {
     struct Shadow4: ShadowStyle {
        let color: CGColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        let offset: CGSize = CGSize(width: 0.0, height: 2.0)
        let opacity: Float = 1.0
        let radius: CGFloat = 4.0
    }

    struct None: ShadowStyle {
        let color: CGColor = UIColor.white.cgColor
        let offset: CGSize = CGSize(width: 0.0, height: 0.0)
        let opacity: Float = 0.0
        let radius: CGFloat = 0.0
    }
}
