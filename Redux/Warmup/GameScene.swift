//
//  GameScene.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import SpriteKit
import ReSwift

final class GameScene: SKScene {

    /// COMMENT:
    /// Usually defined in global scope
    /// for module code it could be kept in its scope
    /// but we lost Redux beauty then;)
    private let store = Store(reducer: gameReducer.reducer, state: nil)

    private let board = BoardNode(cellSize: GameConstant.cellSize)
    private let infoLabel = SKLabelNode()
    private let restartButton = LabelButtonNode(text: "Tap to restart")

    override func didMove(to view: SKView) {
        let realBoardSize = self.board.calculateAccumulatedFrame()

        self.board.position = CGPoint(x: -realBoardSize.width / 2, y: -realBoardSize.height / 2)
        self.board.actionDelegate = self

        self.infoLabel.fontColor = .green
        self.infoLabel.fontSize = GameConstant.textSize
        self.infoLabel.position = CGPoint(x: 0, y: -realBoardSize.height / 2 - (GameConstant.textGap + GameConstant.textSize))

        self.restartButton.fontSize = GameConstant.textSize
        self.restartButton.position = CGPoint(x: 0, y: -realBoardSize.height / 2 - 2 * (GameConstant.textGap + GameConstant.textSize))
        self.restartButton.isUserInteractionEnabled = true
        self.restartButton.delegate = self

        self.addChild(self.board)
        self.addChild(self.infoLabel)
        self.addChild(self.restartButton)

        self.store.subscribe(self)
        self.store.dispatch(RestartAction())
    }
}

// MARK: - BoardActionDelegate
extension GameScene: BoardActionDelegate {

    func boardAction(at field: BoardNode.Field) {
        let turnAction = TurnAction(position: Turn.Position(field: field))

        self.store.dispatch(turnAction)
    }
}

// MARK: - LabelActionDelegate
extension GameScene: LabelActionDelegate {

    func labelActionDidOccur() {
        self.store.dispatch(RestartAction())
    }
}

// MARK: - StoreSubscriber
extension GameScene: StoreSubscriber {

    func newState(state: GameState) {
        self.infoLabel.text = state.infoText

        switch state.step {
            case .start:
                self.board.clean()
                self.board.isUserInteractionEnabled = true
                self.restartButton.isHidden = true
            case .turn, .win, .draw:
                if let turn = state.turns.last {
                    let item = turn.player == .circle ? CircleNode(size: GameConstant.cellSize) : CrossNode(size: GameConstant.cellSize)

                    self.board.put(into: BoardNode.Field(position: turn.position), a: item)
                }
                self.board.isUserInteractionEnabled = (state.step == .turn)
                self.restartButton.isHidden = (state.step == .turn)
        }
    }
}

// MARK: - Data transform helpers
fileprivate extension BoardNode.Field {

    init(position: Turn.Position) {
        self.column = position.column
        self.row = position.row
    }
}

fileprivate extension Turn.Position {

    init(field: BoardNode.Field) {
        self.column = field.column
        self.row = field.row
    }
}
