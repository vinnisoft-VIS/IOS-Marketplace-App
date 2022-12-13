//
//  HomeVC.swift
//  Dupli
//
//  Created by Developer on 24/08/22.
//

import UIKit
import TagListView
class HomeVC: UIViewController {

    @IBOutlet weak var clcView:UICollectionView!
    @IBOutlet weak var tblView:UITableView!
    
    var categories : [HomeModelCategories]?
    var productsForYou : [ProductsModelData]?
    var newsfeed : [ProductsModelData]?
    var newCollections : [HomeModelNewCollections]?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialLoads()
    }
    

}
