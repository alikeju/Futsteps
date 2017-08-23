//
//  Storyboard+Utility.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/26/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard{
    enum FSType: String{
        case main
        case login
        case OrgMain
        
        var filename: String{
            return rawValue.capitalized
        }
    }
    
    convenience init(type: FSType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: FSType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }

}
