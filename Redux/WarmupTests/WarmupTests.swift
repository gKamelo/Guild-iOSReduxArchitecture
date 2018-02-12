//
//  WarmupTests.swift
//  WarmupTests
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import XCTest
import ReSwift

@testable import Warmup

class WarmupTests: XCTestCase {

    private var sut: Store<GameState>!

    override func setUp() {
        super.setUp()

        self.sut = Store(reducer: gameReducer.reducer, state: nil)
    }

    func test_restartAction_willSetDefaultValues() {
        let restartAction = RestartAction()

        self.sut.dispatch(restartAction)

        XCTAssertEqual(self.sut.state.currentPlayer, .cross)
        XCTAssertEqual(self.sut.state.turns.count, 0)
    }

    func test_turnAction_willAddTurnAndMoveToNextPlayer() {
        let turnAction = TurnAction(position: Turn.Position(column: 0, row: 0))

        self.sut.dispatch(turnAction)

        XCTAssertEqual(self.sut.state.currentPlayer, .circle)
        XCTAssertNotNil(self.sut.state.turns.first)
    }

    // ... and many more;)
}
