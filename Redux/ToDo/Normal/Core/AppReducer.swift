//
//  AppReducer.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

/// COMMENT:
/// We can descope different part of states to different reducers
/// Very helpful for bigger applications;)
func reducer(action: Action, state: AppState?) -> AppState {
    return AppState(tasksState: tasksReducer.reducer(action: action, state: state?.tasksState),
                    taskCreationViewState: taskCreationReducer(action: action, state: state?.taskCreationViewState))
}
