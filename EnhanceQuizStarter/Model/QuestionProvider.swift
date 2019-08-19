//
//  QuestionProvider.swift
//  EnhanceQuizStarter
//
//  Created by Jörg Klausewitz on 29.05.19.
//  Copyright © 2019 Treehouse. All rights reserved.
//
import UIKit


class QuestionProvider{
    
    // Source: 100 General Trivia Questions and Answers
    let question1 = Question(problem: "Who invented the telephone?", answer1: "Morse", answer2: "Bell", answer3: "Da Vinci", answer4: "", correctAnswer: 2, choices: 3)
    let question2 = Question(problem: "Who discovered penicillin?", answer1: "Freud", answer2: "Hippocrates", answer3: "Fleming", answer4: "", correctAnswer: 3, choices: 3)
    let question3 = Question(problem: "What temperature does water boil at?", answer1: "95C", answer2: "100C", answer3: "70C", answer4: "50C", correctAnswer: 2, choices: 4)
    let question4 = Question(problem: "What artist said he would eat his wife when she died?", answer1: "van Gogh", answer2: "Rembrandt", answer3: "Dali", answer4: "Vermeer", correctAnswer: 3, choices: 4)
    let question5 = Question(problem: "Which nail grows fastest?", answer1: "Middle", answer2: "Index", answer3: "Thumb", answer4: "Pinkie", correctAnswer: 1, choices: 4)
    let question6 = Question(problem: "What did the crocodile swallow in Peter Pan?", answer1: "Boot", answer2: "Spoon", answer3: "Alarm clock", answer4: "Head", correctAnswer: 3, choices: 4)
    let question7 = Question(problem: "Which German city is famous for the perfume it produces?", answer1: "Hamburg", answer2: "Berlin", answer3: "Cologne", answer4: "", correctAnswer: 3, choices: 3)
    let question8 = Question(problem: "What does the roman numeral C represent?", answer1: "100", answer2: "200", answer3: "300", answer4: "500", correctAnswer: 1, choices: 4)
    let question9 = Question(problem: "Who lived at 221B, Baker Street, London?", answer1: "Nero Wolfe", answer2: "Sherlock Holmes", answer3: "Agatha Christie", answer4: "Arthur Conan Doyle", correctAnswer: 2, choices: 4)
    let question10 = Question(problem: "When did the American Civil War end?", answer1: "1794", answer2: "1865", answer3: "1903", answer4: "Arthur Conan Doyle", correctAnswer: 2, choices: 3)
    let question11 = Question(problem: "Who said E = mc2", answer1: "Einstein", answer2: "Hawking", answer3: "Sagan", answer4: "Bor", correctAnswer: 1, choices: 4)
    let question12 = Question(problem: "Who was the main actor in “Cocktail”?", answer1: "Tom Hanks", answer2: "Brad Pitt", answer3: "Mickey Rourke", answer4: "Tom Cruise", correctAnswer: 4, choices: 4)
    
    
    var questions = [Question]()
   
    func addQuestions(){
       questions.append(question1)
       questions.append(question2)
       questions.append(question3)
       questions.append(question4)
       questions.append(question5)
       questions.append(question6)
       questions.append(question7)
       questions.append(question8)
       questions.append(question9)
       questions.append(question10)
       questions.append(question11)
       questions.append(question12)
    }
    
    func provideRandomizedQuestions() -> [Question] {
        let shuffledQuestions = questions.shuffled()
        return shuffledQuestions
    }
    
    func checkIfAnswerIsCorrect(from question: Question, answerButton: UIButton ) -> Bool{
        if question.correctAnswer == answerButton.tag {
            return true
        }  else{
            return false
        }
    }
    
}
