//
//  GetTasksAction.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

struct GetTasksAsyncAction {

    let networkService: NetworkService

    /// COMMENT:
    /// One of possible ways to do asynchronous operatation,
    /// callback will be executed at the end of operation,
    /// latest state and store will be passed to create Action based on that
    ///
    /// Probably prefered way to do async actions due to up to date data passed to
    func fetch() -> Store<AppState>.AsyncActionCreator {
        return { _, store, callback in
            let allTask = AllTaskNetworkTask()

            /// Could be dispatched inside particular contoller
            /// for better separation of concerns
            store.dispatch(LoadingTasksAction())

            self.networkService.fetch(for: allTask, success: { tasks in
                callback({ _, _ in SetTasksAction(tasks: tasks) })
            })
        }
    }
}
