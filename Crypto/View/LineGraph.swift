//
//  LineGraph.swift
//  Crypto
//
//  Created by Quang Bao on 18/04/2022.
//

import SwiftUI

struct LineGraph: View {
    
    var data: [CGFloat]
    
    @State var currentPlot = ""
    // Offset...
    @State var offset: CGSize = .zero
    
    @State var showPlot = false
    @State var translation: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            let height = proxy.size.height
            // Chiều rộng = kích thước ngang / (số phần tử - 1)
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0) + 100
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                // getting progress and multiplyinh with height...
                // ???
                let progress = item.element / maxPoint
                let pathHeight = progress * height
                
                // width...
                let pathWidth = width * CGFloat(item.offset)
                
                //                    return CGPoint(x: pathWidth, y: pathHeight)
                
                // Since we need peak to top not bottom...
                // y = Giá trị càng lớn thì nó sẽ nằm phía dưới vì đó là cách hiển thị của màn hình
                // Nên ta sẽ đảo ngược sơ đồ lại và + thêm height để dịch chuyển biểu đồ xún
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                // Converting plot as points...
                
                // Path....
                Path { path in
                    
                    // drawing the points...
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .fill(
                    
                    // Gradient...
                    LinearGradient(colors: [
                        Color("Gradient1"),
                        Color("Gradient2")
                    ], startPoint: .leading, endPoint: .trailing)
                )
                
                // Path Background Coloring...
                FillBG()
                // Clipping the shape...
                .clipShape(
                    Path { path in
                        
                        // drawing the points...
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: proxy.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                )
                .padding(.top,10)
            }
            .overlay(
                
                // Drag Indicator...
                VStack(spacing: 0) {
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .background(Color("Gradient1"),in: Capsule())
                    // Ta dời vị trí hiển thị của chỉ số đầu và cuối để ko bị che mất
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color("Gradient1"))
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 12, height: 12)
                        )
                    
                    Rectangle()
                        .fill(Color("Gradient1"))
                        .frame(width: 1, height: 55)
                }
                // Fixed Frame...
                // For Gesture Calculation...
                    .frame(width: 80, height: 170)
                // 170 / 2 = 85 - 15 => circle ring size...
                    .offset(y: 70)
                    .offset(offset)
                // Show Drag Indicator only has drag gesture
                    .opacity(showPlot ? 1 : 0)
                , alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture()
                .onChanged({ value in
                withAnimation { showPlot = true }
                // Mỗi lần kéo nó sẽ auto giật tới 1 khoảng.
                    // Trừ bớt 50 là ok
                    // Trừ 100 thì nó giật lui
                let translation = value.location.x
                    
                // Getting index...
                    let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                currentPlot = "$ \(data[index])"
                    self.translation = translation
                // removing half width...
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height) })
                     
                .onEnded({ value in
                withAnimation { showPlot = false }})
            )
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        LinearGradient(colors: [
            Color("Gradient2").opacity(0.3),
            Color("Gradient2").opacity(0.2),
            Color("Gradient2").opacity(0.1),
        ]
                       + Array(repeating: Color("Gradient1").opacity(0.1), count: 4)
                       + Array(repeating: Color.clear, count: 2)
                       , startPoint: .top, endPoint: .bottom)
    }
}
