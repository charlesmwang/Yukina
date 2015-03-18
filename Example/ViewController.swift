import UIKit
import Yukina

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTapped(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        YKConnection.send(urlString: "/messages?al_applink_data=%7B%22user_agent%22%3A%22Bolts%20iOS%201.0.0%22%2C%22target_url%22%3A%22http%3A%5C%2F%5C%2Fexample.com%5C%2Fapplinks%22%2C%22extras%22%3A%7B%22myapp_token%22%3A%22t0kEn%22%7D%7D", router: appDelegate.router) { (response) -> Void in
            var alertView: UIAlertView? = response.data["alertView"] as? UIAlertView
            if let alertView = alertView {
                alertView.show()
                alertView.dismissWithClickedButtonIndex(0, animated: true)
            }
            alertView = nil
            
            println(response.request.routePath)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

