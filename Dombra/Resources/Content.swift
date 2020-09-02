//
//  Content.swift
//  Dombra
//
//  Created by Metah on 3/4/20.
//  Copyright © 2020 devMetah. All rights reserved.
//

import UIKit

enum Language: String {
    case Kazakh = "kazakh"
    case English = "english"
    case Russian = "russian"
}

struct Contact {
    var name: String
    var link: String
}

struct Content {
    // MARK:- Constants
    #warning("update version here")
    static let version = "Version: 1.0.0"

    static let animDuration = 1.0
    
    static let silverColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.8)
    static let highlightColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
    
    #warning("check")
    static let firstNotes = ["A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#"]
    static let secondNotes = ["D", "C#", "C", "B", "A#", "A", "G#", "G", "F#", "F", "E", "D#", "D", "C#", "C", "B", "A#", "A", "G#"]
    static let firstOpenNote = "D"
    static let secondOpenNote = "G"
    
    static let tempos = ["Grave": 1.36, "Largo": 1.25, "Adagio": 1.15, "Lento": 1.11, "Andante": 0.92, "Moderato": 0.68, "Animato": 0.56, "Allegro": 0.45, "Vivo": 0.36, "Presto": 0.31]
    
    static let languages = ["kazakh", "english", "russian"]
    
    static let contacts = [
        Contact(name: "github", link: "https://github.com/metahdev"),
        Contact(name: "gmail", link: "mailto:metahdev@gmail.com"),
        Contact(name: "telegram", link: "https://t.me/metahdev"),
        Contact(name: "insta", link: "https://instagram.com/metahdev"),
        Contact(name: "twitter", link: "https://twitter.com/metahdev")
    ]

    
    // MARK:- Translations
    static var language: Language = .English
    static var continueText: String {
        return continueTexts[language]!
    }
    static var metronomeTitle: String {
        return metronomeTitles[language]!
    }
    static var hideState: String {
        return hideStates[language]!
    }
    static var showState: String {
        return showStates[language]!
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
    static var languageInstruction: String {
        return languageInstructions[language]!
    }
    static var contactDev: String {
        return contactDevTitles[language]!
    }
    static var creditsTitle: String {
        return creditsTitles[language]!
    }
    static var credits: String {
        return creditsVariety[language]!
    }
    static var waitingMessage: String {
        return waitingMessages[language]!
    }
    
    private static let continueTexts: [Language: String] = [.Kazakh: "Жалғастыру үшін экранға басыңыз", .English: "Tap anywhere to continue", .Russian: "Нажмите для продолжения"]
    private static let metronomeTitles: [Language: String] = [.Kazakh: "Метроном", .English: "Metronome", .Russian: "Метроном"]
    private static let hideStates: [Language: String] = [.Kazakh: "Домбрының ладтары жасырын", .English: "The dombra keys are hidden", .Russian: "Лады домбры скрыты"]
    private static let showStates: [Language: String] = [.Kazakh: "Домбрының ладтары көрсетілген", .English: "The dombra keys are shown", .Russian: "Лады домбры показаны"]
    
    private static let infoTitles: [Language: String] = [.Kazakh: "Бағдарламаны қалай қолдануды білмейсіз бе?", .English: "Wondering how to use the app?", .Russian: "Не знаете как пользоваться приложением?"]
    private static let infoDescriptions: [Language: String] = [.Kazakh: "Бұл бейнебаянды қарап, қосымшаның барлық функциялармен таныса аласыз!", .English: "Watch this video to get familiar with the app's all features!", .Russian: "Просмотрите данный видеоролик для ознакомления со всеми функциями приложения!"]
    
    private static let settingsTitles: [Language: String] = [.Kazakh: "Параметрлер", .English: "Settings", .Russian: "Настройки"]
    private static let languageInstructions: [Language: String] = [.Kazakh: "Тілді таңдаңыз:", .English: "Choose a language:", .Russian: "Выберите язык:"]
    private static let contactDevTitles: [Language: String] = [.Kazakh: "Әзірлеушімен байланысу:", .English: "Contact the developer:", .Russian: "Связаться с разработчиком:"]
    private static let creditsTitles: [Language: String] = [.Kazakh: "Ризашылық", .English: "Credits", .Russian: "Признательность"]
    private static let creditsVariety: [Language: String] = [.Kazakh: creditsKazakh, .English: creditsEnglish, .Russian: creditsRussian]
    private static let waitingMessages: [Language: String] = [.Kazakh: "Күте тұрыңыз...", .English: "Please wait...", .Russian: "Пожалуйста подождите..."]
    
    private static let creditsKazakh = "    Қош келдіңіздер! 👋🏻 Менің қосымшамды жүктегеніңіз үшін рақмет! Менің атым - Асқар Әлмұхамет, мен Қазақстаннан iOS әзірлеушімін. Бұл бағдарлама, сіз түсінгендей, қазақтың ұлттық ішекті аспабы - домбыраның симуляторы. Соған қарамастан, мен бұл қосымшаның ешқандай жағдайда нақты құралды алмастыра алмайтынын, керісінше оған кіріспе немесе жаңадан бастағандарға жаттығу жасау әдісі екенін баса айтқым келеді.\n\nПайдаланылған материалдар 📌: \n\nБасында фондық музыка: Дәулеткерейдің күйі 'Қосалқа'"
    private static let creditsEnglish = "   🇰🇿 Salem alem!👋🏻 Thanks for downloading my app! My name is Askar Almukhamet, I am an iOS developer from Kazakhstan. This application, as you may already understood, is a simulator of a Kazakh national string instrument - Dombra. Please note that the application is definitely not an alternative of the real instrument, but rather an useful way to get familiar with the instrument.\n\nResources Used 📌: \nThe background music in the beginning: Dauletkerei's 'Qosalqa'"
    private static let creditsRussian = "   Добро пожаловать!👋🏻 Спасибо за загрузку моего приложения! Меня зовут Аскар Альмухаметов, я iOS разработчик с Казахстана. Это программа, как вы уже вероятно поняли, является симулятором Казахского национального струнного инструмента - Домбры. Тем не менее, хочу подчеркнуть, что приложение никак не является заменой реального инструмента, а больше ознакомлением с ним или же способом для практики новичков.\n\nИспользованные материалы 📌: \nФоновая музыка в начале: Даулеткерей - 'Қосалқа'"
}
