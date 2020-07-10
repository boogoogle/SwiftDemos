//
//  Demo4JSbridage.swift
//  SwiftDemos
//
//  Created by Boo on 7/9/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct Demo4JSbridage: View {
    @State var url: String = "http://10.67.84.228:9876"
    @State var webUrl: URL = URL(string: "https://www.baidu.com")!
    @State var showWebview: Bool = true
    var body: some View {
        VStack{
            HStack{
                TextField("输入地址", text: $url)
                Button(action:{
                    self.showWebview = false
                    self.webUrl = URL(string: self.url)!
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showWebview = true
                    }
                }){
                    Text("Go")
                }.frame(width: 60).background(Color.blue).foregroundColor(.white)
            }.frame(maxWidth: .infinity)
            
            VStack{
                if showWebview {
                    Webview(url: self.webUrl)
                } else {
                    Spacer()
                    Image(systemName: "timer").frame(width: 60, height: 60)
                }
                Spacer()
            }
        }
        
    }
}

struct Demo4JSbridage_Previews: PreviewProvider {
    static var previews: some View {
        Demo4JSbridage()
    }
}
