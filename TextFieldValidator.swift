//
//  TextFieldValidator.swift
//  TextFieldValidator
//
//  Created by Anurag Kulkarni on 26/08/15.
//  Copyright (c) 2015 Anurag Kulkarni. All rights reserved.
//

import UIKit

let numberCharacterSet = NSCharacterSet.decimalDigitCharacterSet()

let alphabetCharacterSet : NSCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

let specialSymbolsCharacterSet : NSCharacterSet = NSCharacterSet(charactersInString: "!~`@#$%^&*-+();:=_{}[],.<>?\\/|\"\'")

class TextFieldValidator: UITextField,UITextFieldDelegate {
    
    //** properties which will decide which kind of validation user wants
   
    var ParentDelegate : AnyObject?
    
    var checkForEmptyTextField : Bool = false
    
    var allowOnlyNumbers : Bool = false
    
    var allowOnlyAlphabets : Bool = false
    
    var restrictSpecialSymbolsOnly : Bool = false
    
    var checkForValidEmailAddress : Bool = false
    
    var restrictTextFieldToLimitedCharecters : Bool = false
    
    var setNumberOfCharectersToBeRestricted : Int = 0
    
    var allowToShowAlertView : Bool = false
    
    var alertControllerForNumberOnly = UIAlertController()
    
    var alertControllerForAlphabetsOnly = UIAlertController()
    
    var alertControllerForSpecialSymbols = UIAlertController()
    
    var alertControllerForInvalidEmailAddress = UIAlertController()
    
    
    
  
    //MARK: awakeFromNib
   
    // Setting the delegate to class
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    //MARK: validation methods
    
     // 01. This method will check if there are any blank textFields in class
    
    class func checkIfAllFieldsAreFilled(view:UIView) -> Bool{

        var subviews : NSArray = view.subviews
        if(subviews.count == 0){
            return false
        }
        
        for currentObject in subviews{
            if let currentObject = currentObject as? UITextField {
                if(currentObject.text.isEmpty){
                 TextFieldValidator.shaketextField(currentObject)
                }
            }
              self.checkIfAllFieldsAreFilled(currentObject as! UIView)
        }
    
        return true
    }

   
    // 02. This method will check if there are any white space in the textField.
  
   class  func checkForWhiteSpaceInTextField(inputString : String) -> String{
        
        let trimmedString = inputString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        return trimmedString
    }
    
    // 03. This method will allow only numbers in the textField.
    
    func allowOnlyNumbersInTextField(string : String)->Bool{
        
        let numberCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
        let inputString = string
        let range = inputString.rangeOfCharacterFromSet(numberCharacterSet)
         println(inputString)
        // range will be nil if no numbers are found
        if let test = range {
            
          return true
        }
        else {
                return false
            // do your stuff
        }
       
    }
   
     // 04. This method will allow only alphabets in the textField.
    
    func allowOnlyAlphabetsInTextField(string : String)->Bool{
        
        let inputString = string
        let range = inputString.rangeOfCharacterFromSet(alphabetCharacterSet)
        println(inputString)
        // range will be nil if no alphabet are found
        if let test = range {
            
            return true
        }
        else {
          
            return false
            // do your stuff
        }
        
        
    }
    
     // 05. This method will restrict only special symbols in the textField.
    
    func restrictSpecialSymbols(string : String) -> Bool
    {
        let range = string.rangeOfCharacterFromSet(specialSymbolsCharacterSet.invertedSet)
        println(string)
        // range will be nil if no specialSymbol are found
        if let test = range {
            
            return true
        }
        else {
            
            return false
            // do your stuff
        }

    }
    
   

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(checkForValidEmailAddress){
            let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let range = textField.text.rangeOfString(emailReg, options:.RegularExpressionSearch)
            let result = range != nil ? true : false
            println(result)
            if(result){
                ParentDelegate as! UIViewController
                ParentDelegate!.presentViewController(alertControllerForInvalidEmailAddress, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       
        if(allowOnlyNumbers){
            if(string == ""){
                return true
            }
            var flag : Bool = self.allowOnlyNumbersInTextField(string)
            if(flag){
                return true
            }
            else{
                if(allowToShowAlertView){
                    ParentDelegate as! UIViewController
                    ParentDelegate!.presentViewController(alertControllerForNumberOnly, animated: true, completion: nil)
                    return false
                }
              
               
            }

        }
        else if(allowOnlyAlphabets){
            if(string == ""){
                return true
            }
            var flag : Bool = self.allowOnlyAlphabetsInTextField(string)
            if(flag){
                return true
            }
            else{
                if(allowToShowAlertView){
                    ParentDelegate as! UIViewController
                    ParentDelegate!.presentViewController(alertControllerForAlphabetsOnly, animated: true, completion: nil)
                    return false
                }
               
            }

        }
        else if(restrictSpecialSymbolsOnly){
            if(string == ""){
                return true
            }
            var flag : Bool = self.restrictSpecialSymbols(string)
            if(flag){
                return true
            }
            else{
                
                if(allowToShowAlertView){
                    ParentDelegate as! UIViewController
                    ParentDelegate!.presentViewController(alertControllerForSpecialSymbols, animated: true, completion: nil)
                    return false
                }
               
            }
            
        }
        else if(restrictTextFieldToLimitedCharecters){
            let newLength = count(textField.text) + count(string) - range.length
            return newLength <= setNumberOfCharectersToBeRestricted
        }

        else{
            return true
        }
        return false
    }
    
    //MARK: Setter methods
    func setFlagForAllowNumbersOnly(flagForNumbersOnly : Bool){
        allowOnlyNumbers = flagForNumbersOnly
    }
    func setFlagForAllowAlphabetsOnly(flagForAlphabetsOnly : Bool){
        allowOnlyAlphabets = flagForAlphabetsOnly
    }
    func setFlagForRestrictSpecialSymbolsOnly(RestrictSpecialSymbols : Bool){
        restrictSpecialSymbolsOnly = RestrictSpecialSymbols
    }
    func setFlagForcheckForValidEmailAddressOnly(flagForValidEmailAddress : Bool){
        checkForValidEmailAddress = flagForValidEmailAddress
    }
    
    func setFlagForLimitedNumbersOFCharecters(numberOfCharacters : Int,flagForLimitedNumbersOfCharacters : Bool){
        restrictTextFieldToLimitedCharecters = flagForLimitedNumbersOfCharacters
       setNumberOfCharectersToBeRestricted = numberOfCharacters
    }
    
    
    
    //MARK: show alert methods
   
    func showAlertForNumberOnly(title: String, message: String, buttonTitles : NSArray, buttonActions: NSArray){
        
        alertControllerForNumberOnly = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for(var i = 0 ; i < buttonActions.count; i++){
            var count = i
            let buttonAction = UIAlertAction(title: buttonTitles[count] as! String, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                if(buttonActions.count > 0){
                    let methodName = buttonActions[count] as! String
                    println(methodName)
                    NSTimer.scheduledTimerWithTimeInterval(0, target: self.ParentDelegate as! UIViewController, selector: Selector(methodName), userInfo: nil, repeats: false)
                }
            })
            alertControllerForNumberOnly.addAction(buttonAction)
        }
        
    }
    
    func showAlertForAlphabetsOnly(title: String, message: String, buttonTitles : NSArray, buttonActions: NSArray){
        
        alertControllerForAlphabetsOnly = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for(var i = 0 ; i < buttonActions.count; i++){
            var count = i
            let buttonAction = UIAlertAction(title: buttonTitles[count] as! String, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                if(buttonActions.count > 0){
                    let methodName = buttonActions[count] as! String
                    println(methodName)
                    NSTimer.scheduledTimerWithTimeInterval(0, target: self.ParentDelegate as! UIViewController, selector: Selector(methodName), userInfo: nil, repeats: false)
                }

                
            })
            alertControllerForAlphabetsOnly.addAction(buttonAction)
        }
        
    }
    
    func showAlertForSpecialSymbolsOnly(title: String, message: String, buttonTitles : NSArray, buttonActions: NSArray){
        
        alertControllerForSpecialSymbols = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        for(var i = 0 ; i < buttonActions.count; i++){
            var count = i
            let buttonAction = UIAlertAction(title: buttonTitles[count] as! String, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                if(buttonActions.count > 0){
                    let methodName = buttonActions[count] as! String
                    println(methodName)
                    NSTimer.scheduledTimerWithTimeInterval(0, target: self.ParentDelegate as! UIViewController, selector: Selector(methodName), userInfo: nil, repeats: false)
                }
                
                
            })
            alertControllerForSpecialSymbols.addAction(buttonAction)
        }
    }
    
        func showAlertForinvalidEmailAddrress(title: String, message: String, buttonTitles : NSArray, buttonActions: NSArray){
            
            alertControllerForInvalidEmailAddress = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            for(var i = 0 ; i < buttonActions.count; i++){
                var count = i
                let buttonAction = UIAlertAction(title: buttonTitles[count] as! String, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                    
                    if(buttonActions.count > 0){
                        let methodName = buttonActions[count] as! String
                        println(methodName)
                        NSTimer.scheduledTimerWithTimeInterval(0, target: self.ParentDelegate as! UIViewController, selector: Selector(methodName), userInfo: nil, repeats: false)
                    }
                    
                    
                })
                alertControllerForInvalidEmailAddress.addAction(buttonAction)
            }

    }
    
    //MARK: shake textField
  class  func shaketextField(textfield : UITextField){
        var shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        var from_point:CGPoint = CGPointMake(textfield.center.x - 5, textfield.center.y)
        var from_value:NSValue = NSValue(CGPoint: from_point)
        
        var to_point:CGPoint = CGPointMake(textfield.center.x + 5, textfield.center.y)
        var to_value:NSValue = NSValue(CGPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        textfield.layer.addAnimation(shake, forKey: "position")
 
        
    }


  
    
}
