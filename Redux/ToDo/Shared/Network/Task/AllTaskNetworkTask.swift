//
//  AllTaskNetworkTask.swift
//  ToDo
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import Foundation

struct AllTaskNetworkTask: NetworkTask {

    let endPoint = "tasks"

    func parse(_ data: Any) -> [Task]? {
        guard let jsons = data as? [JSON] else { return nil }

        return jsons.compactMap { Task(json: $0) }
    }
}
