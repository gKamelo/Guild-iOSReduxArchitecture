//
//  DetailTaskViewController.swift
//  Architecture
//
//  Copyright © 2017 Oink oink. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

final class DetailTaskViewController: UIViewController, StoreSubscriber {

    static let identifier: String = "detailTask"

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var dueDateLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// COMMENT:
        /// Sad retriving data from current route :(
        store.subscribe(self) { state in
            state.select { state in
                let task: Task? = state.navigationState.getRouteSpecificState(state.navigationState.route)

                return task
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        store.unsubscribe(self)
    }

    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            /// COMMENT:
            /// Apple magic require to update the route,
            /// when VC was dismissed through back button from
            /// NavigationController, since we can't intercept the back button
            if store.state.navigationState.route == [TasksViewController.identifier, DetailTaskViewController.identifier] {
                store.dispatch(SetRouteAction([TasksViewController.identifier]))
            }
        }
    }

    // MARK: - StoreSubscriber
    func newState(state: Task?) {

        self.titleLabel.text = state?.name
        self.descriptionLabel.text = state?.description
        self.dueDateLabel.text = state?.dueDate?.description
    }
}
