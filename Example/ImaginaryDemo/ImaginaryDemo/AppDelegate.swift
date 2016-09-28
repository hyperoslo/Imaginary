import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var viewController: ViewController = ViewController()

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let navigationController = UINavigationController(rootViewController: viewController)
    viewController.title = "Imaginary".uppercased()

    window = UIWindow()
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}
