//
//  Home.swift
//  Crypto
//
//  Created by Quang Bao on 18/04/2022.
//

import SwiftUI

struct Home: View {
    
    @State var currentCoin: String = "BTC"
    @Namespace var animation
    
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
            
            CustomControl()
            Control()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: Custom Segmented Control - 01:56
    @ViewBuilder
    func CustomControl() -> some View {
        // Sample Data
        let coins = ["BTC", "ETH", "BNB"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach (coins, id: \.self) { coin in
                    Text(coin)
                        .foregroundColor(currentCoin == coin ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin {
                                Rectangle()
                                    .fill(Color("Tab"))
                                // Make an effect a single view moving from its old position to its new position
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                currentCoin = coin
                            }
                        }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: Control Buttons
    @ViewBuilder
    func Control() -> some View {
        HStack(spacing: 20) {
            
            Button {
                
            } label: {
                Text("Sell")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color("LightGreen"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            Button {
                
            } label: {
                Text("Buy")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.white)
                    }
            }

        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
