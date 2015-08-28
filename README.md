# TextFieldValidator
This is a TextFieldValidator class developed in swift.
To use these validations all you need to do is just pass boolean value to one of the setter methods to enable a particular kind of validation. 

#Example
```
txtField.setFlagForAllowNumbersOnly(true)
```
you can also set the alert for the validation. For that, you need to set the delegate property of TextFieldValidator.

```
01  txtField1.ParentDelegate = self
02  txtField1.allowToShowAlertView = true
03  txtField1.showAlertForNumberOnly("alert", message: "numbers only", buttonTitles: ["abc","ccc"], buttonActions: ["method1","method2"])

04 func method1()
    {
        println("method 1 called")
    }
    func method2()
    {
        println("method2  called")
    }  
```

0. 01: Here we set the delegate of TextFieldValidator.
0. 02: Here we enable the alert to show.
0. 03: Here we set the "Title" and "Message" for the alertController. You can pass the button titles array and button actions array respectively to show buttons on alertController.
0. P.S. Make sure button actions are implemented in your viewController class.
0. 04: implemented methods in ViewController.
