//
//  ServiceViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/24/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController,UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    let cartNavigationButton:UIButton = {
        let cartNavigationIcon = UIButton(type: .system)
        cartNavigationIcon.setImage(UIImage(named: "ic_cart_64_white"), for: .normal)
        cartNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        cartNavigationIcon.tintColor = .white
        return cartNavigationIcon
    }()
    
    let searchNavigationButton:UIButton = {
        let searchNavigationIcon = UIButton(type: .system)
        searchNavigationIcon.setImage(UIImage(named: "ic_search_white_64-1"), for: .normal)
        searchNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        searchNavigationIcon.tintColor = .white
        return searchNavigationIcon
    }()
    
    let infoNavigationButton:UIButton = {
        let infoNavigationIcon = UIButton(type: .system)
        infoNavigationIcon.setImage(UIImage(named: "ic_info_white_64"), for: .normal)
        infoNavigationIcon.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        infoNavigationIcon.tintColor = .white
        return infoNavigationIcon
    }()
    
    var searchController:UISearchController!
    var resultController = UITableViewController()
    @objc func searchClicked() {
        self.searchController.searchBar.isHidden = false
        self.searchController.searchBar.becomeFirstResponder()
    }
    func setNavigationBar() {
        searchNavigationButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchClicked)))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItems =  [UIBarButtonItem(customView: cartNavigationButton),UIBarButtonItem(customView: infoNavigationButton)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchNavigationButton)
        
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
        navigationController?.navigationBar.isTranslucent = false
        
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchBar.searchBarStyle = .prominent;
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.placeholder = "Tìm kiếm"
        self.searchController.searchBar.setValue("Huỷ", forKey: "_cancelButtonText")
        self.searchController.searchBar.delegate = self
        self.navigationController?.navigationBar.tintColor = .white
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar;
        self.searchController.searchBar.isHidden = true
        self.definesPresentationContext = true;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
    }

    //keyboard
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItems = nil
        navigationItem.leftBarButtonItem = nil
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartNavigationButton),UIBarButtonItem(customView: infoNavigationButton)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchNavigationButton)
        self.searchController.searchBar.isHidden = true
    }
}
