//
//  OrganizationVC.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import UIKit

protocol ItemViewedDelegate: AnyObject {
    func didView(organization: Organization)
}

class OrganizationVC: UIViewController {
    
    var organization: Organization?
    weak var delegate: ItemViewedDelegate!
    
    let orgNameLabel = GHTitleLabel(textAlignment: .center, fontSize: 34)
    let avatarImageView = GHAvatarImageView(frame: .zero)
    let githubButton = GHButton(backgroundColor: .systemBlue, title: "GitHub Profile")
    let orgDescriptionLabel = GHBodyLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureItemViewedButton()
        configureUIElements()
        addSubviewsAndLayoutUI()
        configureCallToActionButton()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = doneButton
    }
    
    func configureItemViewedButton() {
        guard let organization = organization else { return }
        
        delegate.didView(organization: organization)
        
        let viewedState = organization.isViewed ? SFSymbols.viewed : SFSymbols.notViewed
        
        let viewedButton = UIBarButtonItem(image: UIImage(systemName: viewedState), style: .plain, target: self, action: nil)
        viewedButton.isEnabled = false
        navigationItem.rightBarButtonItem = viewedButton
    }
    
    func configureUIElements() {
        guard let organization = organization else { return }
        
        orgNameLabel.text = organization.login
        avatarImageView.downloadImage(from: organization.avatarUrl)

        if organization.description == "" {
            orgDescriptionLabel.text = "No Description"
        } else {
            orgDescriptionLabel.text = organization.description
        }
    }
    
    func addSubviewsAndLayoutUI() {
        view.addSubview(orgNameLabel)
        view.addSubview(avatarImageView)
        view.addSubview(githubButton)
        view.addSubview(orgDescriptionLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            orgNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            orgNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            orgNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            orgNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            avatarImageView.topAnchor.constraint(equalTo: orgNameLabel.bottomAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 340),
            
            githubButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding),
            githubButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            githubButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            githubButton.heightAnchor.constraint(equalToConstant: 44),
            
            orgDescriptionLabel.topAnchor.constraint(equalTo: githubButton.bottomAnchor),
            orgDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            orgDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            orgDescriptionLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configureCallToActionButton() {
        githubButton.addTarget(self, action: #selector(goToGithubProfile), for: .touchUpInside)
    }
    
    func getOrganizationGithubProfile() {
        guard let organization = organization else { return }
        
        NetworkManager.shared.getOrganization(name: organization.login) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let organization):
                self.organization = organization
            case .failure(let error):
                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goToGithubProfile() {
        getOrganizationGithubProfile()
        
        guard let organization = organization, let htmlUrl = URL(string: organization.htmlUrl) else { return }
        
        presentSafariVC(with: htmlUrl)
    }
    
}

extension OrganizationVC: ItemViewedDelegate {
    func didView(organization: Organization) {
    }
}
