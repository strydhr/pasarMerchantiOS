//
//  PieChart.swift
//  ThePasarMerchant
//
//  Created by Satyia Anand on 02/09/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import Foundation
import Macaw

class PieChart: MacawView {
    open var completionCallback: (() -> ()) = { }
    
    private var backgroundGroup = Group()
    private var mainGroup = Group()
    private var captionsGroup = Group()
    private var testGroup = Group()
    
    private var barAnimations = [Animation]()
    var barsValues = [GroupedProduct]()
    var barsCaptions = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var barsCount = 7
    private let barsSpacing = 30
    private let barWidth = 10
    private let barHeight = 200
    
    var maxHeight = 200
    var maxCount = 10
    private let emptyBarColor = Color.rgba(r: 138, g: 147, b: 219, a: 0.5)
    private let gradientColor = LinearGradient(degree: 90, from: Color(val: 0xfc0c7e), to: Color(val: 0xffd85e))
    private let colorPalette = [0xf08c00, 0xbf1a04, 0xffd505, 0x8fcc16, 0xd1aae3].map { val in Color(val: val)}
    
    private func createScene() {
        let viewCenterX = Double(self.frame.width / 2)
        
        let barsWidth = Double((barWidth * barsCount) + (barsSpacing * (barsCount - 1)))
        let barsCenterX = viewCenterX - barsWidth / 2
        
        let text = Text(
            text: "Product Sales",
            font: Font(name: "Serif", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        text.align = .mid
        text.place = .move(dx: viewCenterX, dy: 30)
        
        //
        testGroup = Group()
        let xAxis = Line(0, 200, 275, 200).stroke(color: Color.white)
        let yAxis = Line(0, 0, 0, 200).stroke(color: Color.white)
        
//        if maxCount > 50{
//
//        }else if maxCount > 10 && maxCount <= 50{
//
//        }else{
//            for i in 1...barsCount{
//                let text = maxCount
//                let yAxisText = Text(text: <#T##String#>, font: <#T##Font?#>, fill: <#T##Fill?#>, stroke: <#T##Stroke?#>, align: <#T##Align#>, baseline: <#T##Baseline#>, kerning: <#T##Float#>, place: <#T##Transform#>, opaque: <#T##Bool#>, opacity: <#T##Double#>, clip: <#T##Locus?#>, mask: <#T##Node?#>, effect: <#T##Effect?#>, visible: <#T##Bool#>, tag: <#T##[String]#>)
//            }
//        }
        let yAxisText = Text(text: "\(maxCount)",font: Font(name: "Serif", size: 20),fill: Color.white, align: .max, baseline: .mid, place: .move(-5, 0))
        let dotedLine = Line(0, 0, 275, 0).stroke(color: Color.white.with(a: 0.25))
        testGroup.contents.append(dotedLine)
        
        testGroup.contents.append(yAxisText)
        testGroup.contents.append(xAxis)
        testGroup.contents.append(yAxis)
        testGroup.place = Transform.move(dx: barsCenterX, dy: 90)
        //
        
        backgroundGroup = Group()
//        for barIndex in 0...barsCount - 1 {
//            let barShape = Shape(
//                form: RoundRect(
//                    rect: Rect(
//                        x: Double(barIndex * (barWidth + barsSpacing)),
//                        y: 0,
//                        w: Double(barWidth),
//                        h: Double(barHeight)
//                    ),
//                    rx: 5,
//                    ry: 5
//                ),
//                fill: emptyBarColor
//            )
//            backgroundGroup.contents.append(barShape)
//        }
        
        mainGroup = Group()
        for barIndex in 0...barsCount - 1 {
            let barShape = Shape(
                form: RoundRect(
                    rect: Rect(
                        x: Double(barIndex * (barWidth + barsSpacing)),
                        y: Double(barHeight),
                        w: Double(barWidth),
                        h: Double(0)
                    ),
                    rx: 5,
                    ry: 5
                ),
                fill: gradientColor
            )
            mainGroup.contents.append([barShape].group())
        }
        
        backgroundGroup.place = Transform.move(dx: barsCenterX, dy: 90)
        mainGroup.place = Transform.move(dx: barsCenterX, dy: 90)
        
        captionsGroup = Group()
        captionsGroup.place = Transform.move(
            dx: barsCenterX,
            dy: 100 + Double(barHeight)
        )
        for barIndex in 0...barsCount - 1 {
            let text = Text(
                text: "1",
                font: Font(name: "Serif", size: 14),
                fill: Color(val: 0xFFFFFF)
            )
            text.align = .mid
            text.place = .move(
                dx: Double((barIndex * (barWidth + barsSpacing)) + barWidth / 2),
                dy: 0
            )
            captionsGroup.contents.append(text)
        }
        
        self.node = [text, backgroundGroup, mainGroup, captionsGroup, testGroup].group()
        self.backgroundColor = UIColor(cgColor: Color(val: 0x5B2FA1).toCG())
    }
    
    private func createAnimations() {
        barAnimations.removeAll()
        for (index, node) in mainGroup.contents.enumerated() {
            if let group = node as? Group {
//                let heightValue = self.barHeight / 100 * barsValues[index].totalSales
//                print(heightValue)
                let heightValue = (Double(barsValues[index].totalSales) / Double(maxCount)) * Double(barHeight)
                print("max : \(maxCount)")
                print("current : \(Double(maxCount) / Double(barsValues[index].totalSales))")
                let animation = group.contentsVar.animation({ t in
                    let value = Double(heightValue) / 100 * (t * 100)
                    let barShape = Shape(
                        form: RoundRect(
                            rect: Rect(
                                x: Double(index * (self.barWidth + self.barsSpacing)),
                                y: Double(self.barHeight) - Double(value),
                                w: Double(self.barWidth),
                                h: Double(value)
                            ),
                            rx: 5,
                            ry: 5
                        ),
                        fill: self.colorPalette[index]
                    )
                    return [barShape]
                }, during: 0.2, delay: 0).easing(Easing.easeInOut)
                barAnimations.append(animation)
            }
        }
    }
    
    open func play() {
        createScene()
        createAnimations()
        barAnimations.sequence().onComplete {
            self.completionCallback()
        }.play()
    }
}
