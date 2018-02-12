//
//  AppDelegate.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import UIKit
import ReSwift

let store = Store<AppState>(reducer: reducer, state: nil, middleware: [printActions])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

/// COMMENT:
/// We can create our own man-in-the-middle to intercept actions
/// and do what we want, sth similar to back-end middlewares
/// Just to show what actions were executed during app lifetime
let printActions: Middleware<AppState> = { _, _ in
    return { next in
        return { action in
            print(type(of: action))

            return next(action)
        }
    }
}
