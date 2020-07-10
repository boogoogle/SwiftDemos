//
//  ListUpdates.swift
//  SwiftDemos
//
//  Created by Boo on 7/7/20.
//  Copyright © 2020 boo. All rights reserved.
//

import SwiftUI

struct ListUpdatesDemo: View {
    @State var items = Array(1...600)
    
    var body: some View {
        VStack {
            Button("Shuffle") {
                self.items.shuffle()
            }
            List(items, id: \.self) {
                Text("Item \($0)")
            }
//            .id(UUID())
        }
    }
        
        
}

struct ListUpdatesDemo_Previews: PreviewProvider {
    static var previews: some View {
        ListUpdatesDemo()
    }
}
