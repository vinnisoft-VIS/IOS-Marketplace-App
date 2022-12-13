//
//  HomeModel.swift
//  Dupli
//
//  Created by Gaurav on 14/10/22.
//

import Foundation

struct HomeModel : Decodable {
    let success : Bool?
    let message : String?
    let data : HomeModelData?
}

struct HomeModelData : Decodable {
    let categories : [HomeModelCategories]?
    let products_for_you : [ProductsModelData]?
    let newsfeed : [ProductsModelData]?
    let new_collections : [HomeModelNewCollections]?
}

struct HomeModelCategories : Decodable {
    let id : Int?
    let name : String?
    let image : String?
    let image_path : String?
    let status : Int?
    let created_at : String?
    let updated_at : String?
}

struct HomeModelNewCollections : Decodable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let user_name : String?
    let image : String?
}


