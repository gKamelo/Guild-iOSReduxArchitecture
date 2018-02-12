//
//  GetTasksAction.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

struct GetTasksAsyncAction {

    let networkService: NetworkService

    func fetch() -> Store<AppState>.AsyncActionCreator {
        return { _, store, callback in
            let allTask = AllTaskNetworkTask()

            store.dispatch(LoadingTasksAction())

            self.networkService.fetch(for: allTask, success: { tasks in
                callback({ _, _ in SetTasksAction(tasks: tasks) })
            })
        }
    }
}
