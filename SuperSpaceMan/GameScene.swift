//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Zaen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene { //SKScene is the root node for all Sprite Kit Objects displayed in a view
    
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //SKSpriteNode is descendent of an SKNode, which is the primary building block of almost all SpriteKit content. Both of which are being initialized to their respective images in the Image.xcassets folder.
    let playerNode = SKSpriteNode(imageNamed: "Player") //SKNode itself does not draw any visual elements, but all visual elements in all SpriteKit-based applications are drawn using SKNode subclasses.
    let orbNode = SKSpriteNode(imageNamed: "PowerUp")
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
    
    
    required init?(coder aDecoder: NSCoder) { //This method is required because instantiating a UIViewController from a UIStoryBoard calls it.
        super.init(coder: aDecoder)
    }
    
    
    override init(size: CGSize) { //initializes a new scene object, method, which takes a CGSize parameter that represents the size i want the scene to be
        super.init(size: size)
        //backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) //REMOVE
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0); //dy to slow and fast the things down (-0.1) and also can up with (0.1).
        
        isUserInteractionEnabled = true
        
        //adding the background
        backgroundNode.size.width = frame.size.width //sets the width of the backgroundNode to the width of the view’s frame.
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0) //determines where the new node will be anchored in my scene. the anchor point of (0.5, 0.0) sets the anchor point of the background node to the bottom center of the node.
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        //add the player
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2) //the width of the playerNode divided by 2. We’re using this value because we want to create a circle around the playerNode starting from its center with a radius of half the width of the node. This will result in a circle that surrounds the playerNode completely
        playerNode.physicsBody?.isDynamic = true //turns the playerNode into a physics body with a dynamic volume. It will now respond to gravity and other physical bodies in the scene
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        playerNode.physicsBody?.linearDamping = 1.0 //is used to reduce a physics body’s linear velocity to simulate fluid or air friction
        playerNode.physicsBody?.allowsRotation = false //to make it keep blasting through the orbs without spinning off
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer //Defines the collision categories to which a physics body belongs.
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //Determines which categories this physics body makes contact with.
        playerNode.physicsBody?.collisionBitMask = 0 //tells SpriteKit not to handle collisions for me.
        addChild(playerNode) //did not set the anchor point of the playerNode. That’s because the default anchor point of all SKNodes is (0.5, 0.5), which is the center of the node.
        
        orbNode.position = CGPoint(x: 150.0, y: size.height - 25)
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
        orbNode.physicsBody?.isDynamic = false //static volume
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode.physicsBody?.collisionBitMask = 0
        orbNode.name = "POWER_UP_ORB"
        addChild(orbNode)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0)) //This line applies an impulse to the playerNode’s physics body every time you tap the screen.
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node //represent second body in the contact
        if nodeB?.name == "POWER_UP_ORB" { //if there is a contact then the nodeB is true
            nodeB?.removeFromParent() //then nodeB will be disappear
        }
    }
}
