//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/24.
//

import UIKit

import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class ValidationViewController: UIViewController {

    @IBOutlet weak var userNameOutlet: UITextField!
    @IBOutlet weak var userNameVaildOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameVaildOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        setBinding()
    }
    
    private func setBinding() {
        
        let nameValid = userNameOutlet.rx.text.orEmpty
            .map { $0.description }
            .share(replay: 1)
        
        
    }


}
