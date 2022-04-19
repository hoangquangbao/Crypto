//
//  Home.swift
//  Crypto
//
//  Created by Quang Bao on 18/04/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    
    @StateObject var vm: CryptoViewModel = CryptoViewModel()

    @State var currentCoin: String = "BTC"
    @Namespace var animation
    
    var body: some View {
        VStack {
            if let coins = vm.coins, let coin = vm.currentCoin {
                HStack(spacing: 10) {
                    
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text(coin.name)
                            .font(.callout)
                        
                        Text(coin.symbol.uppercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                CustomControl(coins: coins)
                GraphView(coin: coin)
                Control()
            } else {
                ProgressView()
                    .tint(Color("LightGreen"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: Custom Segmented Control - 01:56
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        // Sample Data
//        let coins = ["BTC", "ETH", "BNB"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
//                ForEach (coins, id: \.self) { coin in
                ForEach (coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin.symbol.uppercased() {
                                Rectangle()
                                    .fill(Color("Tab"))
                                // Make an effect a single view moving from its old position to its new position
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            vm.currentCoin = coin
                            withAnimation {
                                currentCoin = coin.symbol.uppercased()
                            }
                        }
                }

            }
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
            .padding(.vertical)
            .padding(.horizontal, 1)
        }
    }
    
    // MARK: Line Graph
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View {
        GeometryReader { _ in
            LineGraph(data: coin.last7DaysPrice.price)
        }
        .padding(.vertical, 30)
        .padding(.bottom, 20)
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
