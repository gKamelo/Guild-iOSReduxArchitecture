//
//  TasksReducer.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import ReSwift

let tasksReducer = TasksReducer()

/// COMMENT:
/// There is no problem to wrap reducer in structure (no identity, stateless),
/// just to agregate helper methods
struct TasksReducer {

    func reducer(action: Action, state: TasksState?) -> TasksState {
        var state = state ?? TasksState()

        /// COMMENT:
        /// All app logic goes to reducers
        switch action {
            case _ as LoadingTasksAction:
                state.viewState = .loading
            case let setTasks as SetTasksAction:
                state.tasks = self.sortTasks(for: setTasks.tasks)
                state.viewState = setTasks.tasks.isEmpty ? .empty : .ready(.all)
            case let removeTask as RemoveTaskAction:
                if removeTask.index < state.tasks.count {
                    state.tasks.remove(at: removeTask.index)
                    state.viewState = state.tasks.isEmpty ? .empty : .ready(.remove(removeTask.index))
                }
            case let addTask as AddTaskAction:
                let position = self.add(to: &state.tasks, new: addTask.task)
                state.viewState = .ready(.add(position))
            default:
                break
        }

        return state
    }

    // MARK: - Helpers
    private func sortTasks(for tasks: [Task]) -> [Task] {
        return tasks.sorted(by: { first, second -> Bool in
            if let firstDate = first.dueDate,
                let secondDate = second.dueDate {
                return firstDate < secondDate
            } else if first.dueDate != nil || second.dueDate != nil {
                return true
            } else {
                return false
            }
        })
    }

    private func add(to tasks: inout [Task], new task: Task) -> Int {
        if let taskDate = task.dueDate, let taskIndex = tasks.index(where: { task -> Bool in
            if let dueDate = task.dueDate {
                return dueDate > taskDate
            } else {
                return true
            }
        }) {
            tasks.insert(task, at: taskIndex)

            return taskIndex
        } else {
            tasks.append(task)

            return tasks.count - 1
        }
    }
}
