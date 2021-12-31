//
//  GHBodyLabel.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import UIKit

class GHBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .body)
        textAlignment = .center
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
