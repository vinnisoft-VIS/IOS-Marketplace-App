//
//  BrandCategoriesVCExtension.swift
//  Dupli
//
//  Created by Gaurav on 06/09/22.
//

import UIKit


//MARK: - Functions

extension BrandCategoriesVC{
    
    func initialLoads() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.titleTextAttributes = nil
        let title:String = {
            switch subCategoryData.gender{
            case BaseCategories.men:
                return "\("MEN".localized()) - \(subCategoryData.categoryName)"
            case BaseCategories.women:
                return "\("WOMEN".localized()) - \(subCategoryData.categoryName)"
            default:
                return "\("KIDS".localized()) - \(subCategoryData.categoryName)"
            }
        }()
        img.setImage(url: subCategoryData.image)
        configureNaviBar(title: title, isBackButton: true)
        getSubCategories()
    }
}


//MARK: - Table View Methods

extension BrandCategoriesVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return subCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tblView.dequeueReusableCell(withIdentifier: "BrandCategoriesTblCell" , for: indexPath) as! BrandCategoriesTblCell
        cell.selectionStyle = .none
        let subcategory = subCategories?[indexPath.row]
        if let name = subcategory?.name {
            cell.lblTitle.text = name
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let subcategory = subCategories?[indexPath.row]

    
        if let isNext = subcategory?.is_next{
            if isNext == 1{
                let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC
                vc.subCategoryData.categoryId = subCategoryData.categoryId
                vc.subCategoryData.gender = subCategoryData.gender
                vc.isFromPostProduct = isFromPostProduct
                if let name = subcategory?.name {
                    vc.subCategoryData.categoryName = name
                }
                if let id = subcategory?.id {
                    vc.subCategoryData.subcategoryId = id
                }
                
                navigationController?.pushViewController(vc, animated: true)
            }else{
                if let id = subcategory?.id{
                    if let name = subcategory?.name {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "subCategoryTwo"), object: nil, userInfo: ["name":name,"id": 0,"gender":subCategoryData.gender,"categoryId":subCategoryData.categoryId,"subCategoryId":id])
                        navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
}

class BrandCategoriesTblCell:UITableViewCell{
    @IBOutlet weak var lblTitle:UILabel!

}
