//
//  GameReducer.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

/// COMMENT:
/// Moved to separate global class, but usually defined as pure functions
let gameReducer = GameReducer()

final class GameReducer {

    private let patterns = [
        [(0, 0), (0, 1), (0, 2)],
        [(1, 0), (1, 1), (1, 2)],
        [(2, 0), (2, 1), (2, 2)],
        [(0, 0), (1, 0), (2, 0)],
        [(0, 1), (1, 1), (2, 1)],
        [(0, 2), (1, 2), (2, 2)],
        [(0, 0), (1, 1), (2, 2)],
        [(0, 2), (1, 1), (2, 0)]
    ]

    func reducer(action: Action, state: GameState?) -> GameState {
        var state = state ?? GameState()

        switch action {
        case let action as TurnAction:
            let turn = Turn(player: state.currentPlayer, position: action.position)

            state.currentPlayer = !state.currentPlayer
            state.turns.append(turn)

            if let winner = hasWinner(for: state.turns) {
                state.infoText = (winner == .cross) ? "Cross player won the game" : "Circle player won the game"
                state.step = .win
            } else if state.turns.count == 9 {
                state.infoText = "No winners ;("
                state.step = .draw
            } else {
                state.infoText = (state.currentPlayer == .cross) ? "Cross player is next" : "Circle player is next"
                state.step = .turn
            }
        case _ as RestartAction:
            state = GameState()
        default:
            break
        }

        return state
    }

    // MARK: - Internal magic check
    private func hasWinner(for turns: [Turn]) -> Player? {
        guard turns.count > 4 else { return nil }

        if check(for: turns, with: .cross) {
            return .cross
        } else if check(for: turns, with: .circle) {
            return .circle
        }

        return nil
    }

    private func check(for turns: [Turn], with player: Player) -> Bool {
        var board = [Array(repeating: 0, count: 3),
                     Array(repeating: 0, count: 3),
                     Array(repeating: 0, count: 3)]

        turns.filter { $0.player == player }
            .forEach { board[$0.position.row][$0.position.column] = 1 }

        let patternExtist = patterns.index { pattern -> Bool in
            return pattern.map({ board[$0.0][$0.1] }).reduce(1, { $0 * $1 }) == 1
        }

        return patternExtist != nil
    }
}

private extension GameState {

    init() {
        self.step = .start
        self.currentPlayer = .cross
        self.infoText = "Cross player should start"
        self.turns = []
    }
}
