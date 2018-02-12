//
//  GameStore.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

enum Player {

    static prefix func ! (current: Player) -> Player {
        return current == .cross ? .circle : .cross
    }

    case cross, circle
}

struct Turn {

    struct Position {

        let column: Int
        let row: Int
    }

    let player: Player
    let position: Position
}

struct GameState: StateType {

    enum Step {
        case start, turn, win, draw
    }

    var step: Step
    var currentPlayer: Player
    var infoText: String
    var turns: [Turn]
}
