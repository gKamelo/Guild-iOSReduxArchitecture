//
//  AppReducer.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift
import ReSwiftRouter

func reducer(action: Action, state: AppState?) -> AppState {
    return AppState(navigationState: NavigationReducer.handleAction(action, state: state?.navigationState),
                    tasksState: tasksReducer.reducer(action: action, state: state?.tasksState),
                    taskCreationViewState: taskCreationReducer(action: action, state: state?.taskCreationViewState))
}
