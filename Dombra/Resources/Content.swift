//
//  Content.swift
//  Dombra
//
//  Created by Metah on 3/4/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

enum Language {
    case Kazakh
    case English
    case Russian
}

struct Content {
    // MARK:- Constants
    static let silverColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.8)
    static let highlightColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
    
    static let firstNotes = ["A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#"]
    static let secondNotes = ["D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#"]
    static let firstOpenNote = "D"
    static let secondOpenNote = "G"
    
    static let tempos = ["Grave": 1.36, "Largo": 1.25, "Adagio": 1.15, "Lento": 1.11, "Andante": 0.92, "Moderato": 0.68, "Animato": 0.56, "Allegro": 0.45, "Vivo": 0.36, "Presto": 0.31]

    
    // MARK:- Translations
    static var language: Language = .English
    
    static var infoTitle: String {
        return infoTitles[language]!
    }
    static var infoDescription: String {
        return infoDescriptions[language]!
    }
    private static let infoTitles: [Language: String] = [.Kazakh: "", .English: "Wondering how to use the app?", .Russian: "Не знаете как пользоваться приложением?"]
    private static let infoDescriptions: [Language: String] = [.Kazakh: "", .English: "Watch this video to get familiar with the app's all features!", .Russian: "Просмотрите данное видео чтобы ознакомиться со всеми функциями приложения!"]
    
    static var links = ""
}

// Links for every image used in the project                                                   
// Icons made by "https://www.flaticon.com/authors/google" from https://www.flaticon.com/
// 'Close' Icon made by <a href="https://www.flaticon.com/authors/roundicons" title="Roundicons">Roundicons</a> from "https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
