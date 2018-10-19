//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Zaen. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene { //SKScene is the root node for all Sprite Kit Objects displayed in a view
    
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //SKSpriteNode is descendent of an SKNode, which is the primary building block of almost all SpriteKit content. Both of which are being initialized to their respective images in the Image.xcassets folder.
    let playerNode = SKSpriteNode(imageNamed: "Player") //SKNode itself does not draw any visual elements, but all visual elements in all SpriteKit-based applications are drawn using SKNode subclasses.
    var impulseCount = 4
    let coreMotionManager = CMMotionManager() //A CMMotionManager object is the object used to get access to the motion services provided by iOS. These services include access to the accelerometer, magnetometer, rotation rate, and other device motion sensors.
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    let foregroundNode = SKSpriteNode()
    
    
    
    required init?(coder aDecoder: NSCoder) { //This method is required because instantiating a UIViewController from a UIStoryBoard calls it.
        super.init(coder: aDecoder)
    }
    
    
    override init(size: CGSize) { //initializes a new scene object, method, which takes a CGSize parameter that represents the size i want the scene to be
        super.init(size: size)
        //backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) //REMOVE
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0); //dy to slow and fast the things down (-0.1) and also can up with (0.1).
        
        isUserInteractionEnabled = true
        
        //adding the background
        backgroundNode.size.width = frame.size.width //sets the width of the backgroundNode to the width of the view’s frame.
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0) //determines where the new node will be anchored in my scene. the anchor point of (0.5, 0.0) sets the anchor point of the background node to the bottom center of the node.
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        addChild(foregroundNode)
        
        //add the player
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2) //the width of the playerNode divided by 2. We’re using this value because we want to create a circle around the playerNode starting from its center with a radius of half the width of the node. This will result in a circle that surrounds the playerNode completely
        playerNode.physicsBody?.isDynamic = false //turns the playerNode into a physics body with a dynamic volume. It will now respond to gravity and other physical bodies in the scene
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 180.0)
        playerNode.physicsBody?.linearDamping = 1.0 //is used to reduce a physics body’s linear velocity to simulate fluid or air friction
        playerNode.physicsBody?.allowsRotation = false //to make it keep blasting through the orbs without spinning off
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer //Defines the collision categories to which a physics body belongs.
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //Determines which categories this physics body makes contact with.
        playerNode.physicsBody?.collisionBitMask = 0 //tells SpriteKit not to handle collisions for me.
        foregroundNode.addChild(playerNode) //did not set the anchor point of the playerNode. That’s because the default anchor point of all SKNodes is (0.5, 0.5), which is the center of the node.
        
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100)
        
        for _ in 0...19 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            
            orbNodePosition.y += 140
            orbNode.position =  orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
            
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            
            foregroundNode.addChild(orbNode)
        }
        
        orbNodePosition = CGPoint(x: playerNode.position.x + 50, y: orbNodePosition.y)
        
        for _ in 0...19 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
            
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            
            foregroundNode.addChild(orbNode)
        }
        
    }
    
    override func didSimulatePhysics() {
        if let accelerometerData = coreMotionManager.accelerometerData {
            playerNode.physicsBody!.velocity = CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380), dy: playerNode.physicsBody!.velocity.dy)
        }
        
        if playerNode.position.x < -(playerNode.size.width / 2) {
            playerNode.position = CGPoint(x: size.width - playerNode.size.width / 2, y: playerNode.position.y);
        }else if playerNode.position.x > self.size.width {
            playerNode.position = CGPoint(x: playerNode.size.width / 2, y: playerNode.position.y);
        }
    }
    
    deinit {
        coreMotionManager.stopAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerNode.position.y >= 180.0 {
            backgroundNode.position = CGPoint(x: backgroundNode.position.x, y: -((playerNode.position.y - 180.0)/8) )
            
            foregroundNode.position = CGPoint(x: foregroundNode.position.x, y: -(playerNode.position.y - 180.0) )
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !playerNode.physicsBody!.isDynamic { //turning the player’s dynamic volume back on, if it was off, so the player will start reacting to gravity again
            playerNode.physicsBody?.isDynamic = true //The purpose of this code is to put the game in an initial start state with the player stationary until i tap the screen to start. When the screen is tapped the first time, the game begins.
            
            coreMotionManager.accelerometerUpdateInterval = 0.3 //the interval, in seconds, that the accelerometer will use to update the app with the current acceleration. This value is set to 3/10ths of a second, which provides a pretty smooth update rate.
            coreMotionManager.startAccelerometerUpdates()
        }
        
        if impulseCount > 0 { //the impulseCount property to give the user a limited number of impulses that can be used
            playerNode.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 40.0)) //This line applies an impulse to the playerNode’s physics body every time you tap the screen.
            impulseCount -= 1
        }
        
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node! //represent second body in the contact
        if nodeB.name == "POWER_UP_ORB" { //if there is a contact then the nodeB is true
            impulseCount += 1 //the contact is going to also increment the impuleCount variable, giving the player additional impulses
            nodeB.removeFromParent() //then nodeB will be disappear
        }
    }
}
