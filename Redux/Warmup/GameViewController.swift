//
//  GameViewController.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Works nicely only for bigger devices xD
        let gameScene = GameScene(size: self.view.bounds.size)
        let gameView = self.view as? SKView

        gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameScene.scaleMode = .aspectFit

        gameView?.ignoresSiblingOrder = true

        gameView?.showsFPS = true
        gameView?.showsDrawCount = true

        gameView?.presentScene(gameScene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
