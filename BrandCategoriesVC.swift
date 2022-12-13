//
//  BrandCategoriesVC.swift
//  Dupli
//
//  Created by Gaurav on 06/09/22.
//

import UIKit

class BrandCategoriesVC:  UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var img:UIImageView!
    var isFromPostProduct = Bool()
    var subCategoryData = (categoryId:Int(),
                           gender:BaseCategories.men,
                           image:String(),categoryName:String())
    var subCategories: [SubCategoriesModelData]?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialLoads()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
}
