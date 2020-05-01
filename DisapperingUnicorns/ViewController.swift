//
//  ViewController.swift
//  DisapperingUnicorns
//
//  Created by Benjamin Dirgo on 4/30/20.
//  Copyright © 2020 Benjamin Dirgo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var gameButtons = [UIButton]()
    var gamePoints = 0
    
    enum GameState {
        case gameOver
        case playing
    }
    
    var state = GameState.gameOver

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pointsLabel.isHidden = true
        gameButtons = [goodButton, badButton]
        setupFreshGameState()
    }
    
    func oneGameRound() {
        updatePointsLabel(gamePoints) // why are we updateing at the start??
        displayRandomButton()
        
        // After on esecond run the included code
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            if self.state == GameState.playing { // why do we need to check this???
                if self.currentButton == self.goodButton {
                    self.gameOver()
                } else {
                    self.oneGameRound()
                }
            }
        }
    }
    
    func startNewGame() {
        startGameButton.isHidden = true
        leaderboardButton.isHidden = true
        gamePoints = 0
        updatePointsLabel(gamePoints)
        pointsLabel.textColor = .magenta
        pointsLabel.isHidden = false
        oneGameRound()
    }
    
    @IBAction func startPressed(_ sender: Any) {
        state = GameState.playing
        startNewGame()
    }
//  Add a point when good button was pressed
    @IBAction func goodPressed(_ sender: Any) {
        gamePoints += 1
        updatePointsLabel(gamePoints)
        goodButton.isHidden = true
//        if there is still a timer going cancel it
        timer?.invalidate()
        oneGameRound()
    }
//    Womp Womp. Game over
    @IBAction func badPressed(_ sender: Any) {
        badButton.isHidden = true
        timer?.invalidate()
        gameOver()
    }
    
    var timer: Timer?
    var currentButton: UIButton!
    
    func displayRandomButton() {
        for myButton in gameButtons {
            myButton.isHidden = true
        }
        let buttonIndex = Int.random(in: 0 ..< gameButtons.count)
        currentButton = gameButtons[buttonIndex]
        currentButton.center = CGPoint(x: randomXCoordinate(), y: randomYCoordinate())
        currentButton.isHidden = false
    }
    
    func gameOver() {
        state = GameState.gameOver
        pointsLabel.textColor = .brown
        setupFreshGameState()
    }
    
    func setupFreshGameState() {
        startGameButton.isHidden = false
        leaderboardButton.isHidden = false
        for myButton in gameButtons {
            myButton.isHidden = true
        }
        pointsLabel.alpha = 0.15
        currentButton = goodButton
        state = GameState.gameOver
        
    }
    
    func randCGFloat(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        return CGFloat.random(in: min..<max)
    }
    
    func randomXCoordinate() -> CGFloat {
        let left = view.safeAreaInsets.left + currentButton.bounds.width
        let right = view.bounds.width - view.safeAreaInsets.right - currentButton.bounds.width
        return randCGFloat(left, right)
    }
    
    func randomYCoordinate() -> CGFloat {
        let top = view.safeAreaInsets.top + currentButton.bounds.height
        let bottom = view.bounds.height - view.safeAreaInsets.bottom - currentButton.bounds.height
        return randCGFloat(top, bottom)
    }
    
    func updatePointsLabel(_ newLabel: Int) {
        pointsLabel.text = "\(newLabel)"
    }
}

