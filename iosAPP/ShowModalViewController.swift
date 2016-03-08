//
//  ShowModalViewController.swift
//  iosAPP
//
//  Created by MIMO on 5/3/16.
//  Copyright © 2016 mikel balduciel diaz. All rights reserved.
//

import UIKit

class ShowModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    var items = [String]()
    var ingredientId : Int64!
     @IBOutlet weak var picker: UIPickerView!
    var pos : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        categoryInit()
        
        picker.layer.cornerRadius = 5
        saveBt.layer.cornerRadius = 5
        
        let background = CAGradientLayer().blueToWhite()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    @IBOutlet weak var selectCategoryLb: UILabel!
    @IBOutlet weak var addIngredientLb: UILabel!

    @IBOutlet weak var saveBt: UIButton!
    @IBOutlet weak var ingredientTv: UITextField!
    @IBOutlet weak var categoryLb: UILabel!
    
    func keyboardWillShow(sender: NSNotification) {
        pos = self.view.frame.origin.y
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = pos
    }
    
    func setText() {
        saveBt.setTitle(NSLocalizedString("AGREGAR",comment:"Agregar"), forState: .Normal)
        ingredientTv.placeholder = NSLocalizedString("BUSCARINGREDIENTE",comment:"Buscar Ingrediente")
        categoryLb.text = NSLocalizedString("NUEVOINGREDIENTE",comment:"Nuevo ingrediente")
        selectCategoryLb.text = NSLocalizedString("SELECCIONARCATEGORIA",comment:"Selecciona Categoría")
        addIngredientLb.text = NSLocalizedString("AÑADENOMBREINGREDIENTE",comment:"Añade un nombre a tu ingrediente")
    }
    
    func categoryInit(){
        
        let filePath = NSBundle.mainBundle().pathForResource("Category", ofType: "json")
        
        let jsonData = NSData.init(contentsOfFile: filePath!)
        
        do {
            let objOrigen = try NSJSONSerialization.JSONObjectWithData(jsonData!,
                options: [.MutableContainers, .MutableLeaves]) as! [String:AnyObject]
            
            for category in objOrigen["Categories"] as! [[String:AnyObject]] {
                items.append(category["category"] as! String)
            }
            
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        ingredientTv.resignFirstResponder()
        return true
    }
    
    
    @IBAction func saveAction(sender: AnyObject) {
        let newIngredient = Ingredient()
        if let text = ingredientTv.text where !text.isEmpty{
            newIngredient.name = ingredientTv.text!
            let fila = picker.selectedRowInComponent(0)
            print(items[fila])
            newIngredient.category = items[fila]
            newIngredient.baseType = ingredientTv.text!
            
            addIngredient(newIngredient)
            let viewControllers = (self.navigationController?.viewControllers)! as [UIViewController]
            print(viewControllers.count)
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 2 ], animated: true)
        } else  {
            let ac = UIAlertController(title: NSLocalizedString("INGREDIENTEVACIO",comment:"El campo ingrediente está vacío"), message: NSLocalizedString("REQUISITOTEXTO",comment:"Es necesario que el ingrediente tenga un nombre"), preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        
        }
        
    }
    
    func addIngredient(ingredient: Ingredient) {
        
        do{
            ingredient.storageId = 1
            ingredientId =  try IngredientDataHelper.insert(ingredient)
            
            print(ingredientId)
        }catch _{
            print("Error al crear el ingrediente")
        }
    }
    

}
