//
//  BetterSegmentedControl+Rx.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 10/05/2021.
//

import Foundation
import RxSwift
import RxCocoa
import BetterSegmentedControl

extension Reactive where Base: BetterSegmentedControl {
    
    public var index: ControlProperty<Int> {
        return base.rx.controlProperty(editingEvents: .allEvents) { segmentedControl in
            segmentedControl.index
        } setter: { segmentedControl, value in
            segmentedControl.setIndex(value)
        }

    }
    
}
