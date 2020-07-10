//
//  Webview.swift
//  SwiftDemos
//
//  Created by Boo on 7/9/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI
import WebKit
// 核心WeView 容器
struct Webview: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        //
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        
        
        
//        let configuration = WKWebViewConfiguration()
//        let preferences = WKPreferences()
//        preferences.javaEnabled = true
//        configuration.userContentController = WKUserContentController()
        
        let webview = WKWebView()

//        let bridge = Bridge(webView: webview)
        
        webview.configuration.userContentController.add(userContentCtrl(delegate: webview), name: "yhBridge")
        
        
        webview.load(request)
        return webview
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webView.load(request)
    }
}

class userContentCtrl: NSObject {
    var delegate: WKWebView?
    var isLogEnable = true
    
    public var iOS_Native_InjectJavascript = "iOS_Native_InjectJavascript"
    public var iOS_Native_FlushMessageQueue = "iOS_Native_FlushMessageQueue"
    
    public typealias Message = [String: Any]
    
    // MARK: - JSON
    private func serialize(message: Message, pretty: Bool) -> String? {
        var result: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: pretty ? .prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0))
            result = String(data: data, encoding: .utf8)
        } catch let error {
            log(error)
        }
        return result
    }
    
    private func deserialize(messageJSON: String) -> Message? {
        var result = Message()
        guard let data = messageJSON.data(using: .utf8) else { return nil }
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Message
        } catch let error {
            log(error)
        }
        return result
    }
   
    init(delegate: WKWebView){
        super.init()
        self.delegate = delegate
    }
    /**
            把需要添加到webview中的js代码写到文件里, 然后注入
            演示期间: 先放入手动写好的js代码
     */
    func injectJavascriptFile() {
//        let js = WKWebViewJavascriptBridgeJS
//        delegate?.evaluateJavascript(javascript: js)
        
        let injectedJsScript = """
            
            window.yhBridge = {
                vibration: _postMessage('vibration')
        
            }

            function _postMessage(message, cb){
                window.webkit.messageHandlers.iOS_Native_FlushMessageQueue.postMessage(message)

            }

        """
        
    }
    
    
    // MARK: - Log
    private func log<T>(_ message: T, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        guard isLogEnable else {
            return
        }
        
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName):\(line) \(function) | \(message)")
        #endif
    }
    
}

extension userContentCtrl: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == self.iOS_Native_InjectJavascript {
//            print("iOS_Native_InjectJavascript")
//        }
//        if message.name == self.iOS_Native_FlushMessageQueue {
//            self.flushMessageQuene()
//        }
        
        
        
        let jsstr = "\(message.name)"
        print("message", jsstr)
        
        // 解析js传来的数据
//        let objFromJSInJSON = self.deserialize(messageJSON: message.body as! String)
        
        print(message.body, "----objFromJSInJSON---")
        var jsMessageBody = deserialize(messageJSON: message.body as! String)
        
        var actionName = jsMessageBody?["action"] as! String
        // 拿到native数据, json化
        let iosVersion = UIDevice.current.systemVersion //iOS版本
        let identifierNumber = UIDevice.current.identifierForVendor?.uuidString ?? "" //设备udid
        let systemName = UIDevice.current.systemName //设备名称
        let model = UIDevice.current.model //设备型号
        let modelName = UIDevice.current.model //设备具体型号
        let localizedModel = UIDevice.current.localizedModel //设备区域化型号如A1533
        
        var infoMessage = Message()
        infoMessage["iosVersion"] = iosVersion
        infoMessage["identifierNumber"] = identifierNumber
        infoMessage["systemName"] = systemName
        infoMessage["model"] = model
        infoMessage["modelName"] = modelName
        infoMessage["localizedModel"] = localizedModel
        
        guard var messageJSON = self.serialize(message: infoMessage, pretty: false) else {return}
        
        messageJSON = messageJSON.replacingOccurrences(of: "\\", with: "\\\\")
        messageJSON = messageJSON.replacingOccurrences(of: "\"", with: "\\\"")
        messageJSON = messageJSON.replacingOccurrences(of: "\'", with: "\\\'")
        messageJSON = messageJSON.replacingOccurrences(of: "\n", with: "\\n")
        messageJSON = messageJSON.replacingOccurrences(of: "\r", with: "\\r")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{000C}", with: "\\f")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        
        let jsScript = """

        app.message = "\(messageJSON)"
        window.yhBridgeCallbacks.successMap["\(actionName)"]("\(messageJSON)") // JSON数据仍然需要用引号""包裹一下,不然js会报错

"""
        self.delegate?.evaluateJavaScript(jsScript){ (result, err) in
            print(result, err, "---+++---")
        }
    }
}



