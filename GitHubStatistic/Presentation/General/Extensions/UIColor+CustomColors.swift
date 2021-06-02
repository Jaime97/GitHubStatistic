//
//  UIColor+CustomColors.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 06/05/2021.
//

import Foundation
import UIKit

enum AssetsColor: String {
    case AccentColor
    case BackgroundColor
    case TopBackgroundColor
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
         return UIColor(named: name.rawValue)
    }
}
