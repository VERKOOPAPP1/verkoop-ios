//
//  HomeVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionViewBrowse: UICollectionView!
    @IBOutlet weak var buttonCategory: UIButton!
    @IBOutlet weak var buttonSell: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewNavigationBar: UIView!
    
    var collectionCellType: [HomeScreenCollectionView] = []    
    var imagePicker = UIImagePickerController()
    var pickCollectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    var customPageControl : UIPageControl!
    var advertiseCollectionView : UICollectionView!    
    let dummyCount = 3
    var timer: Timer?
    var timerStarted = false
    var pageIndex = 1
    var itemData: Item?
    var indices : [IndexPath] = []
    var selectedImage: UIImage?
    var recognizedTag = ""
    
    var totalContentWidth: CGFloat {
        if let count = itemData?.data?.advertisments?.count {
            return  CGFloat(count * dummyCount) * kScreenWidth
        } else {
            return kScreenWidth
        }
    }
    
    //MARK:- Life Cycle Delegates
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewNavigationBar.setBottomShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        Constants.sharedAppDelegate.setSwipe(enabled: false, navigationController: navigationController)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
        timerStarted = false
    }
    
    //MARK:- Private Methods
    //MARK:-
    
    func setupView() {
        buttonCategory.setRadius(5)
        textFieldSearch.makeRoundCorner(5)
        buttonSell.setRadius(25, .white, 3)
        textFieldSearch.applyPadding(padding: 10)
        
        let frame = CGRect(x: 0, y: 0, width: 40, height: 18)
        textFieldSearch.setRightViewWith(imageName: "search", frame: frame)
        textFieldSearch.text = ""
        textFieldSearch.setAttributedPlaceholderWith(font: UIFont.kAppDefaultFontBold(ofSize: 17), color: .darkGray)

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: UIControl.Event.valueChanged)
        collectionViewBrowse.addSubview(refreshControl)
        collectionViewBrowse.tag = 2
        collectionViewBrowse.register(UINib(nibName: ReuseIdentifier.adsCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.adsCollectionCell)
        collectionViewBrowse.register(UINib(nibName: ReuseIdentifier.categoryCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.categoryCollectionCell)
        collectionViewBrowse.register(UINib(nibName: ReuseIdentifier.filterDetailCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.filterDetailCollectionCell)
        collectionViewBrowse.register(BrandsCollectionCell.self, forCellWithReuseIdentifier: ReuseIdentifier.BrandsCollectionCell)
        collectionViewBrowse.register(CarAndPropertyCell.self, forCellWithReuseIdentifier: ReuseIdentifier.CarAndPropertyCell)
        collectionViewBrowse.isHidden = true
        collectionViewBrowse.dataSource = self
        collectionViewBrowse.delegate = self
        buttonCategory.addTarget(self, action: #selector(buttonTappedViewAll(_:)), for: .touchUpInside)
        if let _ = Constants.sharedUserDefaults.value(forKey: UserDefaultKeys.kSellItem) {
            Constants.sharedUserDefaults.removeObject(forKey: UserDefaultKeys.kSellItem)
            let vc = SelectedPhotosVC.instantiate(fromAppStoryboard: .categories)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: false)
            }
            delay(time: 0.3) {
                self.requestServer(showLoader: false)
            }
        } else {
            requestServer()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if textFieldSearch.isFirstResponder {
            textFieldSearch.resignFirstResponder()
        }
    }

    //MARK:- IBActions
    //MARK:-
    
    @IBAction func buttonSellTapped(sender: UIButton) {
        let vc = SelectedPhotosVC.instantiate(fromAppStoryboard: .categories)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        let vc = FavouritesCategoriesVC()
        vc.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func scanImageButtonAction(_ sender: UIButton) {
        openCamera(completionHandler: { (success:Bool, error:NSError?) in
            if let error = error {
                OperationQueue.main.addOperation {
                    DisplayBanner.show(message: error.localizedDescription)
                }
                return
            }
            if success {
                OperationQueue.main.addOperation {
                    self.openImagePicker(sourceType: .camera)
                }
            }
        })
    }

    @objc func refreshData(_ sender: AnyObject) {
        pageIndex = 1
        requestServer()
    }
}

extension HomeVC: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
        view.endEditing(true)        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func openImagePicker(sourceType:UIImagePickerController.SourceType) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        OperationQueue.main.addOperation({
            self.present(self.imagePicker, animated: true, completion: nil)
        })
    }
    
    //MARK:- ImagePickerController Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Bug in iOS. The image auto rotates itself. So, in order to fix, image scaling + rotation is done
            selectedImage = pickedImage.rotateImageWithScaling()
            imageRecognizeService(with: Utilities.sharedUtilities.base64EncodeImage(selectedImage ?? UIImage()))
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
