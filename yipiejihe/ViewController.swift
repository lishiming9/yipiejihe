//
//  ViewController.swift
//  yipiejihe
//
//  Created by HaoNi on 09/06/2017.
//  Copyright © 2017 HaoNi. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    @IBOutlet var _username: UITextField!
    @IBOutlet var _password: UITextField!
    @IBOutlet var _login_button: UIButton!
    @IBOutlet var _textmessage: UITextField!
    @IBOutlet var _targetemail: UITextField!
    @IBOutlet var _tag: UITextField!
    
    public var sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "session") != nil){
            LoginDone()
        }
        else{
            LoginToDo()
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButton(_ sender: Any) {
        if(_login_button.titleLabel?.text == "Logout"){
            let preferences = UserDefaults.standard
            preferences.removeObject(forKey: "session")
            
            LoginToDo()
            return
        }
        
        let username = _username.text
        let password = _password.text
        
        if(username == "" || password == ""){
            return
        }
        
        DoLogin1(username!,password!)
    }
    
    @IBAction func MessageButton(_ sender: Any) {
        SendMessage()
    }
    func DoLogin1(_ user:String, _ psw:String){
        let parameters = [
            "email": "nih2@uci.edu",
            "password": "123456"]
        
        let delegate: Alamofire.SessionDelegate = sessionManager.delegate
        
        delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            print("REDIRECT Request: \(request)")
            if let url = request.url?.absoluteString {
                print("Extracted URL: \(url)")
            }
            delegate.taskWillPerformHTTPRedirection = nil // Restore redirect abilities
            let cookies = HTTPCookieStorage.shared.cookies
            print(cookies)
            return nil;

        }
        sessionManager.request("https://www.yipiejihe.com", method: .get, parameters: parameters).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            let cookies = HTTPCookieStorage.shared.cookies
            print("cookies: \(cookies)")
            self.sessionManager.request("https://www.yipiejihe.com/sessions", method: .post, parameters: parameters).response { response in
                print("Request: \(response.request)")
                print("Response: \(response.response)")
                print("Error: \(response.error)")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            }
        }
        
        
    }
    func SendMessage(){
        let url = URL(string: "https://www.yipiejihe.com/microposts")
        let session = URLSession.shared
        let cookies = HTTPCookieStorage.shared.cookies
        print(cookies)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let text = _textmessage.text
        let tag = _tag.text
        let email = _targetemail.text
        let paramToSend = "micropost[tag]=\(tag!)&micropost[content]=\(text!)&micropost[email]=\(email!)&commit=send"
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            print(error)
            print(response)
            print(String(data: data!, encoding: String.Encoding.utf8))
            guard let _:Data = data else
            {
                return
            }
            
            let json:Any?
            print(response)
        }
        task.resume()
    }
    
    func DoLogin(_ user:String, _ psw:String){
        let url = URL(string: "https://www.yipiejihe.com/sessions")
        let session = URLSession.shared
        //let session1 = URLSession(configuration: URLSessionConfiguration.default,
        //                           delegate: self as! URLSessionDelegate,
        //                        delegateQueue: nil)
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let paramToSend = "email=" + user + "&password=" + psw
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        print(String(data: request.httpBody!, encoding: String.Encoding.utf8))
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _:Data = data else
            {
                return
            }
            
            let json:Any?
            print(response)
            print(String(data: data!, encoding: String.Encoding.utf8))
            
            DispatchQueue.main.async (
                execute:self.LoginDone
            )
        }
        task.resume()
        
    }
    
    func LoginToDo(){
        _username.isEnabled = true;
        _password.isEnabled = true;
        
        _login_button.setTitle("Login", for: .normal)
        /*
        let url = URL(string: "https://www.yipiejihe.com/signout")
        let session = URLSession.shared
        let cookies = HTTPCookieStorage.shared.cookies
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "_method=delete"
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            print(error)
            print(response)
            print(String(data: data!, encoding: String.Encoding.utf8))
            guard let _:Data = data else
            {
                return
            }
            
            let json:Any?
            print(response)
        }
        task.resume()
        */
    }
    
    func LoginDone(){
        _username.isEnabled = false;
        _password.isEnabled = false;
        
        _login_button.setTitle("Logout", for: .normal)
    }

}

