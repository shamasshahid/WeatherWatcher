# WeatherWatcher

## Note
Please put a valid weather API key in `WeatherWatcherConfig`

WeatherWatcher lets user get the real time weather information by calling openmap weather API. The user can add to the list of the defaults cities, by searching through the list. 

## Design Considerations

### MVVM
The app uses MVVM to separate the business logic from UI. `WeatherListViewModel` is the responsible for the first opening screen. This VM initiates the city data preload calls and subsequently requests data fetch from the backend. 

`WeatherDetailViewModel` is responsible for the weather detail screen. It creates a number tuples, in which weather information is saved in title/value pairs.

`CityWeatherTVCViewModel`, `CitySelectionCellViewModel` are light-weight VMs for TableViewCells.

### Data Storage

`DataStorage` implements the protocol `Storage`, which decouples the VM from the concrete implementation. If later we choose not to use CoreData, we can replace the `DataStorage` by some other implementation without the need to change the view-models. This is in accordance with the Dependency Inversion Principle.

### Network

Network calls rely on 2 protocols, `Routable` and `WebService`. Splitting these two up, helps us decouple routing information from the network call logic. Their concrete implementation are `WeatherListRouter` and `WeatherService`. 

## Unit Testing
We have unit tests covering the light weight ViewModels. I have laid down foundation for testing `WeatherDetailViewModel`, by adding mocks for webservice, and adding support for in-memory CoreData PersistentContainer. 

## Improvements
* Initial preloading city information to core-data can be improved, or be replaced by something pre-populated, such as SQL DB. (Since our DataStorage implementation is decoupled, this should be fairly easily)
* If we stick to CoreData, for pre-population, we should use batch-inserts. 
* JSON file load should be moved to a background thread as well. 
* 