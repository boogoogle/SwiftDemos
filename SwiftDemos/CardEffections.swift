//
//  CardEffections.swift
//  SwiftDemos
//
//  Created by Boo on 6/30/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct CardEffections: View {
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack{
            ZStack{
                ForEach(0..<3){ i in
                    Card(index: i)
                        .offset(x: -20 + CGFloat(40 * i), y: CGFloat(40 * i))
                }.gesture(
                    DragGesture()
                    .onChanged{ gesture in
                        self.offset = gesture.translation
                        print()
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
//            ZStack{
//                Card(index: 1)
//                Card(index: 2)
//                    .offset(x: 40)
//                Card(index: 3)
//                    .offset(x: 80)
//            }
            
        }
    }
}

struct CardEffections_Previews: PreviewProvider {
    static var previews: some View {
        CardEffections()
    }
}

struct Card: View {
    var index: Int
    var body: some View {
        HStack{
            Text("\(index)").font(.title)
            Text("Card Body").font(.title)
            Spacer()
        }.foregroundColor(.white)
        .frame(width: 240, height: 200)
        .padding()
        .background(Color.blue)
        .clipShape(Rectangle())
        .cornerRadius(18.0)
        .shadow(radius: 8.0)
    }
}
