//
//  Question.swift
//  EnhanceQuizStarter
//
//  Created by Jörg Klausewitz on 15.08.19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

class Question{
    
    // ["Question": "Who invented the telephone?", "Answer1": "Morse", "Answer2": "Bell", "Answer3": "Da Vinci", "Correct": "2", "Choices": "3" ],

    let problem: String
    let answer1: String
    let answer2: String
    let answer3: String
    let answer4: String
    let correctAnswer: Int
    let choices: Int
    
    init(problem: String, answer1: String, answer2: String, answer3: String, answer4: String, correctAnswer:Int, choices:Int){
        self.problem = problem
        self.answer1 = answer1
        self.answer2 = answer2
        self.answer3 = answer3
        self.answer4 = answer4
        self.correctAnswer = correctAnswer
        self.choices = choices
    }
    
    
    
}
