//
//  AppRoutes.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import UIKit
import ReSwiftRouter

/// COMMENT:
/// Bit of magic, it is still experimental extension
/// See comments inside controllers
final class AppRoutes: Routable {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    /// COMMENT:
    /// Executed when we change top router on our virtual stack (Routes)
    func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        completionHandler()

        return self
    }

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {
        completionHandler()

        if routeElementIdentifier == TasksViewController.identifier {
            completionHandler()
            return self
        } else if routeElementIdentifier == CreateTaskViewController.identifier {
            let createController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: routeElementIdentifier)
            self.navigationController?.present(createController, animated: animated, completion: completionHandler)
        } else if routeElementIdentifier == DetailTaskViewController.identifier {
            let taskController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: routeElementIdentifier)
            self.navigationController?.pushViewController(taskController, animated: animated, completion: completionHandler)
        } else {
            fatalError("We shouldn't be here")
        }

        return CreateTaskRoute()
    }

    func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) {

        if routeElementIdentifier == CreateTaskViewController.identifier {
            self.navigationController?.dismiss(animated: true, completion: completionHandler)
        } else if routeElementIdentifier == DetailTaskViewController.identifier {
            /// Pop was done on controller side, Apple controllers navigation "feature"
            completionHandler()
        } else {
            fatalError("We shouldn't be here")
        }
    }
}

final class CreateTaskRoute: Routable { }
