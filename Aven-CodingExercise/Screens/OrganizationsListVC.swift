//
//  OrganizationsListVC.swift
//  Aven-CodingExercise
//
//  Created by Jenny Morales on 12/17/21.
//

import UIKit

class OrganizationsListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var organizations = [Organization]()
    var lastItemOnPage = 0
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Organization>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getOrganizationsList(since: lastItemOnPage)
        configureDataSource()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.register(OrganizationCell.self, forCellWithReuseIdentifier: OrganizationCell.reuseID)
    }

    func getOrganizationsList(since: Int) {
        showLoadingView()
        
        NetworkManager.shared.getOrganizationsList(since: since) { [weak self] result in
            guard let self = self else { return }
            
            self.dimissLoadingView()
            
            switch result {
            case .success(let organizations):
                self.organizations.append(contentsOf: organizations)
                self.updateData(on: self.organizations)
                
                if let lastItem = organizations.last {
                    self.lastItemOnPage = lastItem.id
                }
            case .failure(let error):
                print("Error in \(#function): on line \(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    //collection view doesnt manage the underlying data - data source object does
    //data source manages the data and provides the collection view with snapshots to display
    //diffable data source: rather than telling the data source how to move the data around -> tell the data source what the new state of data is; data source automatically does the job of figuring out the diff btwn the old state and the new and how to apply the changes to collection views
    func configureDataSource() {
        //data source takes each value from the snapshot and applies it to the collection view
        dataSource = UICollectionViewDiffableDataSource<Section, Organization>(collectionView: collectionView, cellProvider: { collectionView, indexPath, organization in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrganizationCell.reuseID, for: indexPath) as? OrganizationCell else { return UICollectionViewCell() }
            
            cell.set(organization: organization)
            
            return cell
        })
    }
    
    func updateData(on organizationsList: [Organization]) {
        //snapshot = truth of the current UI state
        //provide the snapshot to the data source along with instructions on what to do with the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Organization>()
        snapshot.appendSections([.main])
        snapshot.appendItems(organizationsList)
        
        //can run on background thread
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
}//End of class

extension OrganizationsListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

//        print("contentHeight:", contentHeight)
//        print("contentHeight - height:", contentHeight - height)
//        print("offsetY:", offsetY)
        
        if offsetY > contentHeight - height {
            getOrganizationsList(since: lastItemOnPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let organizationVC = OrganizationVC()
        let organization = organizations[indexPath.item]
        organizationVC.organization = organization
        organizationVC.delegate = self
    
        let navController = UINavigationController(rootViewController: organizationVC)
        present(navController, animated: true, completion: nil)
    }
}

extension OrganizationsListVC: ItemViewedDelegate {
    func didView(organization: Organization) {
        if let index = organizations.firstIndex(where: { $0.id == organization.id }) {
            organizations[index].isViewed = true
//            print(organizations[index])
        }

        updateData(on: organizations)
    }
}
