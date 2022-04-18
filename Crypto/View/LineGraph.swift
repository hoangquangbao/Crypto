//
//  LineGraph.swift
//  Crypto
//
//  Created by Quang Bao on 18/04/2022.
//

import SwiftUI

struct LineGraph: View {
    
    var data: [CGFloat]
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                
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
                    // Nên tasẽ đảo ngược sơ đồ lại và + thêm height để dịch chuyển biểu đồ xún
                    return CGPoint(x: pathWidth, y: -pathHeight + height)
                }
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
                    LinearGradient(colors: [Color("Gradient1"), Color("Gradient2")], startPoint: .leading, endPoint: .trailing)
                )
            }
        }
        .padding(.horizontal, 10)
    }
}
