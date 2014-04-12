//
//  TankzScene.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzScene.h"

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

// tank building function
// creates a color-colored tank
// at position Pos
- (SKSpriteNode *)newTankwithColor:(SKColor *)Color withPosition:(CGPoint)Pos
{
    SKSpriteNode *treads = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(50, 5)];
    
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(60, 15)];
    
    hull.position = CGPointMake(Pos.x, Pos.y + hull.size.height/2 + treads.size.height/2);
    
    treads.position = CGPointMake(0, -hull.size.height/2 - treads.size.height/2);
    
    [hull addChild:treads];
    
    SKSpriteNode *turret = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(40, 10)];
    
    turret.position = CGPointMake(0, hull.size.height/2 + turret.size.height/2);
    
    [hull addChild:turret];
    
    SKSpriteNode *gun = [[SKSpriteNode alloc] initWithColor:Color size:CGSizeMake(20, 3)];
    
    gun.position = CGPointMake(turret.size.width/2 + gun.size.width/2, 0);
    
    [turret addChild:gun];
    
    return hull;
}

@end
