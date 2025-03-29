// 1. Сильное (strong) захватывание (по умолчанию)

// Объект Singer захватывается сильной ссылкой, из-за чего создаётся цикл ссылок, и объект никогда не удаляется.

class Singer {
    func playSong() {
        print("Shake it off!")
    }
    
    deinit {
        print("Singer is being deallocated")
    }
}

func createClosure() -> () -> Void {
    let taylor = Singer()
    
    let singing = {
        taylor.playSong()  // taylor захватывается сильно (по умолчанию)
    }
    
    return singing
}

let closure = createClosure()
closure()  // Печатает "Shake it off!"
// Но объект taylor не удаляется, так как замыкание держит его в памяти.

// Проблема: Singer не удаляется из памяти после выхода из функции.


// 2. Слабое (weak) захватывание

// Используем [weak taylor], чтобы избежать утечки памяти. Теперь объект может быть удалён.

func createClosure() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [weak taylor] in
        taylor?.playSong()  // Теперь taylor – optional, поэтому используем ?
    }
    
    return singing
}

let closure = createClosure()
closure()  // Ничего не напечатает, потому что taylor уже удалён.

// Решает проблему: если объект taylor удалён, замыкание просто ничего не делает.


// 3. Безвладельческое (unowned) захватывание

// Если точно знаем, что объект будет существовать во время работы замыкания, можно использовать [unowned taylor], чтобы избежать опциональности.

func createClosure() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [unowned taylor] in
        taylor.playSong()  // taylor больше не optional
    }
    
    return singing
}

let closure = createClosure()
closure()  // Ошибка! taylor уже удалён, но замыкание пытается его вызвать → краш.

// Опасность: unowned не проверяет, существует ли объект. Если taylor удалён, приложение упадёт.


// 4. Решение проблемы сильного цикла ссылок

// Допустим, у нас есть два связанных класса House и Owner, которые ссылаются друг на друга. Если не использовать weak, объекты никогда не удалятся.

class House {
    var ownerDetails: (() -> Void)?  // Замыкание внутри объекта
    func printDetails() { print("This is a great house.") }
    deinit { print("House is being demolished!") }
}

class Owner {
    var houseDetails: (() -> Void)?
    func printDetails() { print("I own a house.") }
    deinit { print("Owner is being removed!") }
}

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = owner.printDetails  // House ссылается на Owner
    owner.houseDetails = house.printDetails  // Owner ссылается на House
}
// Оба объекта не удаляются → утечка памяти!

// Решаем проблему с помощью weak ссылок:

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = { [weak owner] in owner?.printDetails() }
    owner.houseDetails = { [weak house] in house?.printDetails() }
}
// Теперь объекты удаляются, когда выходят из do {} блока.


// Вывод:
// - Сильное (strong) захватывание – используется по умолчанию, но может вызвать утечки памяти.
// - Слабое (weak) захватывание – позволяет объекту удаляться, но требует проверки ?.
// - Безвладельческое (unowned) захватывание – даёт контроль над памятью, но опасно, так как может привести к крашу.