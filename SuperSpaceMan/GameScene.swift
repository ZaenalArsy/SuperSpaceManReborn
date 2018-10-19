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
    
    required init?(coder aDecoder: NSCoder) { //This method is required because instantiating a UIViewController from a UIStoryBoard calls it.
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) { //initializes a new scene object, method, which takes a CGSize parameter that represents the size i want the scene to be
        super.init(size: size)
        //backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) //REMOVE
        
        //adding the background
        backgroundNode.size.width = frame.size.width //sets the width of the backgroundNode to the width of the view’s frame.
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0) //determines where the new node will be anchored in my scene. the anchor point of (0.5, 0.0) sets the anchor point of the background node to the bottom center of the node.
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        //add the player
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        addChild(playerNode) //did not set the anchor point of the playerNode. That’s because the default anchor point of all SKNodes is (0.5, 0.5), which is the center of the node.
    }
}
