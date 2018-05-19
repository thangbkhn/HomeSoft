//
//  ServiceViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 3/24/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController,UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == clvFood{
            return foodList.count
        }else if collectionView == clvService {
            return serviceList.count
        }else if collectionView == clvAppliances{
            return appliancesList.count
        }else if collectionView == clvKidToy{
            return kidToyList.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == clvFood{
            let item = foodList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
            cell.imgFood.image = UIImage(named: item.imageUrl!)
            cell.tvNameFood.text = item.name!
            cell.alpha = 0
            UIView.animate(withDuration: 1.5, animations: { cell.alpha = 1 })
            return cell
        }else if collectionView == clvAppliances{
            let item = appliancesList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appliancesCell", for: indexPath) as! AppliancesCollectionViewCell
            cell.img.image = UIImage(named: item.imgUrl!)
            cell.tvName.text = item.name!
            cell.alpha = 0
            UIView.animate(withDuration: 1.5, animations: { cell.alpha = 1 })
            return cell
        }else if collectionView == clvKidToy{
            let item = kidToyList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kidToyCell", for: indexPath) as! KidToyCollectionViewCell
            cell.img.image = UIImage(named: item.imgUrl!)
            cell.tvName.text = item.name!
            cell.alpha = 0
            UIView.animate(withDuration: 1.5, animations: { cell.alpha = 1 })
            return cell
        } else{
            let item = serviceList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCollectionViewCell
            cell.imgService.image = UIImage(named: item.imgUrl!)
            cell.tvName.text = item.name!
            cell.alpha = 0
            UIView.animate(withDuration: 1.5, animations: { cell.alpha = 1 })
            return cell
        }
    }
    
    var foodList:[FoodTest] = [FoodTest(_name: "Phở cuốn", _url: "", img: "food1"),
                               FoodTest(_name: "Phở bò", _url: "", img: "food2"),
                                FoodTest(_name: "Hamburger", _url: "", img: "food3"),
                                FoodTest(_name: "Gà rán KFC", _url: "", img: "food4"),
                                FoodTest(_name: "Bánh cuốn", _url: "", img: "food5"),
                                FoodTest(_name: "Cua biển", _url: "", img: "food6"),
                                FoodTest(_name: "Lẩu thái tôm", _url: "", img: "food7")]
    var serviceList:[ServiceItemTest] = [ServiceItemTest(_imgUrl: "service1", _name: "Giúp việc theo giờ"),
                                     ServiceItemTest(_imgUrl: "service2", _name: "Sửa chữa điều hoà"),
                                        ServiceItemTest(_imgUrl: "service3", _name: "Sửa chữa tủ lạnh"),
                                        ServiceItemTest(_imgUrl: "service4", _name: "Thay lõi lọc nước")]
    var appliancesList :[AppliancesTest] = [AppliancesTest(_imgUrl: "appliances1", _name: "Nước hoa để phòng"),
                                            AppliancesTest(_imgUrl: "appliances2", _name: "Gas Pertrolimex"),
                                            AppliancesTest(_imgUrl: "appliances3", _name: "Khăn giấy")]
    var kidToyList:[KidToyTest] = [KidToyTest(_imgUrl: "kidtoy1", _name: "Đồ chơi giáo dục"),
                                   KidToyTest(_imgUrl: "kidtoy2", _name: "Thẻ học Monkey")]
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    @IBOutlet weak var clvFood: UICollectionView!
    @IBOutlet weak var clvService: UICollectionView!
    @IBOutlet weak var clvAppliances: UICollectionView!
    @IBOutlet weak var clvKidToy: UICollectionView!
    
    
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
        for s in self.searchController.searchBar.subviews[0].subviews {
            if s is UITextField {
                s.layer.borderWidth = 1.0
                s.layer.cornerRadius = 10
                s.layer.borderColor = UIColor.gray.cgColor
            }
        }
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
        
        //Shadow navigation line
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        setNavigationBar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
        clvFood.reloadSections(IndexSet(integer: 0))
        clvService.reloadSections(IndexSet(integer: 0))
        clvAppliances.reloadSections(IndexSet(integer: 0))
        clvKidToy.reloadSections(IndexSet(integer: 0))
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
extension ServiceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 175) // Return any non-zero size here
    }
}
