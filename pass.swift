// Добавим метод revokePassport(), который позволит удалить паспорт у Man, разрывая связь перед nil:

import UIKit

class Man {
    var pasport: Passport? // Паспорт может быть, а может и отсутствовать
    
    deinit {
        print("мужчина удален из памяти")
    }
    
    func revokePassport() {
        pasport = nil // Человек выбрасывает паспорт
    }
}

class Passport {
    let man: Man // Паспорт всегда принадлежит конкретному человеку
    
    init(man: Man) {
        self.man = man
    }
    
    deinit {
        print("паспорт удален из памяти")
    }
}

// Создаем человека
var man: Man? = Man()

// Выдаем ему паспорт
var pasport: Passport? = Passport(man: man!)
man?.pasport = pasport

// Человек выбрасывает паспорт
man?.revokePassport()
pasport = nil // Теперь объект паспорта удалится

// Человек удаляется
man = nil // Теперь удалится и сам человек


// 1. Passport по-прежнему хранит сильную ссылку на Man (let man: Man).
// 2. Man хранит опциональную ссылку на Passport (var pasport: Passport?).
// 3. Перед удалением Man, мы вручную разрываем связь (revokePassport()), позволяя Passport освободиться.