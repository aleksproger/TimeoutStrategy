import Foundation

final class TimeoutStrategyDefault<R>: TimeoutStrategy {   
    typealias BlockResult = R
    typealias TimerCompletion = (Timer) -> Void

    private let timeout: Int
    private let makeTimer: (@escaping TimerCompletion) -> Timer
    private let makeDispatchSemaphore: () -> DispatchSemaphore

    init(timeout: TimeInterval) {
        self.timeout = Int(timeout)
        self.makeTimer = { completion in Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: completion) }
        self.makeDispatchSemaphore = { DispatchSemaphore(value: 0) }
    }

    func execute(
        _ asyncBlock: @escaping (@escaping (Result<BlockResult, Error>) -> Void) -> Void
    ) -> Result<BlockResult, Error> {
        let semaphore = makeDispatchSemaphore()
        var blockResult: Result<BlockResult, Error>?
        
        asyncBlock() { result in
            blockResult = result
            semaphore.signal()
        }

        guard case .success = semaphore.wait(timeout: .now() + .seconds(timeout)),
                let result = blockResult else {
            return .failure(TimeoutStrategyError.timeout)
        }
        return result
    }

    func execute(
        _ asyncBlock: @escaping (@escaping (Result<BlockResult, Error>) -> Void) -> Void,
        completion: @escaping (Result<BlockResult, Error>) -> Void
    ) {
        let timer = makeTimer() { timer in
            timer.invalidate()
            completion(.failure(TimeoutStrategyError.timeout))
        }

        asyncBlock() { result in
            timer.invalidate()
            completion(result)
        }
    }
}