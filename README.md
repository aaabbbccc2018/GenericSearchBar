# GenericSearchBar
This is a little generic search bar using RxSwift and MVVM.

## How to use it?
As this project use [RxSwift](https://github.com/ReactiveX/RxSwift) and [Cartography](https://github.com/robb/Cartography), your project *must* include these pods.

You can use it by integrating those two files into your project: `SearchViewModel.swift` and `SearchViewController.swift`.

To use the generic search bar, simply create your own ViewController, respectively ViewModel, that inherits from SearchViewController, respectively SearchViewModel: 

- In your ViewController, you have to override the `contentView`, the `loadingView` and the `errorView` with your custom views.

- In your ViewModel, you have to override the `search` function with yours (with an API call for instance).

### Example

The custom ViewController class:

```Swift
class SportViewController: SearchViewController<Sport> {
    [...]

    override var contentView: UIView {
        return tableView
    }
    
    override var loadingView: UIView {
        return activityIndicator
    }
    
    override var errorView: UIView {
        return errorLabel
    }
    
    [...]
}
```

The custom ViewModel class:

```Swift
class SportViewModel: SearchViewModel<Sport> {
    [...]
    
    override func search(with keyword: String) -> Observable<[Sport]> {
        let sports = keyword.isEmpty ? [] : [ Sport(name: "Football"),
                                              Sport(name: "Baseball"),
                                              Sport(name: "Basketball"),
                                              Sport(name: "Soccer"),
                                              Sport(name: "Hockey"),
                                              Sport(name: "Golf")]
                                           
        // Here we just return sports whose name start with the same letter than the keyword.
        let filteredSports = sports.filter { $0.name[$0.name.startIndex] == keyword[keyword.startIndex] }

        return Observable.create({ (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if filteredSports.isEmpty {
                    observer.onError(SearchError.notFound)
                } else {
                    observer.onNext(filteredSports)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
    }
    
    [...]
}
```

The Model class:
```Swift
class Sport {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
```
