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

            /// COMMENT:
            /// Tasks could be also moved to ready state
            /// That's the beauty of Redux, you can very easily model state to your needs
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
