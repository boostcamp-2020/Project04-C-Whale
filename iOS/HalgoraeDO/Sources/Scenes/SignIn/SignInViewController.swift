//
//  SignInViewController.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/16.
//

import UIKit
import AuthenticationServices
import WebKit

class SignInViewController: UIViewController {
    
    private var webAuthSession: ASWebAuthenticationSession?

    @IBAction private func didTapNaverLogicButton(_ sender: UIButton) {
        guard let url = URL(string: "http://101.101.210.222:3000/api/user/oauth/naver"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        let callBackURLScheme = "halgoraedoios"
        webAuthSession = ASWebAuthenticationSession.init(url: url, callbackURLScheme: callBackURLScheme, completionHandler: { [weak self] (callBack:URL?, error:Error?) in

            guard error == nil, let successURL = callBack else {
                return
            }

            if let token = successURL.absoluteString.components(separatedBy: "=").last {
                AuthManager.shared.userToken = token
                self?.switchRootViewController()
            }
        })
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.start()
    }
    
    func switchRootViewController() {
        guard let rootNavigationController = storyboard?.instantiateViewController(identifier: "MenuNavigationController", creator: { (coder) -> UINavigationController? in
            return UINavigationController(coder: coder)
        }) else { return }
        view.window?.rootViewController = rootNavigationController
    }
}

extension SignInViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
