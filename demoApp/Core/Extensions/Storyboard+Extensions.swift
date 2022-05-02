//
//  Storyboard+Extensions.swift
//  demoApp
//
//  Created by Zvonimir Pavlović on 30.04.2022..
//

import UIKit

protocol ControllerIdentifierProtocol: AnyObject {
    static var controllerID: String { get }
}

extension ControllerIdentifierProtocol where Self: UIViewController {
    static var controllerID: String {
        return String(describing: self)
    }
}

extension UIViewController: ControllerIdentifierProtocol {}

public extension UIStoryboard {
    func getController<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.controllerID) as! T
    }
}
