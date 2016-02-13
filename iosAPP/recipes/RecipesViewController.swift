//
//  RecipesViewController.swift
//  iosAPP
//
//  Created by mikel balduciel diaz on 5/2/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit
import CoreData
class RecipesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var recetasString = [Dictionary<String,AnyObject>]()
    //var recipes = [NSManagedObject]()
    //var idseleccionado = 0
    var sincronized = false
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Recetas\""
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !sincronized {
            recibir()
        }
        print(sincronized)
        /*//1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest(entityName: "Recipe")
        
        //3
        do {
        let results = try managedContext.executeFetchRequest(fetchRequest)
        recipes = results as! [NSManagedObject]
        } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
        }*/
    }
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    
    //MARK : UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recetasString.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        //let recipe = recipes[indexPath.row]
        if recetasString.count > 0 {
            let recipe = recetasString[indexPath.row]
            //cell!.textLabel!.text = recipe.valueForKey("name") as? String
            cell!.textLabel!.text = recipe["name"] as? String
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // let row = indexPath.row
        //let recipe = recetasString[row]
        //idseleccionado = (recipe["id"]! as? Int)!
        // let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("recipe") as! RecipeViewController
        
        //self.navigationController!.pushViewController(secondViewController, animated: true)
        self.performSegueWithIdentifier("recipe", sender: self)
        //print("\(recipe["id"]!)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "recipe") {
            let svc = segue.destinationViewController as! RecipeViewController
            let row = tableView.indexPathForSelectedRow?.row
            let recipe = recetasString[row!]
            svc.idText = "\(recipe["id"]!)"
            print("dentro")
            
        }
    }
    
    
    @IBAction func saveRecipeAction(sender: AnyObject) {
        
        /* let alert = UIAlertController(title: "New Recipe",
        message: "Add a new recipe",
        preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
        style: .Default,
        handler: { (action:UIAlertAction) -> Void in
        
        let textField = alert.textFields!.first
        self.save(textField!.text!)
        self.tableView.reloadData()
        
        })
        
        let cancelAction = UIAlertAction (title: "Cancel",
        style: .Default,
        handler: { (action:UIAlertAction) -> Void in
        })
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
        
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)*/
        
    }
    func save (name: String){
        /*   //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Recipe",
        inManagedObjectContext:managedContext)
        
        let recipe = NSManagedObject(entity: entity!,
        insertIntoManagedObjectContext: managedContext)
        
        //3
        recipe.setValue(name, forKey: "name")
        
        //4
        do {
        try managedContext.save()
        //5
        recipes.append(recipe)
        } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
        }*/
        
    }
    func recibir(){
        self.recetasString = []
        let myapiClient = MyAPIClient()
        myapiClient.getUsersPage({ (receta,id) -> () in
            var post=Dictionary<String,AnyObject>()
            post = ["id":id,"name":receta]
            
            self.recetasString.append(post)
            
            }, finished: { () -> () in
                if !self.recetasString.isEmpty {
                    self.sincronized = true
                    self.tableView.reloadData()
                    print("finalizado \(self.recetasString.count)")
                }else {
                    print("sin recetas agregadas")
                }
                
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }
        
    }
    @IBAction func recibirServer(sender: AnyObject) {
      /*  let myapiClient = MyAPIClient()
        myapiClient.getUsersPage({ (receta) -> () in
            
            
            }, finished: { () -> () in
                print("finalizado")
            }) { (error) -> () in
                print("\(error.debugDescription)")
        }*/
    }
    
    
}
