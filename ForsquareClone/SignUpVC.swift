//
//  ViewController.swift
//  ForsquareClone
//
//  Created by Kaan Yalçınkaya on 20.12.2021.
//

//parse veri kaydetme. Dataları kayıt etmek için PFobject oluştur.

/*      let parsObject = PFObject(className: "Fruits")
parsObject["name"] = "Banana"
parsObject["calories"] = 150
//normal save yapmamamızın sebebi aseknron çalışmaması.Tercih etme. En güvenlisi saveinbackground
parsObject.saveInBackground { success, error in
    if error != nil {
        print(error?.localizedDescription)
    }
    else{
        print("uploaded")
    }
}



//parse veri çekmek için. PFquery oluştur.

let query = PFQuery(className: "Fruits")

//içerisideki bir veriyi çekmek için örnek olarak elma bunu kullanıyoruz.
 
//query.whereKey("name", equalTo: "Apple")

 //where key kullanımı.
 
query.whereKey("calories", greaterThan: 120)
 
//bir filtreleme işlemi varsa bunu kullan.Her zaman block olanı kullan.

query.findObjectsInBackground { objects, error in
    if error != nil {
        print(error?.localizedDescription)
    }
    else{
        //objects = diziler.
        print(objects)
        
*/


import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //aktif kullanıcı alma. (Current User)(Yaptığımız işlemleri "Scene Delegate içerisinde taşıdık.)
        
        let currentUser = PFUser.current()
        if currentUser != nil{
            performSegue(withIdentifier: "toPlacesVC", sender: nil)
            
        }
        
        
        
}
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != ""{
            
            //Eğer username password bilgilerini verdiyse ne yapıcağımız. Her zaman bunu kullan asenkron.
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Username // Password ??")
        }
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" {
            //Eğer username password boş değilse ne yapacağımız. PFuser oluşturacağız.
            
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            //asenkron olması için background kullan.
            user.signUpInBackground { success, error in
                if error != nil{
                    //self içerisinde kullanmamızın sebebi closure içerisinde olmamız.
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription ?? "Error!!")
                }
                else{
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        
        }
        else{
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
    




