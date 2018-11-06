# iOS Redux Architecture

![Xcode version](https://img.shields.io/badge/Xcode-10.0-blue.svg)
![Swift version](https://img.shields.io/badge/Swift-4.2-blue.svg)
![Swiftlint version](https://img.shields.io/badge/Swiftlint-0.24.2-blue.svg)

Part of brown bag/guild meeting to present [Redux](https://redux.js.org) concept on iOS platform.

## General

There are two main elements in repository.

* Xcode project for Redux samples
* [Vapor](https://vapor.codes) service to imitate network service.

### Project overview

Project contains 3 examples of redux applications.

* **Warmup** - Simple Tic-Tac-Toe game, which shows Redux in its simplest form without asynchronous complications.
* **ToDo** - To do application from [previous repository](https://github.com/gKamelo/Guild-iOSUIArchitectures) adjusted to Redux state managment. It extends warmup usage of this pattern/architecture to present how to handle asynchronous code and more complex applications.
* **ToDo Router** - Extension of ToDo application to present how to tackle navigation in Redux manner.

All samples are based on [ReSwift](https://github.com/ReSwift/ReSwift) library, which try to be aligned with web implementation. Under `COMMENT` mark there could be found more information about particular code usage and what assumption were adopted.

### Execution

In order to launch applications, please follow below steps.

#### Vapor service

* Install [Vapor toolbox](https://docs.vapor.codes/2.0/getting-started/toolbox/)
* Open Terminal in root folder and execute
```bash
$ cd TasksService
$ vapor build
$ vapor run
```

#### Project setup

* Install [Carthage](#swift-binary-framework-download-compatibility) to resolve project dependcies
* Open Terminal in root folder and execute
```bash
$ cd Redux
$ carthage update --platform iOS
```

#### Redux project

Open Redux Xcode project and run one of the targets

* Warmup
* ToDo (requires Vapor)
* ToDo Router (requires Vapor)

## License

Code is released under the MIT license. See [LICENSE](LICENSE) for details.
