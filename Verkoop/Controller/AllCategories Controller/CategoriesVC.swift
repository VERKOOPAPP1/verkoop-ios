//
//  CategoriesVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 08/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    
    var categoryList: CategoryList?
    var maxBottom: CGFloat = 0
    var lastView: ParentView?
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var innerView: UIView!
    
    //MARK:- Life Cycle Delegates
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        requestServer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    //MARK:- Private Funtions
    //MARK:-
    
    fileprivate func initialSetUp() {    
        textFieldSearch.makeRoundCorner(5)
        textFieldSearch.applyPadding(padding: 10)
        let frame = CGRect(x: 0, y: 0, width: 40, height: 18)
        textFieldSearch.setRightViewWith(imageName: "search", frame: frame)
        textFieldSearch.text = ""
        textFieldSearch.setAttributedPlaceholderWith(font: UIFont.kAppDefaultFontMedium(ofSize: 17), color: .darkGray)
    }
    
    func setupUI() {
        let noOfColumn: CGFloat = 2
        let paddding: CGFloat = 10
        let availableWidth = innerView.frame.width - (paddding * 3)
        let columnWidth = availableWidth / noOfColumn
        let xPositionFirst = paddding
        let xPositionSecond = (2 * paddding) + columnWidth
        var xOffset = [CGFloat]()
        xOffset.append(xPositionFirst)
        xOffset.append(xPositionSecond)
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: Int(noOfColumn))
        var totalHeight: CGFloat = 0
        for (index, cat) in (categoryList?.data?.enumerated())! {
            if yOffset[0] <= yOffset[1] {
                column = 0
            } else {
                column = 1
            }
            let height = getHeight(x: xOffset[column] , y: yOffset[column] + paddding, width: columnWidth, item: cat, index: index)
            yOffset[column] = yOffset[column] + height + paddding
            totalHeight = max(totalHeight, yOffset[column]) + paddding
        }
    }
    
    func getHeight(x: CGFloat, y: CGFloat, width: CGFloat, item: Category, index: Int)-> CGFloat {
        let parentView = getParentView()
        parentView.tag = index
        parentView.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(parentView)
        parentView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: x).isActive = true
        parentView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: y).isActive = true
        parentView.widthAnchor.constraint(equalToConstant: width).isActive = true
        // parentView.backgroundColor = .green
        parentView.labelHeader.text = item.name
        if item.name == "Business Services"{
//            Console.log("got")
        }
//        Console.log(item.name)
        parentView.buttonCategory.tag = index
        parentView.stackView.tag = index
        parentView.buttonCategory.addTarget(self, action: #selector(buttonCategoryTapped), for: .touchUpInside)
        // parentView.buttonHeader.backgroundColor = .red
        parentView.setRadius(5, UIColor(hexString: "#B2B2B2"), 0.8)
        for (index, items) in (item.sub_category?.enumerated())! {
            let child = getChildView()
            child.translatesAutoresizingMaskIntoConstraints = false
//            Console.log(items.name)
            child.labelHeader.numberOfLines = 0
            child.labelHeader.lineBreakMode = .byWordWrapping
            child.labelHeader.attributedText = getAtt(value: items.name ?? "")
            child.viewPoint.setRadius(2.5)
            child.viewPoint.isHidden = true
            //child.buttonHeader.backgroundColor = .gray
            child.buttonSubcategory.tag = index
            parentView.stackView.addArrangedSubview(child)
            child.buttonSubcategory.addTarget(self, action: #selector(buttonSubcategoryTapped), for: .touchUpInside)
        }
        //Console.log("Height \(parentView.frame.height)")
        parentView.layoutIfNeeded()
       // Console.log("Height \(parentView.frame.height)")
        if  (y + parentView.frame.height) > maxBottom {
            maxBottom = parentView.frame.height + y
            lastView = parentView
        }
        if index == ((categoryList?.data?.count ?? 0) - 1) {
            lastView?.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -10).isActive = true
        }
        //Console.log("X \(x) Y \(y) Width \(width) Height \(parentView.frame.height) bottom \(y + parentView.frame.height)")
        return parentView.frame.height
    }
    
    func getAtt(value: String)-> NSAttributedString {
        let bullet = "•  "
        let fullStr = bullet + value
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.preferredFont(forTextStyle: .body)
        attributes[.foregroundColor] = UIColor.darkGray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = (bullet as NSString).size(withAttributes: attributes).width
        attributes[.paragraphStyle] = paragraphStyle
        return NSAttributedString(string: fullStr, attributes: attributes)
    }
    
    func getParentView()-> ParentView{
        return  Bundle.main.loadNibNamed("ParentView", owner: self, options: nil)?.first as! ParentView
    }
    
    func getChildView()-> ChildView{
        return Bundle.main.loadNibNamed("ChildView", owner: self, options: nil)?.first as! ChildView
    }
    
    //MARK:- IBActions
    //MARK:-
    
    @objc func buttonCategoryTapped(sender: UIButton) {
        let category = categoryList?.data![sender.tag]
        if category?.id == 85 { //Car and Property Section
            let carListVC = CarListVC()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(carListVC, animated: true)
            }
        } else if category?.id == 24 {
            let carListVC = PropertyListVC()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(carListVC, animated: true)
            }
        } else {
            let filterVC = CategoriesFilterVC.instantiate(fromAppStoryboard: .categories)
            filterVC.catgoryId = String.getString(category?.id)
            filterVC.categoryName = String.getString(category?.name)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(filterVC, animated: true)
            }
        }
    }
    
    @objc func buttonSubcategoryTapped(sender: UIButton) {
        let section = sender.superview?.superview?.tag ?? 0
        if categoryList?.data![section].id == 85  {
            let carListVC = CarListVC()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(carListVC, animated: true)
            }
        } else if categoryList?.data![section].id == 24 {
            let carListVC = PropertyListVC()
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(carListVC, animated: true)
            }
        } else {
            let filterVC = CategoriesFilterVC.instantiate(fromAppStoryboard: .categories)
            let subCategory = categoryList?.data![section].sub_category![sender.tag]
            filterVC.catgoryId = String.getString(subCategory?.id)
            filterVC.categoryName = String.getString(subCategory?.name)
            filterVC.type = "1"
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(filterVC, animated: true)
            }
        }
    }
    
    @IBAction func tappedBack(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chatButtonAction(_ sender: Any) {
        let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        let vc = FavouritesCategoriesVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoriesVC: RefreshScreen {
    func refreshData() {
        
    }
}

extension CategoriesVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
