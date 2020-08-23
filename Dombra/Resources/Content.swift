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
    #warning("update version here")
    static let version = "Version: 1.0.0"

    static let animDuration = 1.0
    
    static let silverColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.8)
    static let highlightColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
    
    static let firstNotes = ["A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#"]
    static let secondNotes = ["D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#"]
    static let firstOpenNote = "D"
    static let secondOpenNote = "G"
    
    static let tempos = ["Grave": 1.36, "Largo": 1.25, "Adagio": 1.15, "Lento": 1.11, "Andante": 0.92, "Moderato": 0.68, "Animato": 0.56, "Allegro": 0.45, "Vivo": 0.36, "Presto": 0.31]
    
    static let languages = ["Kazakh", "English", "Russian"]
    static let devLinks = ["gmail", "insta", "twitter", "telegram"]

    
    // MARK:- Translations
    static var language: Language = .English
    static var continueText: String {
        return continueTexts[language]!
    }
    
    static var infoTitle: String {
        return infoTitles[language]!
    }
    static var infoDescription: String {
        return infoDescriptions[language]!
    }
    static var settingsTitle: String {
        return settingsTitles[language]!
    }
    static var creditsTitle: String {
        return creditsTitles[language]!
    }
    
    private static let continueTexts: [Language: String] = [.Kazakh: "", .English: "Tap anywhere to continue", .Russian: "Нажмите для продолжения"]
    private static let metronomeTitles: [Language: String] = [.Kazakh: "Метроном", .English: "Metronome", .Russian: "Метроном"]
    private static let instructionTexts: [Language: String] = [.Kazakh: "", .English: "Hide the dombra keys", .Russian: "Скрыть клавиши домбры"]
    
    private static let infoTitles: [Language: String] = [.Kazakh: "", .English: "Wondering how to use the app?", .Russian: "Не знаете как пользоваться приложением?"]
    private static let infoDescriptions: [Language: String] = [.Kazakh: "", .English: "Watch this video to get familiar with the app's all features!", .Russian: "Просмотрите данное видео чтобы ознакомиться со всеми функциями приложения!"]
    
    private static let settingsTitles: [Language: String] = [.Kazakh: "", .English: "Settings", .Russian: "Настройки"]
    private static let languageInstructions: [Language: String] = [.Kazakh: "", .English: "Choose a language", .Russian: ""]
    private static let contactDevTitles: [Language: String] = [.Kazakh: "", .English: "Contact the develo[er", .Russian: ""]
    private static let rateTitles: [Language: String] = [.Kazakh: "", .English: "Rate in the App Store", .Russian: ""]
    private static let creditsTitles: [Language: String] = [.Kazakh: "", .English: "Credits", .Russian: "Признательность"]
    private static let credits: [Language: String] = [.Kazakh: "", .English: "", .Russian: ""]
}
