//
//  TankzScene.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzScene.h"

#import "TankzPlayer.h"

@interface TankzScene ()
@property BOOL contentCreated;
@end

@implementation TankzScene

- (id) initWithSize:(CGSize)size andPlayerCount:(int)count
{
    if( self = [super initWithSize:size] )
    {
        self.playerCount = count;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void) createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    
}

// create the tank sprite nodes based off an initial gamestate. Fuck it.
- (void) initalizeToGameState:(TankzGameState *)GameState
{
    NSMutableArray * playerList = GameState.playerList;
    for (TankzPlayer *player in playerList) {
        
        SKSpriteNode* tank =
        [self newTankwithId:player.playerID withColor:player.color withPosition:player.position];
        
        float angle = player.turretPosition * M_PI/180;
        // now set the angle of the player's gun
        [self setGunArc:angle ofTank:tank];
        
        [self addChild:(tank)];
    }
}

// the big motherfucker of drawing functions
// this guy will take a gamestate, unpack it, and update
// the scene to reflect the new gamestate
- (void) updateWithGameState:(TankzGameState *)GameState
{
    
    // this is going to have to be changed for proper movement
    // for now this will go through the player array and draw
    // tanks
    
    // right now it's creating more tanks with every gamestate update
    // this is dumb.
    
    // it should just move already existing tanks.
    NSMutableArray * playerList = GameState.playerList;
    for (TankzPlayer *player in playerList) {
        NSLog(@"Draw!");
        
        SKSpriteNode* tank = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"%d",player.playerID]];
        
        
        if( tank ){
            
            // move to next point
            [self moveTank:tank to:player.position];
                
            float angle = player.turretPosition * M_PI/180;
            // now set the angle of the player's gun
            [self setGunArc:angle ofTank:tank];
         
        }
    }
}

// tank building function
// creates a color-colored tank
// at position Pos
- (SKSpriteNode *)newTankwithId:(int)playerId withColor:(SKColor *)Color withPosition:(CGPoint)Pos
{
    SKSpriteNode *treads = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(50, 5)];
    
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(60, 15)];
    
    hull.name = [NSString stringWithFormat:@"%d",playerId];
    
    hull.position = CGPointMake(Pos.x, Pos.y + hull.size.height/2 + treads.size.height/2);
    
    treads.position = CGPointMake(0, -hull.size.height/2 - treads.size.height/2);
    
    [hull addChild:treads];
    
    SKSpriteNode *turret = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(40, 10)];
    
    turret.name = @"turret";
    
    turret.position = CGPointMake(0, hull.size.height/2 + turret.size.height/2);
    
    [hull addChild:turret];
    
    SKSpriteNode *gun = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(30, 3)];
    
    gun.name = @"gun";
    
    //gun.position = CGPointMake(turret.size.width/2 + gun.size.width/2, 0);
    
    gun.anchorPoint = CGPointMake(-0.1, 0);
    
    [turret addChild:gun];
    
    return hull;
}

// needs to be redone to follow terrain when we have a representation of it
- (void) moveTank:(SKSpriteNode *)tank to:(CGPoint)point
{
    [tank runAction:[SKAction moveToX:point.x duration:1.0]];
}

// rotates the gun to the Rad position
- (void) setGunArc:(float)rad ofTank:(SKSpriteNode*)tank
{
    SKSpriteNode *gun = (SKSpriteNode*) [[tank childNodeWithName:@"turret"] childNodeWithName:@"gun"];

    [gun runAction:[SKAction rotateToAngle:rad duration:3.0]];
}

- (void) makeTerrain
{
    
}

@end
