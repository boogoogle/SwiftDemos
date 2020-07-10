//
//  ContentView.swift
//  SwiftDemos
//
//  Created by Boo on 6/23/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var offset = CGSize.zero
    @State private var offsetY: CGFloat =  60
    // 当发送完消息时, 更新消息列表的offset, 使之显示
    // 然后监听消息列表的tap事件,一旦tap,则把这个offset置为0, 不然滚动会受到影响
    // 新版本的swiftui 会加入滚动到底部的功能,啥时候出呢???
    
    
    
    var body: some View {
        VStack {
            Text("offset")
                .padding()
                .background(Color.red)
                .onTapGesture {
                    self.offsetY = -60
            }
            GeometryReader { geo in
                ScrollView{
                    VStack {
                        ForEach(1..<100){ i in
                            Text("\(i)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .border(Color.red)
                                .frame(height: 60)
                        }.offset(y: self.offsetY)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                self.offset = gesture.translation
                                print(self.offset)
                        }
                        .onEnded { _ in
                            if abs(self.offset.width) > 100 {
                                // remove the card
                            } else {
                                self.offset = .zero
                            }
                        }
                    )
                }

            }
            
            Text("Hello, World!")
                .frame(width: 200, height: 100)
                .background(Color.red)
                .padding()
                .onTapGesture {
                    self.offsetY = 0
            }
//                .offset(offset)
//                .gesture(
//                    DragGesture()
//                        .onChanged{ gesture in
//                            self.offset = gesture.translation
//                            print(self.offset)
//                        }
//                        .onEnded { _ in
//                            if abs(self.offset.width) > 100 {
//                                // remove the card
//                            } else {
//                                self.offset = .zero
//                            }
//                        }
//            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
