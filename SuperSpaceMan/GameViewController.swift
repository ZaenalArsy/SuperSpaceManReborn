//
//  GameViewController.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Zaen. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene! //GameScene is the class that will be doing most of this work. it is where i will be adding the game logic
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Configure the main view
        let skView = view as! SKView  //as! means "force cast". The value of view will be casted as SKView. If this fails, because view is nil or of a different type, the code will crash. That's why i should avoid using as!
        skView.showsFPS = true //is used to show or hide the frames per second
        
        //2. Create and configure our game scene
        scene =  GameScene(size: skView.bounds.size) //creates a new instance of the GameScene initializing the size to match the size of the view that will host the scene
        scene.scaleMode = .aspectFill //set scaleMode to aspectFill, he scaleMode (implemented by the enum SKSceneScaleMode) is used to determine how the scene will be scaled to match the view that will contain it.
        
        //3. Show the scene.
        skView.presentScene(scene)
        
    }
}
