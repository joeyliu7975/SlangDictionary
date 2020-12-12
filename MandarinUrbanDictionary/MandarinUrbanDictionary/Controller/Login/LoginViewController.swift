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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var appleLoginView: UIView!
            
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupGestures()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        addSubLayers()
        
    }

    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
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

private extension LoginViewController {
    
    func setup() {
        
        appleLoginView.setCorner(radius: 10.0)
        
    }
    
    func setupGestures() {
        
        appleLoginView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startSignInWithAppleFlow))
        
        appleLoginView.addGestureRecognizer(tapGesture)
        
    }
    
    func addSubLayers() {
        
        let appleImageLayer = CALayer()
        
        let appleTextLayer = JoeyTextLayer()
        
        let appleIconImage = UIImage(named: ImageConstant.appleIcon)?.cgImage
        
        appleImageLayer.frame = CGRect(x: 40, y: 12, width: 36, height: 36)
        
        appleTextLayer.frame = CGRect(x: 86, y: 12, width: 200, height: 36)
        
        appleTextLayer.fontSize = 24.0
        
        appleTextLayer.string = "Sign in with Apple"
        
        appleImageLayer.contents = appleIconImage
        
        appleLoginView.layer.addSublayer(appleImageLayer)
        
        appleLoginView.layer.addSublayer(appleTextLayer)
        
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = ""
        
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
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
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let database = Firestore.firestore()
                
                let favoriteWord: [String] = []
                
                let recentSearch: [String] = []
                
                database.collection("User").document(uid).setData([
                    "email": email,
                    "display_Name": displayName,
                    "id": uid,
                    "favorite_words": favoriteWord,
                    "recent_search": recentSearch
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        UserDefaults.standard.setValue(true, forKey: UserDefaults.keyForLoginStatus)
                        
                        let homeVC = ContainerViewController()
                        
                        homeVC.modalPresentationStyle = .fullScreen
                        
                        homeVC.modalTransitionStyle = .crossDissolve
                        
                        self.present(homeVC, animated: true)
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
