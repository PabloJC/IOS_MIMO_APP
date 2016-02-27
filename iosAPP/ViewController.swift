//
//  ViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 31/1/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mainTable: UITableView!
    var externalStoryboard: UIStoryboard!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        back.layer.cornerRadius = 5
        let dataStore = SQLiteDataStore.sharedInstance
        do{
            try dataStore.createTables()
            
            if try StorageDataHelper.find(1) == nil {
                
            let  S = Storage()
             let id = try  StorageDataHelper.insert(S)
                print ("storage creado \(id)" )
                
            }
            if try CartDataHelper.find(1) == nil {
                
                let  C = Cart()
                let id = try  CartDataHelper.insert(C)
                print ("cart creado \(id)" )
                
            }
            
        
        }catch _ {
            print ("error insert")
        }
        print ("Finish")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag{
        case 1:
            externalStoryboard = UIStoryboard(name: "ShoppingListSB", bundle: nil)
            let shoppingListInstance = externalStoryboard.instantiateViewControllerWithIdentifier("shoppingListID") as? ShoopingListViewController
            self.navigationController?.pushViewController(shoppingListInstance!, animated: true)
            break
        case 2:
            externalStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
            let listRecipeInstance = externalStoryboard.instantiateViewControllerWithIdentifier("ListRecipes") as? RecipesViewController
            self.navigationController?.pushViewController(listRecipeInstance!, animated: true)

            break
        default:
            externalStoryboard = UIStoryboard(name: "IngredientsSB", bundle: nil)
            let ingredientListInstance = externalStoryboard.instantiateViewControllerWithIdentifier("KitchenViewID") as? KitchenViewController
            self.navigationController?.pushViewController(ingredientListInstance!, animated: true)

            break
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


}

