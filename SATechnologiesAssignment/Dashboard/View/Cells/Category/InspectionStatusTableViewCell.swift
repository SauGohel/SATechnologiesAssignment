//
//  InspectionStatusTableViewCell.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit

class InspectionStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnCompleteContinue: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.cornerRadius = 5.0
        btnCompleteContinue.isEnabled = false
    }

    func setupCategoryCellData(title: String, isSubmitted: Bool?, score: Double?, isStarted: Bool) {
        lblCategory.text = title
        lblScore.isHidden = !(isSubmitted ?? false)
        btnCompleteContinue.isHidden = isSubmitted ?? false
        lblScore.text = "\(score ?? 0.0)"
        btnCompleteContinue.applyNavyBlue(title: isStarted ? "Continue" : "Complete" , cornerRadius: 5)
        backView.backgroundColor = isSubmitted ?? false ?
            .green.withAlphaComponent(0.2) :
        (isStarted ? .orange.withAlphaComponent(0.2) : .gray.withAlphaComponent(0.2))
    }
    
}
