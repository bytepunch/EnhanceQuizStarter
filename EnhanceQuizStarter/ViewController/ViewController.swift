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
import AVFoundation


class ViewController: UIViewController {
    
    // MARK: - Properties
    var questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    let cornerRadius = 10
    var timer: Timer? = nil
    let maxTime = 15
    
    // MARK: - SoundManager
    let soundManager = SoundManager()
    
    // Question provider
    let questionProvider = QuestionProvider()
    var questions = [Question]()
    var question: Question? = nil
    
    
    // MARK: - Outlets
    @IBOutlet weak var questionField: UILabel!

    // IBOutlet colletion
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var timerSwitch: UISwitch!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var answersStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load questions from data model
        questionProvider.addQuestions()
        questions = questionProvider.provideRandomizedQuestions()
       
        // Rounded corners for all buttons
        for button in buttons{
            button.layer.cornerRadius = CGFloat(cornerRadius)
            button.clipsToBounds = true
        }
    }
    
    // Displays the questions on screen
    func displayQuestion() {
        
        // Reset colors of all buttons
        reset(answerButtons: buttons[0...3])

        
        let questionDictionary = questions[questionsAsked]
        questionField.text = questionDictionary.problem
        
        buttons[0].setTitle(questionDictionary.answer1, for: .normal)
        buttons[1].setTitle(questionDictionary.answer2, for: .normal)
        buttons[2].setTitle(questionDictionary.answer3, for: .normal)
        
        // In case show the 4th button
        if questionDictionary.choices == 4{
            buttons[3].setTitle(questionDictionary.answer4, for: .normal)
            unHide(views: buttons[3])
        } else{
            hide(views: buttons[3])
        }
        hide(views: buttons[5])
        
        buttons[4].isEnabled = false
        
    }
    
    // Displays the score at end screen
    func displayScore() {
        
        // Hide the answer Button
        hide(views: buttons[4], timerLabel)
        hide(views: buttons[0...3])
        
        // Display play again button
        unHide(views: buttons[5])
        
        // Less than the half of questions correct change String
        if correctQuestions <= questionsPerRound/2{
            questionField.text = "Oooops!\nYou got only \(correctQuestions) out of \(questionsPerRound) correct!"
        } else{
           questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        }
    }
    
    // Checks
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            
            // Continue game
            if timerSwitch.isOn{
                startTimer()
            }
            displayQuestion()
        }
    }
    
    // MARK: - Actions
    // Start button pressed. The quiz will start.
    @IBAction func pressStart(_ sender: UIButton) {
        soundManager.play("Start")
        
        // Hide
        startButton.isHidden = true
        timerStackView.isHidden = true
        
        // Unhide
        unHide(views: timerLabel, answersStackView, buttons[4], timerLabel, questionField)

        if timerSwitch.isOn{
            unHide(views: timerLabel)
            startTimer()
        }
        displayQuestion()
    }
    
    // Anweser button pressed calls function which checks if answer is correct
    @IBAction func pressAnswerButton(_ sender: UIButton) {
        
        // Stop timer
        timer?.invalidate()
        
        if questionProvider.checkIfAnswerIsCorrect(from: questions[questionsAsked], answerButton: sender) {
            
            soundManager.play("Applause")
            
            correctQuestions += 1
            questionField.text = "Correct!"
            sender.backgroundColor = UIColor.correctAnswerColor
            sender.tintColor = UIColor.black
            
        } else {
            
            soundManager.play("FailBuzzer")
            
            questionField.text = "Sorry, wrong answer!"
            sender.backgroundColor = UIColor.falseAnswerColor
            sender.tintColor = UIColor.black
            
            switch questions[questionsAsked].correctAnswer{
            case 1:
                mark(correctAnswerButton: buttons[0])
            case 2:
                mark(correctAnswerButton: buttons[1])
            case 3:
                mark(correctAnswerButton: buttons[2])
            case 4:
                mark(correctAnswerButton: buttons[3])
            default:
                break
            }
            
        }
        
        
        buttons[4].isEnabled = true
        
        // Increment the questions asked counter
        questionsAsked += 1
    }
    
    @IBAction func newxtQuestion(_ sender: Any) {
        soundManager.stop()
        nextRound()
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        
        // Show the answer buttons
        //unHide(views: answer1Button, answer2Button, answer3Button, answer4Button, nextQuestionButton)
        unHide(buttonArraySlice: buttons[0...3])
        unHide(views: buttons[4])
        
        // Show timer label when lighning mode is on
        if timerSwitch.isOn{
            unHide(views: timerLabel)
            
        }
        questions = questionProvider.provideRandomizedQuestions()
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    // MARK: Helper functions
    
    // Source: Animation StackOverflow
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
    
    func hide(views: ArraySlice<UIButton>){
        for view in views{
            view.isHidden = true
        }
    }
    

    func unHide(views: UIView...){
        for view in views{
            view.isHidden = false
        }
    }
    
    func unHide(buttonArraySlice: ArraySlice<UIButton>){
        for button in buttonArraySlice{
            button.isHidden = false
        }
    }
    
    func mark(correctAnswerButton: UIButton){
        correctAnswerButton.backgroundColor = UIColor.correctAnswerColor
        correctAnswerButton.tintColor = UIColor.black
        animateButton(correctAnswerButton)
    }
    
    func reset(answerButtons: ArraySlice<UIButton>){
        for view in answerButtons{
            view.backgroundColor = UIColor.normalColor
            view.tintColor = UIColor.white
        }
        
          enableDisableButtons(buttons: buttons[0...3], toEnable: true)
    }
    
    
    // Enables or disables an amount of UIButtons
    func enableDisableButtons(buttons: UIButton..., toEnable: Bool){
        for button in buttons{
            if toEnable == true{
                button.isEnabled = true
            } else{
                button.isEnabled = false
            }
        }
    }
    
    func enableDisableButtons(buttons: ArraySlice<UIButton>, toEnable: Bool){
        for button in buttons{
            if toEnable == true{
                button.isEnabled = true
            } else{
                button.isEnabled = false
            }
        }
    }
    
    
    func updateUIWhenTimeOver(){
        soundManager.play("FailBuzzer")
        
        questionField.text = "Sorry, time over!"
        
        switch questions[questionsAsked].correctAnswer {
        case 1:
            mark(correctAnswerButton: buttons[0])
        case 2:
            mark(correctAnswerButton: buttons[1])
        case 3:
            mark(correctAnswerButton: buttons[2])
        case 4:
            mark(correctAnswerButton: buttons[3])
        default:
            break
        }
        enableDisableButtons(buttons: buttons[0...3], toEnable: false)
        enableDisableButtons(buttons: buttons[4], toEnable: true)
        // Increment the questions asked counter
        questionsAsked += 1
        
    }
    
    func startTimer(){
        
        var time = 0;
        
        var timeLabelText = maxTime
        
        self.timerLabel.text = String(timeLabelText)
        self.timerLabel.textColor = UIColor.white
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            time += 1
            timeLabelText -= 1
            self.timerLabel.text = String(timeLabelText)
            
            if timeLabelText == 5{
                self.timerLabel.textColor = UIColor.red
                self.soundManager.play("Click")
            }
            
            if time == self.maxTime{
                timer.invalidate()
                self.updateUIWhenTimeOver()
            }
        })

    }
 
 

} // ViewController class


extension UIColor {
    static var correctAnswerColor: UIColor  { return UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0) }
    static var falseAnswerColor: UIColor { return UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0) }
    static var normalColor: UIColor { return UIColor(red: 175/255, green: 192/255, blue: 205/255, alpha: 1.0) }
}

