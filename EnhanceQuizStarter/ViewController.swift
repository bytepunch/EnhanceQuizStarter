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
        
        // Hide the answer Buttons
        answer1Button.isHidden = true
        answer2Button.isHidden = true
        answer3Button.isHidden = true
        answer4Button.isHidden = true
        nextQuestionButton.isHidden = true
        
        
        // Display play again button
        playAgainButton.isHidden = false
        
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
                answer1Button.backgroundColor = UIColor(red: 0, green: 87/255, blue: 0, alpha: 1.0)
                answer1Button.tintColor = UIColor.black
                animateButton(self.answer1Button)
            case "2":
                answer2Button.backgroundColor = UIColor(red: 0, green: 87/255, blue: 0, alpha: 1.0)
                answer2Button.tintColor = UIColor.black
                animateButton(self.answer2Button)
            case "3":
                answer3Button.backgroundColor = UIColor(red: 0, green: 87/255, blue: 0, alpha: 1.0)
                answer3Button.tintColor = UIColor.black
                animateButton(self.answer3Button)
            case "4":
                answer4Button.backgroundColor = UIColor(red: 0, green: 87/255, blue: 0, alpha: 1.0)
                answer4Button.tintColor = UIColor.black
                animateButton(self.answer4Button)
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
        answer1Button.isHidden = false
        answer2Button.isHidden = false
        answer3Button.isHidden = false
        answer4Button.isHidden = false
        nextQuestionButton.isHidden = false

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
}

