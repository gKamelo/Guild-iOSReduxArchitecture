//
//  TaskCreationReducer.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

func taskCreationReducer(action: Action, state: TaskCreationViewState?) -> TaskCreationViewState {
    var state = state ?? .ready

    switch action {
        case _ as CreatingTaskAction:
            state = .creating
        case _ as AddTaskAction:
            state = .ready
        default:
            break
    }

    return state
}
