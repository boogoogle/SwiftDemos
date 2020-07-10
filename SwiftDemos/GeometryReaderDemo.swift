//
//  GeometryReaderDemo.swift
//  SwiftDemos

//  [参考这里](https://www.jianshu.com/p/d020dfcdd210)
//
//  Created by Boo on 7/3/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct GeometryReaderDemo: View {
    var body: some View {
        VStack {
            Text("Hello There!")
            MyRectangle().background(Color.green)
            
            // 画个矩形条
            Rectangle()
                .frame(width: 60, height: 6)
                .cornerRadius(3.0)
                .opacity(0.1)
        }.frame(width: 150, height: 100).border(Color.black)
    }
}


struct MyRectangle: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .path(in: CGRect(x: geometry.size.width - 5,
                                 y: 0,
                                 width: geometry.size.width / 2.0,
                                 height: geometry.size.height / 2.0))
                .fill(Color.blue)
            
        }
    }
}

struct GeometryReaderDemo_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderDemo()
    }
}
