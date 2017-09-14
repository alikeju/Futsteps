//
//  AddOrgCell.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/3/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation

import UIKit

protocol AddOrgCellDelegate: class {
    func showAlert(title:String, message:String);
}

class AddOrgCell: UITableViewCell {
    var delegate: AddOrgCellDelegate?

    //delegate.showAlert()
}

//class SomeCell: UITableViewCell {
//    var delegate: AudioPlayable?
//    @IBAction func userDidSomething(sender: AnyObject) {
//        delegate?.playSoundsIfAble()
//}
