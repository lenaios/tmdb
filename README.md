# Clean Architecture in Movie App

[iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)

## Clean Architecture
- Robert C Martin(Uncle Bob)이 제안한 App Architecture
- 바깥에서 안쪽으로 의존한다. 안쪽 원에서는 바깥 원에 대해 알지 못한다.

### Entities
가장 안쪽 원에 해당한다.
비즈니스 모델 객체로 이해하면 된다.

```swift
struct Movie: Decodable {
  let id: Int
  let title: String
  let poster: String
  let overview: String
  let release: String
  let average: Float
  let genre: [Genre.ID]
}
```

### Use Cases = Business Rules
- 앱에서 발생할 수 있는 비즈니스 로직
- Entity를 알고 있고, 비즈니스 로직에 의해 조합된 Entity를 리턴한다.
```swift
protocol MovieSearchUseCase {
  func search(query: String, completion: @escaping (Result<MoviesPage, Error>) -> Void)
}

final class DefaultMovieSearchUseCase: MovieSearchUseCase {
  let movieRepository: MovieRepository
  
  init(movieRepository: MovieRepository) {
    self.movieRepository = movieRepository
  }
  
  func search(query: String, completion: @escaping (Result<MoviesPage, Error>) -> Void) {
    movieRepository.fetch(query: query, completion: completion)
  }
}
```

### Interface Adapter = Controller, ViewModel
- UI에 표시하기 위한 데이터를 가공한다.
- UseCase를 알고 있고, UseCase로부터 얻은 entity를 외부(UI)에 용이한 형식(아래에선 Observable<[MovieItemViewModel]>)으로 변환한다.
```swift
class MoviesViewModel {
  let movieSearchUseCase: MovieSearchUseCase

  var items = Observable<[MovieItemViewModel]>(value: [])
  
  init(movieSearchUseCase: MovieSearchUseCase) {
    self.movieSearchUseCase = movieSearchUseCase
  }
  
  func load(query: String) {
    movieSearchUseCase.search(query: query) { result in
      switch result {
      case .success(let moviesPage):
        self.movies = moviesPage.movies
        self.items.value = moviesPage.movies.map { movie in
          MovieItemViewModel(
            title: movie.title,
            poster: movie.poster,
            rate: "\(movie.average)",
            genre: movie.genre.compactMap({ id in
              id.description
            }))
        }
      case .failure(let error):
        fatalError(error.localizedDescription)
      }
    }
  }
```

### DB, Network, External Interfaces (= Core Data...)
- 데이터베이스나 웹 프레임워크 등 외부 모듈과 연결하기 위한 코드를 작성하는 계층
- Alamofire와 관련된 코드를 작성한다면 여기에 포함된다.
```swift
protocol NetworkService {
  typealias Completion = (Result<Data, Error>) -> Void

  func request(_ request: URLRequest, completion: @escaping Completion) -> NetworkCancellable
}

final class DefaultNetworkService: NetworkService {
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func request(_ request: URLRequest, completion: @escaping Completion) -> NetworkCancellable {
    return session.dataTask(with: request) { data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error!))
        return
      }
      completion(.success(data))
    }
  }
}
```

Clean Architecture는 안쪽 원으로 갈수록 구체적인 정보를 담고 있고, 바깥으로 갈수록 추상화된 정보를 담는다.  
이러한 Architecture를 바탕으로 MVVM 패턴을 조합하여 데이터 흐름을 다음과 같이 표현할 수 있다.
```
View - View Model - Use Case - Repository - API, DB
 UI     Presenter    Domain      Data
Layer     Layer      Layer       Layer
```
각 Layer를 모듈화(Framework)할 수도 있다. [예제프로젝트](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/MVVM%20Modular%20Layers%20Pods.zip)

이렇게 계층을 분리(관심사 분리)하는 것은 처음 코드를 작성할 때 더 많은 양의 코드가 필요할 수 있지만,
코드의 분량이 많아졌을 때 구조를 쉽게 파악할 수 있는 장점이 있다.

[추가로 보면 좋은 레퍼런스](https://techblog.woowahan.com/2647/)
