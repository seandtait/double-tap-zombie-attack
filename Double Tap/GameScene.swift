//
//  GameScene.swift
//  Double Tap
//
//  Created by Sean Don Tait on 09/08/2016.
//  Copyright (c) 2016 SDT. All rights reserved.
//

// CREDIT
//=======================================
// freeSFX - http://www.freesfx.co.uk/
//---------------------------------------
// Sounds.
//=======================================
// Tigiest Zelleke - From Pinterest
//---------------------------------------
// Building background image.
//=======================================
// Sharlene Tait
//---------------------------------------
// Human/Zombie graphics.
//=======================================




import SpriteKit
import GoogleMobileAds

class GameScene: SKScene {
    
    
    
    var testCounter = 0;
    
    var soundOn = true;
    var tryAgainWait = true;
    var playingGame = false;
    
    var score: Int = 0;
    
    var waitTimer: NSTimeInterval = 0.75; // Replace with 0.75 for production
    var tryAgainWaitTimer: NSTimeInterval = 1.25; // 1.25 is a good speed
    
    let textureHuman: SKTexture = SKTexture(imageNamed: "human.png");
    let textureZombie: SKTexture = SKTexture(imageNamed: "zombie.png");
    
    let textureSoundOn: SKTexture = SKTexture(imageNamed: "sound-on.png");
    let textureSoundOff: SKTexture = SKTexture(imageNamed: "sound-off.png");
    
    let soundGunshot: SKAction = SKAction.playSoundFileNamed("gunshot.mp3", waitForCompletion: false);
    let soundSurvivor: SKAction = SKAction.playSoundFileNamed("survivor-sound.mp3", waitForCompletion: false);
    let soundZombie: SKAction = SKAction.playSoundFileNamed("zombie-sound.mp3", waitForCompletion: false);
    
    var scoreLabel = SKLabelNode();
    var instructionsLabel = SKLabelNode();
    
    var backgroundImage = SKSpriteNode();
    var bloodSplatter = SKSpriteNode();
    var soundIcon = SKSpriteNode();
    var logoImage = SKSpriteNode();
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = SKColor.blackColor();
        
        scoreSetup();
        createBackground();
        createBloodSplatter();
        createTitle();
        createInstructions();
        
        
        
        playingGame = false;
        tryAgainWait = false;
        
        createSoundIcon();
        hideBloodSplatter();
        createTapToPlayLabel();
    }
    
    func createTitle() {
        let logoTexture = SKTexture(imageNamed: "logo.png");
        logoImage = SKSpriteNode(texture: logoTexture);
        logoImage.zPosition = 9;
        logoImage.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height * 0.75);
        logoImage.name = "logo";
        logoImage.userInteractionEnabled = false;
        
        self.addChild(logoImage);
    }
    
    func showTitle() {
        logoImage.alpha = 1.0;
    }
    
    func hideTitle() {
        logoImage.alpha = 0.0;
    }
    
    func createSoundIcon() {
        if soundOn == true {
            soundIcon = SKSpriteNode(texture: textureSoundOn);
        } else {
            soundIcon = SKSpriteNode(texture: textureSoundOff);
        }
        
        soundIcon.position = CGPoint(x: self.frame.width * 0.95, y: self.frame.height * 0.25);
        soundIcon.name = "sound";
        soundIcon.zPosition = 5;
        
        self.addChild(soundIcon);
    }
    
    func createBackground() {
        let bgTexture = SKTexture(imageNamed: "buildings2.jpg");
        backgroundImage = SKSpriteNode(texture: bgTexture);
        backgroundImage.zPosition = -1;
        backgroundImage.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        backgroundImage.size.width = self.frame.width;
        backgroundImage.size.height = self.frame.height;
        backgroundImage.name = "background";
        
        self.addChild(backgroundImage);
    }
    
    func createInstructions() {
        instructionsLabel.fontSize = 50;
        instructionsLabel.name = "instructions";
        instructionsLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height * 0.3);
        instructionsLabel.fontName = "Deanna";
        instructionsLabel.userInteractionEnabled = false;
        instructionsLabel.zPosition = 3;
        instructionsLabel.text = "Tap the zombies, avoid the survivors";
        self.addChild(instructionsLabel);
    }
    
    func destroyInstructions() {
        if let node = self.childNodeWithName("instructions") {
            node.removeFromParent();
        }
    }
    
    func scoreSetup() {
        scoreLabel.fontSize = 80;
        scoreLabel.name = "score";
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height * 0.53);
        scoreLabel.fontName = "Deanna";
        scoreLabel.zPosition = 3;
        self.addChild(scoreLabel);
    }
    
    func createBloodSplatter() {
        let bloodTexture = SKTexture(imageNamed: "blood.png");
        bloodSplatter = SKSpriteNode(texture: bloodTexture);
        bloodSplatter.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        bloodSplatter.alpha = 0.0;
        bloodSplatter.xScale = 1.2;
        bloodSplatter.yScale = 1.2;
        bloodSplatter.zPosition = 2;
        
        self.addChild(bloodSplatter);
    }
    
    func showBloodSplatter() {
        bloodSplatter.alpha = 1.0;
    }
    
    func hideBloodSplatter() {
        bloodSplatter.alpha = 0.0;
    }
    
    func refreshScore() {
        scoreLabel.text = "Score: " + String(score);
    }

    func startGame() {
        
        destroyInstructions();
        refreshScore();
        hideTitle();
        score = 0;
        refreshScore();
        playingGame = true;
        
        // Add 2 named nodes and generate them to get things going
        var leftNode = SKSpriteNode();
        leftNode.name = "left";
        
        var rightNode = SKSpriteNode();
        rightNode.name = "right";
        
        self.addChild(leftNode);
        self.addChild(rightNode);
        
        generate(leftNode.name!);
        generate(rightNode.name!);
    }
    
    func generate(nodeName: String) {
        var texture = SKTexture();
        var node = SKSpriteNode();
        
        if let childNode = self.childNodeWithName(nodeName) {
            self.removeChildrenInArray([childNode]);
        }
        
        let actionWait = SKAction.waitForDuration(waitTimer);
        var actionEvent = SKAction();
        
        if Int.random(0...1) == 0 {
            // Human
            texture = textureHuman;
            actionEvent = SKAction.runBlock({
                self.score += 1;
                self.refreshScore();
                
                self.generate(nodeName);
            })
        } else {
            // Zombie
            texture = textureZombie;
            actionEvent = SKAction.runBlock({
                self.gameOver("zombie");
            })
        }
        
        
        node = SKSpriteNode(texture: texture);
        node.name = nodeName;
        node.runAction(SKAction.sequence([actionWait, actionEvent]));
        
        if nodeName == "left" {
            node.position = CGPoint(x: self.frame.width * 0.2, y: self.frame.height / 2);
        } else {
            node.position = CGPoint(x: self.frame.width * 0.8, y: self.frame.height / 2);
        }
        
        let actionShrink = SKAction.scaleBy(0.9, duration: 0.2);
        let actionGrow = SKAction.scaleBy(1.1, duration: 0.2);
        
        node.runAction(SKAction.sequence([actionGrow, actionShrink]));
        
        self.addChild(node);
    }
    
    func playSound(sound: SKAction) {
        if soundOn == true {
            runAction(sound);
        }
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            // Get the position that was touched
            let positionInScene = touch.locationInNode(self)
            
            if playingGame == true {
                if let touchedNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode {
                    if touchedNode.name != "background" {
                        playSound(soundGunshot);
                        if touchedNode.texture == textureHuman {
                            // Game Over
                            gameOver("survivor");
                        } else {
                            // Gain a point
                            score += 1;
                            self.refreshScore();
                            
                            generate(touchedNode.name!);
                        }
                    }
                }
            } else {
                // Check if sound was clicked - 
                if let touchedNode = self.nodeAtPoint(positionInScene) as? SKSpriteNode {
                    if touchedNode.name == "sound" {
                        toggleSound();
                    } else {
                        restartGame();
                    }
                } else {
                    restartGame();
                }
            }
            
        }
    }
    
    func restartGame() {
        // Not playing the game, ie. Game over or Start screen
        if tryAgainWait == false {
            // Restart the game
            tryAgainWait = true;
            playingGame = true;
            
            hideBloodSplatter();
            if let tapToPlayLabel = self.childNodeWithName("tapToPlay") {
                // Delete the label
                tapToPlayLabel.removeFromParent();
            }
            
            if let sound = self.childNodeWithName("sound") {
                self.removeChildrenInArray([sound]);
            }
            
            startGame();
            
        }
    }
    
    func toggleSound() {
        if let soundNode = self.childNodeWithName("sound") as? SKSpriteNode {
            // If a sound node was found,
            if soundOn == true {
                // Turn sound off
                soundNode.texture = textureSoundOff;
                soundOn = false;
            } else {
                // Turn sound on
                soundNode.texture = textureSoundOn;
                soundOn = true;
            }
        }
        
    }
   
    func gameOver(type: String) {
        
        if type == "survivor" {
            playSound(soundSurvivor);
        } else {
            playSound(soundZombie);
            showBloodSplatter();
        }

        showTitle();
        
        playingGame = false;
        
        // Delete the left/right nodes
        if let left = self.childNodeWithName("left") {
            left.removeAllActions();
            self.removeChildrenInArray([left]);
        }
        if let right = self.childNodeWithName("right") {
            right.removeAllActions();
            self.removeChildrenInArray([right]);
        }
        
        // Create the white overlay
        showBloodSplatter();
        
        // Show 'Try Again' label
        let actionWait = SKAction.waitForDuration(tryAgainWaitTimer);
        let actionCreateTryAgainLabel = SKAction.runBlock {
            self.tryAgainWait = false;
            self.createTapToPlayLabel();
        }
        
        runAction(SKAction.sequence([actionWait, actionCreateTryAgainLabel]));
        
        createSoundIcon();
    }
    
    func createTapToPlayLabel() {
        let tapToPlayAgainLabel = SKLabelNode();
        tapToPlayAgainLabel.text = "Tap to Play";
        tapToPlayAgainLabel.fontName = "Deanna";
        tapToPlayAgainLabel.fontSize = 70;
        tapToPlayAgainLabel.name = "tapToPlay";
        tapToPlayAgainLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height * 0.43);
        tapToPlayAgainLabel.zPosition = 8;
        
        self.addChild(tapToPlayAgainLabel);
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}

extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
