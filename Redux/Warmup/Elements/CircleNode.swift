//
//  CircleNode.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import SpriteKit

final class CircleNode: SKNode {

    init(size: CGFloat, color: UIColor = .red) {
        super.init()

        let circleShape = SKShapeNode(rectOf: CGSize(width: size, height: size), cornerRadius: size / 2)

        circleShape.lineWidth = GameConstant.cellItemWidth
        circleShape.strokeColor = color
        circleShape.position = CGPoint(x: size / 2, y: size / 2)

        self.addChild(circleShape)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
