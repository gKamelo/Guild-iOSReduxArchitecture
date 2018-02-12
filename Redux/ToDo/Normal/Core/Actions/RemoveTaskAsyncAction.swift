//
//  RemoveTaskAsyncAction.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

struct RemoveTaskAsyncAction {

    let networkService: NetworkService

    let index: Int
    let identifier: Int

    func remove() -> Store<AppState>.ActionCreator {
        return { state, store in
            store.dispatch(RemoveTaskAction(index: self.index))

            let removeTask = RemoveTaskNetworkTask(identifier: self.identifier)

            self.networkService.fetch(for: removeTask, success: { _ in
                //
            })

            return nil
        }
    }
}
