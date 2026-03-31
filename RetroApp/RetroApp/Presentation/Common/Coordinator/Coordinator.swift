//
//  Coordinator.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }

    func start()
}
