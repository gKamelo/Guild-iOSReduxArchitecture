//
//  AppDelegate.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRouter

let store = Store<AppState>(reducer: reducer, state: nil, middleware: [printActions])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: Router<AppState>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appRoutable = AppRoutes(navigationController: self.window?.rootViewController as? UINavigationController)

        router = Router(store: store, rootRoutable: appRoutable) { state in
            state.select { $0.navigationState }
        }

        store.dispatch(SetRouteAction([TasksViewController.identifier]))

        return true
    }
}

let printActions: Middleware<AppState> = { _, _ in
    return { next in
        return { action in
            print(type(of: action))

            return next(action)
        }
    }
}
