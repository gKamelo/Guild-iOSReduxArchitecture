//
//  CrossNode.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import SpriteKit

final class CrossNode: SKNode {

    init(size: CGFloat, color: UIColor = .blue) {
        super.init()

        let firstDiagonalPath = UIBezierPath()

        firstDiagonalPath.move(to: .zero)
        firstDiagonalPath.addLine(to: CGPoint(x: size, y: size))
        firstDiagonalPath.close()

        let secondDiagonalPath = UIBezierPath()

        secondDiagonalPath.move(to: CGPoint(x: 0, y: size))
        secondDiagonalPath.addLine(to: CGPoint(x: size, y: 0))
        secondDiagonalPath.close()

        let firstDiagonal = SKShapeNode(path: firstDiagonalPath.cgPath)
        let secondDiagonal = SKShapeNode(path: secondDiagonalPath.cgPath)

        firstDiagonal.lineWidth = GameConstant.cellItemWidth
        firstDiagonal.strokeColor = color
        secondDiagonal.lineWidth = GameConstant.cellItemWidth
        secondDiagonal.strokeColor = color

        self.addChild(firstDiagonal)
        self.addChild(secondDiagonal)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
