//
//  LabelButtonNode.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import SpriteKit

protocol LabelActionDelegate: class {

    func labelActionDidOccur()
}

final class LabelButtonNode: SKLabelNode {

    private weak var currentTouch: UITouch?

    var defaultColor = UIColor.white
    var highlightColor = UIColor.red

    weak var delegate: LabelActionDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentTouch = touches.first

        self.fontColor = self.highlightColor
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.fontColor = self.defaultColor
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first == self.currentTouch else { return }

        self.fontColor = self.defaultColor

        self.delegate?.labelActionDidOccur()
    }
}
