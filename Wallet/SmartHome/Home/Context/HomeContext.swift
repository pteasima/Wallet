import Corridor

protocol HomeContext {
    typealias State = HomeAppState
    typealias Action = HomeAppAction
    var state: I<State> { get }
    var dispatch: (Action) -> () { get }
}

struct DefaultHomeContext: HomeContext {
    var state: I<HomeContext.State> { return driver.state }
    var dispatch: (HomeContext.Action) -> () { return driver.dispatch }

    private let driver: Driver<HomeContext.State, HomeContext.Action> = Driver(state: .sample, reduce: { print("another reducer");print($0, $1) })
}

private extension HasContext {
    typealias Context = HomeContext
//    static var `default`: Resolver<Self, HomeContext> {
//        return Resolver(context: DefaultHomeContext())
//    }
}
private extension HasInstanceContext where Self.Context == HomeContext {
    var state: I<HomeContext.State> { return resolve[\.state] }
    var dispatch: (HomeContext.Action) -> () { return resolve[\.dispatch] }
}

protocol HomeContextAware: HasInstanceContext where Self.Context == HomeContext {
}
extension HomeContextAware {
    static var `default`: Resolver<Self, HomeContext> {
        return Resolver(context: DefaultHomeContext())
    }
}
