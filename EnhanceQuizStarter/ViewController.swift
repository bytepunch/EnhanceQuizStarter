//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//
// App icon lent from http://quizatclass.com/





import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    // MARK: - Properties
    var questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    let cornerRadius = 10
    var timer: Timer? = nil
    
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
    
    @IBOutlet weak var timerSwitch: UISwitch!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var gameContainerStackView: UIStackView!
    @IBOutlet weak var startContainerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = questionProvider.provideRandomizedQuestions()
        
        //print(questions)
        
        // Rounded corners for all buttons
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button, nextQuestionButton, playAgainButton]
        for button in buttons{
            button?.layer.cornerRadius = CGFloat(cornerRadius)
            button?.clipsToBounds = true
        }
        
        
        if questionsPerRound < questionProvider.provideRandomizedQuestions().count{
            questionsPerRound = questionProvider.provideRandomizedQuestions().count
        }
        
     
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
        
        // Reset colors of all buttons
        reset(answerButtons: answer1Button, answer2Button, answer3Button, answer4Button)

        
        //indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionProvider.questions.count)
        //let questionDictionary = questionProvider.questions[indexOfSelectedQuestion]
        let questionDictionary = questions[questionsAsked]
        questionField.text = questionDictionary["Question"]
        
        answer1Button.setTitle(questionDictionary["Answer1"], for: .normal)
        answer2Button.setTitle(questionDictionary["Answer2"], for: .normal)
        answer3Button.setTitle(questionDictionary["Answer3"], for: .normal)
        
        // In case show the 4th button
        if questionDictionary["Choices"] == "4"{
            answer4Button.setTitle(questionDictionary["Answer4"], for: .normal)
            unHide(views: answer4Button)
        } else{
            hide(views: answer4Button)
        }
        hide(views: playAgainButton)
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
            
            if timerSwitch.isOn{
                startTimer()
            }
            
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
    
    @IBAction func pressStart(_ sender: UIButton) {
        
        
        
        loadGameStartSound()
        //playGameStartSound()
        
        startContainerStackView.isHidden = true
        gameContainerStackView.isHidden = false
        
        if timerSwitch.isOn{
            startTimer()
            // TODO
        }
        
        
        displayQuestion()
        
        
    }
    
    
    @IBAction func pressAnswerButton(_ sender: UIButton) {
        checkGivenAnswer(sender)
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
    
    // MARK: Helper functions
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
    
    func reset(answerButtons: UIView...){
        for view in answerButtons{
            view.backgroundColor = UIColor(red: 239/255, green: 121/255, blue: 48/255, alpha: 1.0)
            view.tintColor = UIColor.white
        }
        
          enableDisableButtons(buttons: answer1Button, answer2Button, answer3Button, answer4Button, toEnable: true)
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
    
    func checkGivenAnswer(_ sender: UIButton){
        
        // Stop timer
        timer?.invalidate()
        
        //let selectedQuestionDict = questions[indexOfSelectedQuestion]
        let selectedQuestionDict = questions[questionsAsked]
        
        print("Question: \(selectedQuestionDict["Question"]!) sender.tag: \(sender.tag) question[Correct]: \(selectedQuestionDict["Correct"]!) QuestionAsked: \(questionsAsked)")
        
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
        
        // Increment the questions asked counter
        questionsAsked += 1
        
    }
    
    func updateUIWhenTimeOver(){
        
        let selectedQuestionDict = questions[questionsAsked]
        let correctAnswerNumber = Int(selectedQuestionDict["Correct"]!)
        
        questionField.text = "Sorry, time over!"
        
        switch correctAnswerNumber {
        case 1:
            mark(correctAnswerButton: answer1Button)
            
        case 2:
            mark(correctAnswerButton: answer2Button)
        case 3:
            mark(correctAnswerButton: answer3Button)
        case 4:
            mark(correctAnswerButton: answer4Button)
            

        default:
            break
        }
        
        enableDisableButtons(buttons: answer1Button, answer2Button, answer3Button, answer4Button, toEnable: false)
       
        
        // Increment the questions asked counter
        questionsAsked += 1
    }
    
    
    func startTimer(){
        
        var time = 0;
        let maxTime = 15
        var timeLabelText = maxTime
        self.timerLabel.text = String(timeLabelText)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            time += 1
            timeLabelText -= 1
            self.timerLabel.text = String(timeLabelText)
            
            if time == maxTime{
                //self.timerLabel.text = String(timeLabelText)
                timer.invalidate()
                self.updateUIWhenTimeOver()
            }
            
        })

    }

}

