//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Properties
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    // Question provider
    let questionProvider = QuestionProvider()
    var questions: [[String:String]] = []
    
    var gameSound: SystemSoundID = 0
    
    // MARK: - Outlets
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        questions = questionProvider.provideRandomizedQuestions()
        loadGameStartSound()
        //playGameStartSound()
        displayQuestion()
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func displayQuestion() {
        
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionProvider.questions.count)
        
        
        
        
        // Reset colors of all buttons
        answer1Button.backgroundColor = UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1.0)
        answer1Button.tintColor = UIColor.white
        answer2Button.backgroundColor = UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1.0)
        answer2Button.tintColor = UIColor.white
        answer3Button.backgroundColor = UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1.0)
        answer3Button.tintColor = UIColor.white
        answer4Button.backgroundColor = UIColor(red: 12/255, green: 121/255, blue: 150/255, alpha: 1.0)
        answer4Button.tintColor = UIColor.white

        let questionDictionary = questionProvider.questions[indexOfSelectedQuestion]
        questionField.text = questionDictionary["Question"]
        
        answer1Button.setTitle(questionDictionary["Answer1"], for: .normal)
        answer2Button.setTitle(questionDictionary["Answer2"], for: .normal)
        answer3Button.setTitle(questionDictionary["Answer3"], for: .normal)
        
        // In case show the 4th button
        if questionDictionary["Choices"] == "4"{
            answer4Button.setTitle(questionDictionary["Answer4"], for: .normal)
            answer4Button.isHidden = false
        } else{
            answer4Button.isHidden = true
        }
        
        playAgainButton.isHidden = true
        
    }
    
    func displayScore() {
        
        // Hide the answer Button
        hide(views: answer1Button, answer2Button, answer3Button, answer4Button, nextQuestionButton)

        // Display play again button
        unHide(views: playAgainButton)
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    // No longer needed
    /*
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    */

    
    // MARK: - Actions
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = questionProvider.questions[indexOfSelectedQuestion]
        //let correctAnswer = selectedQuestionDict["Answer"]
        
        if (sender.tag == Int(selectedQuestionDict["Correct"]!)) {
            correctQuestions += 1
            questionField.text = "Correct!"
            sender.backgroundColor = UIColor(red: 0, green: 87/255, blue: 0, alpha: 1.0)
            sender.tintColor = UIColor.black
            
        } else {
            questionField.text = "Sorry, wrong answer!"
            sender.backgroundColor = UIColor(red: 87/255, green: 0, blue: 0, alpha: 1.0)
            sender.tintColor = UIColor.black
            
            switch selectedQuestionDict["Correct"]{
            case "1":
                mark(correctAnswerButton: answer1Button)
            case "2":
                mark(correctAnswerButton: answer2Button)
            case "3":
                mark(correctAnswerButton: answer3Button)
            case "4":
                mark(correctAnswerButton: answer4Button)
            default:
                break
            }
 
        }

        // Go manually with nextQuestionButton
        //loadNextRound(delay: 2)

    }
    
    
    @IBAction func newxtQuestion(_ sender: Any) {
        nextRound()
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
        unHide(views: answer1Button, answer2Button, answer3Button, answer4Button, nextQuestionButton)

        questions = questionProvider.provideRandomizedQuestions()
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    
    // Source:
    func animateButton(_ buttonToAnimate: UIView){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8, options: .curveEaseIn,
                       animations: {
                        buttonToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                buttonToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    func hide(views: UIView...){
        for view in views{
            view.isHidden = true
        }
    }

    func unHide(views: UIView...){
        for view in views{
            view.isHidden = false
        }
    }
    
    func mark(correctAnswerButton: UIView){
        correctAnswerButton.backgroundColor = UIColor(red: 0, green: 87/255, blue: 0, alpha: 1.0)
        correctAnswerButton.tintColor = UIColor.black
        animateButton(correctAnswerButton)
    }

    
}

