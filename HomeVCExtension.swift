//
//  HomeVCExtension.swift
//  Dupli
//
//  Created by Developer on 24/08/22.
//

import Foundation
import UIKit
import TagListView

//MARK: - Functions

extension HomeVC {
    
    func initialLoads(){
        getData()
        setupNavBar()
    }
    
    private func setupNavBar(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        let menuButton = UIBarButtonItem.init(image: UIImage.init(named: "sideMenu"), style: .plain, target: self, action: #selector(menuAction))
        navigationItem.leftBarButtonItem = menuButton
        
        let bagButton = UIBarButtonItem.init(image: UIImage.init(named: "shopping-bag"), style: .plain, target: self, action: #selector(bagAction))
        
        let chatButton = UIBarButtonItem.init(image: UIImage.init(named: "chat"), style: .plain, target: self, action: #selector(chatAction))
        
        navigationItem.rightBarButtonItems = [chatButton,bagButton]
        
//        let attributes = [NSAttributedString.Key.font: UIFont(name: AppFonts.righteous, size: 30)!]
//        navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.backgroundColor = .white
        let navView = UIImageView(image:"navLogo".image())
        self.navigationItem.titleView = navView
    }
    
    @objc func menuAction(){
        let vc = StoryBoards.settings.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func bagAction(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "BagVC") as! BagVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func chatAction(){
        
    }
}


//MARK: - Table View Methods

extension HomeVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2 + (newsfeed?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
            
        case 0:
            let cell = tblView.dequeueReusableCell(withIdentifier: "HomeCollectionTblCell" , for: indexPath) as! HomeCollectionTblCell
            cell.parentVC = self
            cell.newCollections = newCollections
            cell.clcView.reloadData()
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tblView.dequeueReusableCell(withIdentifier: "HomeProductsForUTblCell" , for: indexPath) as! HomeProductsForUTblCell
            cell.productsForYou = productsForYou
            cell.parentVC = self
            cell.clcView.reloadData()
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tblView.dequeueReusableCell(withIdentifier: "HomeNewsFeedTblCell" , for: indexPath) as! HomeNewsFeedTblCell
            let feed = newsfeed?[indexPath.row - 2]
            cell.selectionStyle = .none
            cell.newsfeed = newsfeed
            cell.parentVC = self
            cell.index = indexPath.row - 2
      //      cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.cornerRadius = 16
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            if let store = feed?.user_store{
                if let img = store.image{
                    cell.imgStore.setImage(url: img)
                    cell.imgStore.layer.cornerRadius = 15
                    cell.imgStore.clipsToBounds = true
                }
                if let name = store.user_name{
                    cell.lblName.text = name
                }
            }
            
            if let images = feed?.images{
                cell.images = images
                cell.pageControl.numberOfPages = images.count
                cell.clcView.reloadData()
            }
            
            cell.brands.removeAll()
            if let brand = feed?.brand_name{
                cell.brands.append(brand)
            }
            if let price = feed?.selling_price{
                cell.lblPrice.text = "\(price) \(currency)"
            }
            if let catTwoName = feed?.subcategorytwo_name{
                cell.brands.append(catTwoName)
            }
            if let condition = feed?.condition_name{
                cell.brands.append(condition)
            }
            if let sizes = feed?.sizes{
                cell.brands.append(sizes)
            }
            cell.clcViewTags.reloadData()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.row{
        case 0:
            return UIScreen.main.bounds.width - 14
        case 1:
            return 400
        default:
            return UITableView.automaticDimension
        }
        
    }
    
}

//MARK: - Collection View Methods

extension HomeVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clcView.dequeueReusableCell(withReuseIdentifier: "HomeVCClcCell", for: indexPath) as! HomeVCClcCell
        let cat = categories?[indexPath.row]
        if let name = cat?.name{
           cell.lblName.text = name
        }
        if let img = cat?.image_path{
            cell.image.setImage(url: img)
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: clcView.frame.width/5 - 8, height: clcView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == (categories?.count ?? 0) - 1{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension HomeCollectionTblCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newCollections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clcView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionClcCell", for: indexPath) as! HomeCollectionClcCell
        let collection = newCollections?[indexPath.row]
        cell.img.layer.cornerRadius = 16
        if let name = collection?.user_name{
            cell.lblName.text = name
        }
        if let img = collection?.image{
            cell.img.setImage(url: img)
        }
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: clcView.frame.width - 80, height: clcView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        vc.hidesBottomBarWhenPushed = true
//        parentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension HomeProductsForUTblCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsForYou?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clcView.dequeueReusableCell(withReuseIdentifier: "HomeProductsForUClcCell", for: indexPath) as! HomeProductsForUClcCell
        let product = productsForYou?[indexPath.row]
        cell.viewBase.layer.cornerRadius = 16
        cell.viewBase.clipsToBounds = true
        if let name = product?.name{
            cell.lblName.text = name
        }
        if let price = product?.selling_price{
            cell.lblPrice.text = "\(currency) \(price)"
        }
        if let images = product?.images{
            if images.count > 0{
                let img = images[0]
                if let url = img.image{
                    cell.img.setImage(url: url)
                }
            }
        }
        if let sizes = product?.sizes{
            let filteredSizes = sizes.replacingOccurrences(of: ",", with: "/")
            if let subCategoryTwo = product?.subcategorytwo_name{
                cell.lblAttributes.text = "\(filteredSizes) - \(subCategoryTwo)"
            }
        }
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
            return CGSize(width: 200, height: 274)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        let product = productsForYou?[indexPath.row]
        if let id = product?.id{
            vc.productId = id
        }
        vc.hidesBottomBarWhenPushed = true
        parentVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeNewsFeedTblCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if clcView == collectionView{
            return images?.count ?? 0
        } else {
            return brands.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if clcView == collectionView{
            
            let cell = clcView.dequeueReusableCell(withReuseIdentifier: "HomeNewsFeedClcCell", for: indexPath) as! HomeNewsFeedClcCell
            let img = images?[indexPath.row]
            if let image = img?.image{
                cell.img.setImage(url: image)
            }
            return cell
            
        } else {
            
            let cell = clcViewTags.dequeueReusableCell(withReuseIdentifier: "TagsCVC", for: indexPath) as! TagsCVC
            
            cell.lblTag.text = brands[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if clcView == collectionView {
            
            return CGSize(width: clcView.frame.width, height: clcView.frame.height)
            
        } else {
            
            let label = UILabel(frame: CGRect.zero)
            label.text = brands[indexPath.item]
            label.sizeToFit()
            return CGSize(width: label.frame.width + 16, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if clcView == collectionView {
            
            let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
            let product = newsfeed?[index]
            if let id = product?.id{
                vc.productId = id
            }
            vc.hidesBottomBarWhenPushed = true
            parentVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}



class HomeVCClcCell:UICollectionViewCell{
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var image:UIImageView!
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
       image.layer.cornerRadius = image.frame.width/2
    }
}

class HomeCollectionTblCell:UITableViewCell{
    @IBOutlet weak var clcView:UICollectionView!
    var parentVC = UIViewController()
    var newCollections : [HomeModelNewCollections]?
    override func awakeFromNib() {
        clcView.dataSource = self
        clcView.delegate = self
    }
}

class HomeProductsForUTblCell:UITableViewCell{
    @IBOutlet weak var clcView:UICollectionView!
    var productsForYou : [ProductsModelData]?
    var parentVC = UIViewController()
    override func awakeFromNib() {
        clcView.dataSource = self
        clcView.delegate = self
        
    }
}


class HomeNewsFeedTblCell:UITableViewCell,UIScrollViewDelegate{
    @IBOutlet weak var clcView:UICollectionView!
    @IBOutlet weak var clcViewTags:UICollectionView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var imgStore:UIImageView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var viewTop:UIView!
    @IBOutlet weak var viewBottom:UIView!

    var brands = [String]()
    var index = Int()
    var images : [ProductsModelImages]?
    var parentVC = UIViewController()
    var newsfeed : [ProductsModelData]?
    override func awakeFromNib() {
        clcView.dataSource = self
        clcView.delegate = self
        clcViewTags.dataSource = self
        clcViewTags.delegate = self
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        contentView.clipsToBounds = true
        viewTop.roundCorners([.topLeft,.topRight], radius: 16)
        viewBottom.roundCorners([.bottomLeft,.bottomRight], radius: 16)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        let progressInInt = Int(progress)
        pageControl.currentPage = progressInInt
    }
    
}

class HomeCollectionClcCell:UICollectionViewCell{
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var img:UIImageView!
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        lblName.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        lblName.frame = CGRect(x:13, y:19, width:20, height:200)
    }
}

class HomeProductsForUClcCell:UICollectionViewCell{
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblAttributes:UILabel!
    @IBOutlet weak var viewBase:UIView!
}

class HomeNewsFeedClcCell:UICollectionViewCell{
    @IBOutlet weak var img:UIImageView!
}

class TagsCVC:UICollectionViewCell{
    @IBOutlet weak var lblTag:UILabel!
}

