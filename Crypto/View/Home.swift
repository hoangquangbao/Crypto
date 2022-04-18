//
//  Home.swift
//  Crypto
//
//  Created by Quang Bao on 18/04/2022.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("Bitcoin")
                        .font(.callout)
                    
                    Text("BTC")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
