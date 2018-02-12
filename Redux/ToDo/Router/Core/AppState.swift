//
//  AppState.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift
import ReSwiftRouter

struct AppState: StateType, HasNavigationState {

    var navigationState: NavigationState
    var tasksState: TasksState
    var taskCreationViewState: TaskCreationViewState
}
