//
//  SceneDelegate.swift
//  EmailAuth
//
//  Created by Erich Flock on 26.04.22.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let viewController = ViewController()
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        window.rootViewController = navViewController
        
        self.window = window
        
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let webPageUrl = userActivity.webpageURL else { return }
        
        print("Universal Link: [\(webPageUrl)]")
        
        DynamicLinks.dynamicLinks().handleUniversalLink(webPageUrl) { dynamicLink, error in
            
            if let dynamicLinkUrl = dynamicLink?.url?.absoluteString,
                Auth.auth().isSignIn(withEmailLink: dynamicLinkUrl),
                let email = UserDefaults.standard.string(forKey: "Email") {
                
                Auth.auth().signIn(withEmail: email, link: dynamicLinkUrl) { [weak self] user, error in
                    
                    guard let navigationController = self?.window?.rootViewController as? UINavigationController,
                          let viewController = navigationController.topViewController as? ViewController else { return }
                    
                    if let error = error {
                        viewController.presentAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        viewController.presentAlert(title: "Success", message: "Signed in with UID: [\(user?.user.uid ?? "unknown uid")]")
                    }
                }
            }
            
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("OPEN URL: \(URLContexts.first?.url.description ?? "")")
    }
    
}

