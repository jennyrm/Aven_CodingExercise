//
//  OrganizationCell.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import UIKit

class OrganizationCell: UICollectionViewCell {
    
    static let reuseID = "OrganizationCell"
    
    var viewedImageState = GHViewedImageState(frame: .zero)
    let avatarImageView = GHAvatarImageView(frame: .zero)
    let orgNameLabel = GHTitleLabel(textAlignment: .left, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(organization: Organization) {
        if organization.isViewed {
            viewedImageState.image = UIImage(systemName: SFSymbols.viewed)
        }
        orgNameLabel.text = organization.login
        avatarImageView.downloadImage(from: organization.avatarUrl)
    }
    
    private func configure() {
        addSubview(viewedImageState)
        addSubview(orgNameLabel)
        addSubview(avatarImageView)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            viewedImageState.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            viewedImageState.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            viewedImageState.heightAnchor.constraint(equalToConstant: 20),
            viewedImageState.widthAnchor.constraint(equalToConstant: 20),
            
            avatarImageView.topAnchor.constraint(equalTo: viewedImageState.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            
            orgNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding),
            orgNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            orgNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            orgNameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewedImageState.image = nil
    }
    
}
