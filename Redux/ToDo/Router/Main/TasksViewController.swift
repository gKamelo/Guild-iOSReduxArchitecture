//
//  TasksViewController.swift
//  Architecture
//
//  Copyright © 2017 Oink oink. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

final class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StoreSubscriber {

    static let identifier: String = "tasks"

    @IBOutlet private var emptyView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loaderIndicator: UIActivityIndicatorView!

    private let refreshControl = UIRefreshControl()

    private let networkServie = NetworkService(baseURL: AppConstant.networkURL)

    private var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.refreshControl = self.refreshControl

        self.refreshControl.addTarget(self, action: #selector(onReloadAction), for: .valueChanged)

        store.subscribe(self) { state in
            state.select { $0.tasksState }
        }

        store.dispatch(GetTasksAsyncAction(networkService: self.networkServie).fetch())
    }

    // MARK: - StoreSubscriber
    func newState(state: TasksState) {
        switch state.viewState {
            case .empty:
                self.emptyView.isHidden = false
                self.tableView.isHidden = true
                self.loaderIndicator.stopAnimating()
            case .loading:
                self.emptyView.isHidden = true
                self.tableView.isHidden = true
                self.loaderIndicator.startAnimating()
            case .ready(let innerState):
                self.tableView.isHidden = false
                self.emptyView.isHidden = true
                self.loaderIndicator.stopAnimating()

                self.updateReady(with: state, and: innerState)
        }
    }

    private func updateReady(with state: TasksState, and readyState: TasksState.ViewState.ReadyState) {
        switch readyState {
            case .all:
                self.tasks = state.tasks.sorted(by: { first, second -> Bool in
                    if let firstDate = first.dueDate,
                        let secondDate = second.dueDate {
                        return firstDate < secondDate
                    } else if first.dueDate != nil || second.dueDate != nil {
                        return true
                    } else {
                        return false
                    }
                })
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            case .add(let position):
                self.tasks.insert(state.tasks[position], at: position)
                self.tableView.insertRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
            case .remove(let position):
                self.tasks.remove(at: position)
                self.tableView.deleteRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
        }
    }

    // MARK: - Actions
    @objc private func onReloadAction() {
        store.dispatch(GetTasksAsyncAction(networkService: self.networkServie).fetch())
    }

    @IBAction func onCreateTaskAction(_ sender: UIBarButtonItem) {
        /// COMMENT:
        /// Simple route without actions,
        /// based on current stack [TasksViewController.identifier],
        /// we need to define next object on stack by defining whole list :(
        let toCreateRoute = SetRouteAction([TasksViewController.identifier, CreateTaskViewController.identifier], animated: true)

        store.dispatch(toCreateRoute)
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// COMMENT:
        /// To pass data we need to specify separate data Action,
        /// which need to be associated with route Action,
        /// then data could be retrieved during store subscription
        /// on to controller (a lot of indrections;/)
        let toDetail = SetRouteAction([TasksViewController.identifier, DetailTaskViewController.identifier])
        let toDetailData = SetRouteSpecificData(route: [TasksViewController.identifier, DetailTaskViewController.identifier], data: self.tasks[indexPath.row])

        store.dispatch(toDetailData)
        store.dispatch(toDetail)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, index in
            guard let `self` = self, indexPath == index else { return }

            let removeTaskAsyncAction = RemoveTaskAsyncAction(networkService: self.networkServie, index: index.row, identifier: self.tasks[index.row].id)

            store.dispatch(removeTaskAsyncAction.remove())
        }

        return [deleteAction]
    }

    // MARK: - UITablewViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]

        cell.textLabel?.text = task.name

        if let taskDate = task.dueDate {
            let timeLeft = taskDate.timeIntervalSince1970 - Date().timeIntervalSince1970

            if timeLeft < 0 {
                cell.backgroundColor = .red
            } else if timeLeft < 72 * 3600 {
                cell.backgroundColor = .orange
            } else {
                cell.backgroundColor = .white
            }
        } else {
            cell.backgroundColor = .white
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
}
