//
//  LineGraph.swift
//  Crypto
//
//  Created by Quang Bao on 18/04/2022.
//

import SwiftUI

struct LineGraph: View {
    
    var data: [Double]
    var isProfit: Bool = false
    
    @State var currentPlot: String = ""
    // Offset...
    @State var offset: CGSize = .zero
    
    @State var isShowPlot: Bool = false
    @State var translation: CGFloat = 0
    @GestureState var isDrag: Bool = false
    
    // Animation Graph
    @State var graphProgress: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            let height = proxy.size.height
            // Chiều rộng = kích thước ngang / (số phần tử - 1)
            let width = (proxy.size.width) / CGFloat(data.count - 1)
            
            let maxPoint = data.max() ?? 0
            let minPoint = data.min() ?? 0
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                
                // getting progress and multiplyinh with height...
                // ???
                // Its showing from 0
                // Making to show from minimum Amount
                // Khoảng không để hiển thị biểu đồ bây giờ nó đc gói gọn giữa giá trị min và max
                let progress = (item.element - minPoint) / (maxPoint - minPoint)
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
//                Path { path in
//
//                    // drawing the points...
//                    path.move(to: CGPoint(x: 0, y: 0))
//                    path.addLines(points)
//                }
//                .trimmedPath(from: 0, to: graphProgress)
//                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                AnimatedGraphPath(progress: graphProgress, points: points)
                .fill(
                    
                    // Gradient...
                    LinearGradient(colors: [
                        isProfit ? Color("Profit") : Color("Loss"),
                        isProfit ? Color("Profit") : Color("Loss")
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
//                .padding(.top,10)
                .opacity(graphProgress)
            }
            .overlay(
                
                // Drag Indicator...
                VStack(spacing: 0) {
                    
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.black)
                        .padding(.vertical,6)
                        .padding(.horizontal,1)
                        .background(.white,in: Capsule())
                    // Ta dời vị trí hiển thị của chỉ số đầu và cuối để ko bị che mất
                        .offset(x: translation < 10 ? 30 : 0)
                        .offset(x: translation > (proxy.size.width - 60) ? -30 : 0)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 1, height: 40)
                        .padding(.top)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 22, height: 22)
                        .overlay(
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 12, height: 12)
                        )
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 1, height: 55)
                }
                // Fixed Frame...
                // For Gesture Calculation...
                    .frame(width: 80, height: 170)
                // 170 / 2 = 85 - 15 => circle ring size...
                    .offset(y: 70)
                    .offset(offset)
                // Show Drag Indicator only has drag gesture
                    .opacity(isShowPlot ? 1 : 0)
                , alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture()
                .onChanged({ value in
                withAnimation { isShowPlot = true }
                // Mỗi lần kéo nó sẽ auto giật tới 1 khoảng.
                    // Trừ bớt 50 là ok
                    // Trừ 100 thì nó giật lui
                let translation = value.location.x
                    
                // Getting index...
                    let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                    currentPlot = "\(data[index].convertToCurrency())"
                    self.translation = translation
                // removing half width...
                offset = CGSize(width: points[index].x - 40, height: points[index].y - height) })
                     
                .onEnded({ value in
                withAnimation { isShowPlot = false }})
                    .updating($isDrag, body: { value, out, _ in
                        out = true
                    })
            )
        }
        .overlay(
            // Show min/max values on Graph
            VStack(alignment: .leading) {
                
                let max = data.max() ?? 0
                let min = data.min() ?? 0
                
                Text(max.convertToCurrency())
                    .font(.caption.bold())
                    .offset(y: -25)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(min.convertToCurrency())
                        .font(.caption.bold())
                    
                    Text("Last 7 Days")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .offset(y: 40)
            }
                .frame(maxWidth: .infinity, alignment: .leading)
        )
        .padding(.horizontal, 10)
        .onChange(of: isDrag) { newValue in
            if !isDrag { isShowPlot = false }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.8)){
                    graphProgress = 1
                }
            }
        }
        .onChange(of: data) { newValue in
            // MARK: ReAnimating When ever Plot Data Update
            // Load lại đường chỉ báo mỗi khi chuyển tab Coin
            graphProgress = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // duration: Time để load xong Line Graph
                withAnimation(.easeInOut(duration: 0.8)){
                    graphProgress = 1
                }
            }
        }
    }
    
    @ViewBuilder
    func FillBG() -> some View {
        
        // Background of Graph divide 10 parts. In there spend 6 parts for Color.clear
        let color = isProfit ? Color("Profit") : Color("Loss")
        LinearGradient(colors: [
            color.opacity(0.5),
            color.opacity(0.35),
            color.opacity(0.2),
        ]
                       + Array(repeating: color.opacity(0.05), count: 1)
                       + Array(repeating: Color.clear, count: 4)
                       , startPoint: .top, endPoint: .bottom)
    }
}

// MARK: Animated Path
struct AnimatedGraphPath: Shape {
    var progress: CGFloat
    var points: [CGPoint]
    var animatableData: CGFloat {
        get { return progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            // drawing the points...
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .trimmedPath(from: 0, to: progress)
        .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }
}
