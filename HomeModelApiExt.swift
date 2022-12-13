//
//  HomeModelApiExt.swift
//  Dupli
//
//  Created by Gaurav on 14/10/22.
//

import Foundation

extension HomeVC {
    
    func getData() {
        
        let params = [String:Any]()
        
        ApiManager.getAPI(Apis.home,parameters: params, Vc: self, showLoader: true) { [weak self] (data:HomeModel) in
            guard let self = self else { return }
            if let success = data.success {
                if success {
                    if let responseData = data.data{
                        if let categories = responseData.categories{
                            self.categories = categories
                        }
                        if let productsForYou = responseData.products_for_you{
                            self.productsForYou = productsForYou
                        }
                        if let newCollections = responseData.new_collections{
                            self.newCollections = newCollections
                        }
                        if let newsfeed = responseData.newsfeed{
                            self.newsfeed = newsfeed
                        }
                        self.clcView.reloadData()
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
