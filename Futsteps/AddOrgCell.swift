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
    func didTapAddButton(_ addButton: UIButton, on cell: AddOrgCell)
}

class AddOrgCell: UITableViewCell {
    
    weak var delegate: AddOrgCellDelegate?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var orgNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 6
        addButton.clipsToBounds = true
        
        addButton.setTitle("Added", for: .normal)
        addButton.setTitle("Added", for: .selected)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        delegate?.didTapAddButton(sender as! UIButton, on: self)
    }


}
