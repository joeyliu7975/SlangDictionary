//
//  LoginViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import Lottie

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var appleLoginView: UIView!
            
    @IBOutlet weak var termOfServiceButton: UIButton!
    
    fileprivate var currentNonce: String?
    
    lazy var animationView: UIView = {
        
       var animationView = AnimationView()
        
        animationView = .init(name: "loading_Lotties")
        
        animationView.frame = self.navigationController?.view.bounds ?? view.bounds
        
        animationView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = .loop
        
        animationView.play()
        
        return animationView
    }()
    
    private let notificationManager: NotificationCenterManager = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    @IBAction func tapAppleSignIn(_ sender: UIButton) {
        let nonce = String.makeID()
        
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
}

extension LoginViewController: NotificationRegister {
    func registerLocal() {
        
        notificationManager.registerLocal()
        
    }
}

private extension LoginViewController {
    
    func setup() {
        
        appleLoginView.setCorner(radius: 10.0)
        
        let underlineAttribute: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 18)!,
        ]
        
        let underlineAttributedString = NSAttributedString(string: "使用者條款", attributes: underlineAttribute)
                
        termOfServiceButton.setAttributedTitle(underlineAttributedString, for: .normal)
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            view.addSubview(animationView)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                  
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                
                _ = user.email ?? ""
                
                _ = user.displayName ?? ""
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let database = Firestore.firestore()
                
                let favoriteWord: [String] = []
                
                let recentSearch: [String] = []
                
                let discoveredWords: [String] = []
                
                database.collection("User").document(uid).setData([
                    "display_Name": uid,
                    "id": uid,
                    "favorite_words": favoriteWord,
                    "recent_search": recentSearch,
                    "discovered_words": discoveredWords,
                    "like_challenge": -1,
                    "post_challenge": -1,
                    "view_challenge": -1
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        
                        UserDefaults.standard.setValue(true, forKey: UserDefaults.keyForLoginStatus)
                        
                        UserDefaults.standard.setValue(uid, forKey: "uid")
                                                
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(to: .homepage)
                        
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
