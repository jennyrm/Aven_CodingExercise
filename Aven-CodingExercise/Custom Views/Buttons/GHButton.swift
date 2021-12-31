//
//  GHButton.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import UIKit

class GHButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        
        configure()
    }
    
    private func configure() {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
