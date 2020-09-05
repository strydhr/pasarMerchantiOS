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
    private var bottomGroup = Group()
    
    private var barAnimations = [Animation]()
    var barsValues = [GroupedProduct]()
    var barsCaptions = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var barsCount = 7
    private let barsSpacing = 30
    private let barWidth = 20
    private let barHeight = 200
    
    var maxHeight = 200
    var maxCount = 0
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
        
        text.align = .min
        text.place = .move(dx: barsCenterX, dy: 30)
        
        let shape = Shape(form: Rect(0, 0, 150, 40))
        let title = Group(contents: [shape,text], place: .move(dx: barsCenterX + 150, dy: 30))
        
        
        //
        testGroup = Group()
        let xAxis = Line(0, 200, 275, 200).stroke(color: Color.black)
        let yAxis = Line(0, 0, 0, 200).stroke(color: Color.black)

        let yAxisText = Text(text: "\(maxCount)",font: Font(name: "Serif", size: 20),fill: Color.black, align: .max, baseline: .mid, place: .move(-5, 0))
        let dotedLine = Line(0, 0, 275, 0).stroke(color: Color.black.with(a: 0.25))
        testGroup.contents.append(dotedLine)
        
        testGroup.contents.append(yAxisText)
        testGroup.contents.append(xAxis)
        testGroup.contents.append(yAxis)
        testGroup.place = Transform.move(dx: barsCenterX, dy: 70)
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
        
        backgroundGroup.place = Transform.move(dx: barsCenterX, dy: 70)
        mainGroup.place = Transform.move(dx: barsCenterX, dy: 70)
        
        captionsGroup = Group()
        captionsGroup.place = Transform.move(
            dx: barsCenterX,
            dy: 80 + Double(barHeight)
        )
        for barIndex in 0...barsCount - 1 {
            let text = Text(
                text: "\(barsValues[barIndex].totalSales)",
                font: Font(name: "Serif", size: 14),
                fill: Color.black
            )
            text.align = .mid
            text.place = .move(
                dx: Double((barIndex * (barWidth + barsSpacing)) + barWidth / 2),
                dy: -10
            )
            captionsGroup.contents.append(text)
        }
        
        bottomGroup = Group()
        bottomGroup.place = Transform.move(
            dx: barsCenterX,
            dy: 90 + Double(barHeight)
        )
        let bottomspace = Text(
            text: " ",
            font: Font(name: "Serif", size: 14),
            fill: Color(val: 0xFFFFFF)
        )
        bottomspace.align = .mid
        bottomspace.place = .move(
            dx: Double((5 * (barWidth + barsSpacing)) + barWidth / 2),
            dy: 0
        )
        bottomGroup.contents.append(bottomspace)
        
        self.node = [mainGroup, captionsGroup, testGroup,bottomGroup].group()
        self.backgroundColor = UIColor.white
    }
    
    private func createAnimations() {
        barAnimations.removeAll()
        for (index, node) in mainGroup.contents.enumerated() {
            if let group = node as? Group {
//                let heightValue = self.barHeight / 100 * barsValues[index].totalSales
//                print(heightValue)
                let heightValue = (Double(barsValues[index].totalSales) / Double(maxCount)) * Double(barHeight)
                let colorClass = barsValues[index].colorClass
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
                        fill: self.colorPalette[colorClass]
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
