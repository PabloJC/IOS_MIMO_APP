//
//  IngredientsViewController.swift
//  iosAPP
//
//  Created by MIMO on 14/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var categorias: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [Dictionary<String,AnyObject>]()
    var category = ""
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    

    @IBOutlet weak var ingredientsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        categoryInit()
        let myLayout = UICollectionViewFlowLayout()
        
        myLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        myLayout.minimumInteritemSpacing = 0
        myLayout.minimumLineSpacing = 0
        myLayout.itemSize = CGSize(width: screenWidth/3, height: screenHeight/6)
        
        self.categorias.setCollectionViewLayout(myLayout, animated: false)
    }
    func setText(){
        ingredientsLabel.text = NSLocalizedString("INGREDIENTS",comment:"Ingredientes")
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryLabel.text = self.items[indexPath.item]["category"] as? String
        var image = self.items[indexPath.item]["image"] as! String
        print(image)
        //cell.backgroundColor = UIColor.yellowColor()
        if(image == ""){
            image = "sinImagen"
        }
        cell.image.image = UIImage(named: image)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        category = items[indexPath.row]["category"] as! String
        performSegueWithIdentifier("ingredientsCategory", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueID = segue.identifier{
            if segueID == "ingredientsCategory"{
                if let destinoVC = segue.destinationViewController as? IngredientListViewController{
                    destinoVC.category = self.category
                }
            }  
        }

    }
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
