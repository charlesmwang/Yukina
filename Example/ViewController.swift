import UIKit
import Yukina

class ViewController: UIViewController {

    @IBAction func buttonTapped(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        YKConnection.send(urlString: "/messages", router: appDelegate.router, responseHandler: { (response) -> Void in
            switch response.status {
                case .Error(let code, let reason):
                    let alertView = UIAlertView(title: "Failed", message: reason, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                case .Success(_, _):
                    let alertView = UIAlertView(title: "Success", message: "Success!", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
            }
        })
    }

}

