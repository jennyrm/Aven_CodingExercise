//
//  GHViewedImageState.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/18/21.
//

import UIKit

class GHViewedImageState: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        image = UIImage(systemName: SFSymbols.notViewed)
        tintColor = .systemGray
        
        translatesAutoresizingMaskIntoConstraints = false
    }

}
