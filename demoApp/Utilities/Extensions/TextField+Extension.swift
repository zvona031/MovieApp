//
//  TextField+Extension.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 28.05.2022..
//

import UIKit
import Combine

extension UITextField {
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
