//
//  RemoveTaskNetworkTask.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import Foundation

struct RemoveTaskNetworkTask: NetworkTask {

    let identifier: Int

    let method = HTTPMethod.delete
    var endPoint: String {
        return  "tasks/\(self.identifier)"
    }

    func parse(_ data: Any) -> Bool? {
        return data as? Bool
    }
}
