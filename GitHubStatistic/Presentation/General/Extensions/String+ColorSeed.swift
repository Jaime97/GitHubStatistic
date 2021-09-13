//
//  String+ColorSeed.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 08/06/2021.
//

import Foundation
import UIKit

extension String {
    
    func generateColorFromThisSeed() -> UIColor {
        
        var total: Int = 0
        for u in self.unicodeScalars {
            total += Int(UInt32(u))
        }
        
        srand48(total * 200)
        let r = CGFloat(drand48())
        
        srand48(total)
        let g = CGFloat(drand48())
        
        srand48(total / 200)
        let b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
}
