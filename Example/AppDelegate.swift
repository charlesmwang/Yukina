import UIKit
import Yukina

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: YKRouter = YKRouter(middlewares: [AppLinkMiddleware.appLinkParser], routes: MessageRoutes.routes())

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
                
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        YKConnection.send(fromPublicURL: url, sourceApplication: sourceApplication, router: self.router) { (response: YKResponse) -> Void in
            println(sourceApplication)
            println("Handled in OpenURL")
        }
        
        return true
    }
}

