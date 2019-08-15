//
//  QuestionProvider.swift
//  EnhanceQuizStarter
//
//  Created by Jörg Klausewitz on 29.05.19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

class QuestionProvider{
    
    /*
    let trivia: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]
 
     */
    
    // Source: 100 General Trivia Questions and Answers
    /*
     
    
    let questions: [[String : String]] = [
        
        
        
        
        ["Question": "Who invented the telephone?", "Answer1": "Morse", "Answer2": "Bell", "Answer3": "Da Vinci", "Correct": "2", "Choices": "3" ],
        ["Question": "Who discovered penicillin?", "Answer1": "Freud", "Answer2": "Hippocrates", "Answer3": "Fleming", "Correct": "3", "Choices": "3" ],
        ["Question": "What temperature does water boil at?", "Answer1": "95C", "Answer2": "100C", "Answer3": "70C", "Answer4": "50C", "Correct": "2", "Choices": "4" ],
        ["Question": "What artist said he would eat his wife when she died?", "Answer1": "van Gogh", "Answer2": "Rembrandt", "Answer3": "Dali", "Answer4": "Vermeer", "Correct": "3", "Choices": "4" ],
        ["Question": "Which nail grows fastest?", "Answer1": "middle", "Answer2": "index", "Answer3": "thumb", "Answer4": "pinkie", "Correct": "1", "Choices": "4" ],
        ["Question": "What did the crocodile swallow in Peter Pan?", "Answer1": "Boot", "Answer2": "Spoon", "Answer3": "Alarm clock", "Answer4": "Head", "Correct": "3", "Choices": "4" ],
        ["Question": "Which German city is famous for the perfume it produces?", "Answer1": "Hamburg", "Answer2": "Berlin", "Answer3": "Cologne", "Correct": "3", "Choices": "3" ],
        ["Question": "What does the roman numeral C represent?", "Answer1": "100", "Answer2": "200", "Answer3": "300", "Answer4": "500", "Correct": "1", "Choices": "4" ],
        ["Question": "Who lived at 221B, Baker Street, London?", "Answer1": "Nero Wolfe", "Answer2": "Sherlock Holmes", "Answer3": "Agatha Christie", "Answer4": "Arthur Conan Doyle", "Correct": "2", "Choices": "4" ],
        ["Question": "When did the American Civil War end?", "Answer1": "1794", "Answer2": "1865", "Answer3": "1903", "Correct": "2", "Choices": "3" ],
        ["Question": "Who said E = mc2?", "Answer1": "Einstein", "Answer2": "Hawking", "Answer3": "Sagan", "Answer4": "Bor", "Correct": "1", "Choices": "4" ],
        ["Question": "Who was the main actor in “Cocktail”?", "Answer1": "Tom Hanks", "Answer2": "Brad Pitt", "Answer3": "Mickey Rourke", "Answer4": "Tom Cruise", "Correct": "4", "Choices": "4" ]
    ]
 */
    
    let question1 = Question(problem: "Who invented the telephone?", answer1: "Morse", answer2: "Bell", answer3: "Da Vinci", answer4: "", correctAnswer: 2, choices: 3)
    let question2 = Question(problem: "Who discovered penicillin?", answer1: "Freud", answer2: "Hippocrates", answer3: "Fleming", answer4: "", correctAnswer: 3, choices: 3)
    let question3 = Question(problem: "What temperature does water boil at?", answer1: "95C", answer2: "100C", answer3: "70C", answer4: "50C", correctAnswer: 2, choices: 4)
    let question4 = Question(problem: "What artist said he would eat his wife when she died?", answer1: "van Gogh", answer2: "Rembrandt", answer3: "Dali", answer4: "Vermeer", correctAnswer: 3, choices: 4)
    
    
    var questions = [Question]()
    
   
    func addQuestions(){
       questions.append(question1)
       questions.append(question2)
       questions.append(question3)
       questions.append(question4)
    }
    

    
    func provideRandomizedQuestions() -> [Question] {
        let shuffledQuestions = questions.shuffled()
        return shuffledQuestions
    }
    
}
