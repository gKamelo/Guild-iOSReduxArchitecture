//
//  CreateTaskAsyncAction.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

struct CreateTaskAsyncAction {

    let networkService: NetworkService

    let title: String
    let description: String?
    let dueDate: Date?

    /// COMMENT:
    /// Another possiblity to create asynchronous operation
    func create() -> Store<AppState>.ActionCreator {
        return { _, store in
            let createTask = CreateTaskNetworkTask(name: self.title, description: self.description, dueDate: self.dueDate)

            store.dispatch(CreatingTaskAction())

            self.networkService.fetch(for: createTask, success: { task in
                store.dispatch(AddTaskAction(task: task))
            })

            return nil
        }
    }
}
