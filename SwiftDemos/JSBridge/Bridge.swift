//
//  Bridge.swift
//  SwiftDemos
//
//  Created by Boo on 7/9/20.
//  Copyright © 2020 boo. All rights reserved.
//

import Foundation
import WebKit

public class Bridge: NSObject {
    private let iOS_Native_InjectJavascript = "iOS_Native_InjectJavascript"
    private let iOS_Native_FlushMessageQueue = "iOS_Native_FlushMessageQueue"
    
    private weak var webView: WKWebView?
    
    
    
    public init(webView: WKWebView) {
        super.init()
        self.webView = webView
//        base = WKWebViewJavascriptBridgeBase()
//        base.delegate = self
        addScriptMessageHandlers()
    }
    
    
    private func addScriptMessageHandlers() {
//        webView?.configuration.userContentController.add(LeakAvoider(delegate: self), name: iOS_Native_InjectJavascript)
//        webView?.configuration.userContentController.add(LeakAvoider(delegate: self), name: iOS_Native_FlushMessageQueue)
    }
}
