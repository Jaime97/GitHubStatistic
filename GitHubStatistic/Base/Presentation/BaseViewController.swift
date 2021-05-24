//
//  BaseViewController.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 22/04/2021.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
}
