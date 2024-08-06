//
//  OptionsTableViewCell.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgSelection: UIImageView!
    @IBOutlet weak var lblOption: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 5.0
        // Initialization code
    }
    func setupOptionData(options: AnswerChoice, isSelected: Bool) {
        backView.backgroundColor = isSelected ? .green.withAlphaComponent(0.2): .gray.withAlphaComponent(0.2)
        
        imgSelection.image = isSelected ?
        UIImage.init(systemName: "record.circle")?.withTintColor(.AppNavyBluePrimaryColor) :
        UIImage.init(systemName: "poweroff")?.withTintColor(.AppNavyBluePrimaryColor)
        
        lblOption.text = options.name
        
    }
    
}
