// Перечисление с возможными действиями с автомобилем
enum CarAction {
    case startEngine
    case stopEngine
    case openWindows
    case closeWindows
    case loadCargo(volume: Int)
    case unloadCargo(volume: Int)
}

// Структура легкового автомобиля
struct PassengerCar: Hashable {
    let brand: String
    let year: Int
    let cargoVolume: Int
    var isEngineRunning: Bool = false
    var areWindowsOpen: Bool = false
    var filledCargoVolume: Int = 0

    mutating func performAction(_ action: CarAction) {
        switch action {
        case .startEngine:
            isEngineRunning = true
        case .stopEngine:
            isEngineRunning = false
        case .openWindows:
            areWindowsOpen = true
        case .closeWindows:
            areWindowsOpen = false
        case .loadCargo(let volume):
            if filledCargoVolume + volume <= cargoVolume {
                filledCargoVolume += volume
            } else {
                print("Недостаточно места в багажнике!")
            }
        case .unloadCargo(let volume):
            if filledCargoVolume - volume >= 0 {
                filledCargoVolume -= volume
            } else {
                print("В багажнике нет столько груза!")
            }
        }
    }
}

// Структура грузовика
struct Truck: Hashable {
    let brand: String
    let year: Int
    let cargoVolume: Int
    var isEngineRunning: Bool = false
    var areWindowsOpen: Bool = false
    var filledCargoVolume: Int = 0

    mutating func performAction(_ action: CarAction) {
        switch action {
        case .startEngine:
            isEngineRunning = true
        case .stopEngine:
            isEngineRunning = false
        case .openWindows:
            areWindowsOpen = true
        case .closeWindows:
            areWindowsOpen = false
        case .loadCargo(let volume):
            if filledCargoVolume + volume <= cargoVolume {
                filledCargoVolume += volume
            } else {
                print("Недостаточно места в кузове!")
            }
        case .unloadCargo(let volume):
            if filledCargoVolume - volume >= 0 {
                filledCargoVolume -= volume
            } else {
                print("В кузове нет столько груза!")
            }
        }
    }
}

// Создание объектов
var car1 = PassengerCar(brand: "Toyota", year: 2020, cargoVolume: 300)
var truck1 = Truck(brand: "Volvo", year: 2018, cargoVolume: 5000)

// Применение действий
car1.performAction(.startEngine)
car1.performAction(.loadCargo(volume: 100))
car1.performAction(.openWindows)

truck1.performAction(.startEngine)
truck1.performAction(.loadCargo(volume: 2000))
truck1.performAction(.closeWindows)

// Создание словаря
var vehiclesDictionary: [AnyHashable: String] = [
    car1: "Легковой автомобиль
