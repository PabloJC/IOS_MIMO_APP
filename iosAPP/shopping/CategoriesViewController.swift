//
//  CategoriesViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 24/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categorias: UICollectionView!
    
    let reuseIdentifier = "cell"
    var items = [Dictionary<String,AnyObject>]()
    var category = ""
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var myLayout = UICollectionViewFlowLayout()
     @IBOutlet weak var ingredientsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        categoryInit()
        
        myLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        myLayout.minimumInteritemSpacing = 0
        myLayout.minimumLineSpacing = 0
        
        if UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation){
            screenWidth = UIScreen.mainScreen().bounds.width
            screenHeight = UIScreen.mainScreen().bounds.height
            print("POO")
            myLayout.itemSize = CGSize(width:screenWidth/4 , height: screenHeight/3)
        }else{
            myLayout.itemSize = CGSize(width: screenWidth/3, height: screenHeight/5.5)
        }
        
        self.categorias.setCollectionViewLayout(myLayout, animated: false)

    }
    func setText(){
        ingredientsLabel.text = NSLocalizedString("INGREDIENTS",comment:"Ingredientes")
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        screenWidth = UIScreen.mainScreen().bounds.width
        screenHeight = UIScreen.mainScreen().bounds.height
        if (toInterfaceOrientation.isLandscape){
            
            myLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            myLayout.minimumInteritemSpacing = 0
            myLayout.minimumLineSpacing = 0
            
            myLayout.itemSize = CGSize(width:screenHeight/4 , height: screenWidth/3)
            
        }else{
            myLayout.itemSize = CGSize(width: screenHeight/3, height: screenWidth/5.5)
        }
        self.categorias.setCollectionViewLayout(myLayout, animated: false)
    }
    
    func categoryInit(){
        let filePath = NSBundle.mainBundle().pathForResource("Category", ofType: "json")
        
        let jsonData = NSData.init(contentsOfFile: filePath!)
        
        do {
            let objOrigen = try NSJSONSerialization.JSONObjectWithData(jsonData!,
                options: [.MutableContainers, .MutableLeaves]) as! [String:AnyObject]
            
            for category in objOrigen["Categories"] as! [[String:AnyObject]] {
                items.append(category)
            }
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryCartCollectionViewCell
        
        cell.categoryLabel.text = self.items[indexPath.item]["category"] as? String
        var image = self.items[indexPath.item]["image"] as! String
        if(image == ""){
            image = "Carne"
        }
        cell.image.image = UIImage(named: image)
        
        return cell    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        category = items[indexPath.row]["category"] as! String
        performSegueWithIdentifier("ingredientsCategory", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueID = segue.identifier{
            if segueID == "ingredientsCategory"{
                if let destinoVC = segue.destinationViewController as? IngredientsCartViewController{
                    destinoVC.category = self.category
                }
            }
        }
        
    }

}
