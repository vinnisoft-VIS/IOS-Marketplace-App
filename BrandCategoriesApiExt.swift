//
//  BrandCategoriesApiExt.swift
//  Dupli
//
//  Created by Gaurav on 04/10/22.
//

import Foundation

extension BrandCategoriesVC {
    
    func getSubCategories() {
        
        let params = [Parameters.type:subCategoryData.gender,
                      Parameters.categoryId:subCategoryData.categoryId] as [String : Any]
        
        ApiManager.postAPI(apiUrl: Apis.subCategories,parameters: params, Vc: self, showLoader: true) { [weak self] (data:SubCategoriesModel) in
            guard let self = self else { return }
            if let success = data.success {
                if success {
                    if let responseData = data.data {
                        self.subCategories = responseData
                        self.tblView.reloadData()
                    }
                } else {
                    self.showAlert(message: data.message ?? AlertMessages.somethingWentWrong, title: "")
                }
            } else {
                self.showAlert(message: AlertMessages.somethingWentWrong, title: "")
            }
        }
    }
}
