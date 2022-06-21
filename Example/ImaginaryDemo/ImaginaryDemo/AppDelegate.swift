import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var viewController: ViewController = ViewController()
    lazy var swiftUIViewController: SwiftUIViewController = SwiftUIViewController()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tabVC = UITabBarController()
        viewController.tabBarItem.title = "UIKit"
        swiftUIViewController.tabBarItem.title = "SwiftUI"
        tabVC.setViewControllers([viewController, swiftUIViewController], animated: true)
        
        window = UIWindow()
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
        
        return true
    }
}
