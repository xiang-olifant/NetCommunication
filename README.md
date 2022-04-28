# NetCommunication
> Lightweight network manager in Swift with Combine

### Platform
* iOS v15
* macOS v12
* watchOS v8
* tvOS v15


## Installation

Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/xiang-olifant/NetCommunication.git", majorVersion: 1, minor: 0)
    ]
)
```


## Usage example


```swift
import NetCommunication
struct MyEndpoint: Endpoint {
    var baseURL: String { return "xxx.com" }
    var path: String?
    var scheme: URLScheme { return .https }
    var queryItems: [URLQueryItem]?
    var headers: [String: String]?
}

class MyService {
    let endpoint = MyEndpoint()
    
    func getFromAPI() -> AnyPublisher<Data, Error> {
        return NetworkManager
            .fetch(type: Model.self, with: endpoint)
            .tryMap { [weak self] result -> Data in
                return data
            }
            .eraseToAnyPublisher()
    }
}
```


## Release History

* 0.1.0
    * CHANGE: Added basic protocols and classes
