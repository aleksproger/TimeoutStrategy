import TimeoutStrategy

public final class TimeoutStrategyMock<R>: TimeoutStrategy {
    public typealias BlockResult = R

    public private(set) var blocks = [(@escaping (Result<R, Error>) -> Void) -> Void]()
    public private(set) var completions = [(Result<R, Error>) -> Void]()

    public init() {}

    public var result: Result<R, Error> = .failure(MockError())

    public func execute(
        _ asyncBlock: @escaping (@escaping (Result<R, Error>) -> Void) -> Void
    ) -> Result<R, Error> {
        blocks.append(asyncBlock)
        var blockResult = result
        asyncBlock({ res in blockResult = res })
        return blockResult
    }

    public func execute(
        _ asyncBlock: @escaping (@escaping (Result<R, Error>) -> Void) -> Void,
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        blocks.append(asyncBlock)
        completions.append(completion)
        asyncBlock(completion)
    }
}

private struct MockError: Error {}