//
//  TasksState.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import Foundation

struct TasksState {

    enum ViewState {

        enum ReadyState {

            case all
            case add(Int)
            case remove(Int)
        }

        case empty, loading, ready(ReadyState)
    }

    var viewState: ViewState
    var tasks: [Task]
}

extension TasksState {

    init() {
        self.viewState = .empty
        self.tasks = []
    }
}

/// COMMENT:
/// To prevent from re-updates of store observers,
/// we can define equality for our current state,
/// which will be taken into account during changes of other part of store
/// Work out of the box due to skipRepeats() conformance
extension TasksState: Equatable {

    static func == (lhs: TasksState, rhs: TasksState) -> Bool {
        return lhs.tasks.count == rhs.tasks.count
            && lhs.viewState == rhs.viewState
    }
}

extension TasksState.ViewState: Equatable {

    static func == (lhs: TasksState.ViewState, rhs: TasksState.ViewState) -> Bool {
        switch (lhs, rhs) {
            case (.empty, .empty): return true
            case (.loading, .loading): return true
            case (.ready(let _state), .ready(let state_)): return _state == state_
            default: return false
        }
    }
}

extension TasksState.ViewState.ReadyState: Equatable {
    static func == (lhs: TasksState.ViewState.ReadyState, rhs: TasksState.ViewState.ReadyState) -> Bool {
        switch (lhs, rhs) {
            case (.all, .all): return true
            case (.add(let _position), .add(let position_)): return _position == position_
            case (.remove(let _position), .remove(let position_)): return _position == position_
            default: return false
        }
    }
}
