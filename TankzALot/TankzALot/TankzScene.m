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
    
    NSLog(@"Scene's initialize is getting called.");
    
    [self makeTerrain];
    
    NSMutableArray * playerList = GameState.playerList;
    for (TankzPlayer *player in playerList) {
        NSLog(@"%d", player.playerID);
        
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
    
    // it should just move already existing tanks.
    NSMutableArray * playerList = GameState.playerList;
    for (TankzPlayer *player in playerList) {
        
        SKSpriteNode* tank = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"%d",player.playerID]];
        
        
        if( tank ){
            
            // move to next point
            [self moveTank:tank to:player.position];
                
            float angle = player.turretPosition * M_PI/180;
            // now set the angle of the player's gun
            [self setGunArc:angle ofTank:tank];
         
            [self tankFires:tank fromAngle:player.turretPosition * M_PI/180 withPower:player.power withGravity:GameState.gravity];
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
    
    hull.xScale = 0.5;
    hull.yScale = 0.5;
    
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

    [gun runAction:[SKAction rotateToAngle:rad duration:0.0]];
}

// how
// maybe just like a straight line for now
- (void) makeTerrain
{
    NSLog(@"Is this actually getting called?");
    
    SKShapeNode *ground = [[SKShapeNode alloc] init];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, 0, 100);
    CGPathAddLineToPoint(pathToDraw, NULL, self.frame.size.width, 100);
    ground.path = pathToDraw;
    [ground setStrokeColor:[SKColor orangeColor]];
    [self addChild:ground];
}

- (void) tankFires:(SKSpriteNode*)tank fromAngle:(float)rad withPower:(int)pow withGravity:(int)g
{
    SKSpriteNode *roundHEAT = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(3,3)];
    
    SKSpriteNode *gun = (SKSpriteNode*) [[tank childNodeWithName:@"turret"] childNodeWithName:@"gun"];
    
    [self addChild:roundHEAT];
    
    //roundHEAT.position = CGPointMake(gun.position.x, gun.position.y);
    
    roundHEAT.position = CGPointMake(gun.position.x, gun.position.y);
    
    //[gun addChild:roundHEAT];
    
    CGMutablePathRef projectilePath = CGPathCreateMutable();

    CGPoint start = CGPointMake(roundHEAT.position.x + gun.size.width/2,roundHEAT.position.y);
    
    CGPathMoveToPoint(projectilePath, nil, start.x, start.y);
    
    float velocity_x = pow * cos(rad);
    
    float velocity_y = pow * sin(rad);
    
    float position_x = 0;
    float position_y = 0;
    
    while( true ){
        // each iteration represents one time unit
        float timescale = 0.1;
        position_x += velocity_x * timescale;
        position_y += velocity_y * timescale;
        velocity_y -= g * timescale;
        
        [roundHEAT runAction:[SKAction moveTo:CGPointMake(position_x, position_y) duration:0.1]];
        
        if(position_y < 0){
            break;
        }
        
    }/*
    
    int vertComponent = [self calculateVerticalComponent:pow andTurretPosition:rad];
    int horizComponent = [self calculateHorizontalComponent:pow andTurretPosition:rad];
    
    float timeTraveled = 2*(vertComponent)/g;
    
    int distance = timeTraveled*horizComponent;
    
    CGPoint finish = CGPointMake(start.x + distance, start.y);
    
    // temp!
    //CGPathAddCurveToPoint(projectilePath, 0, timeTraveled/3 * horizComponent, (2*vertComponent) / (3*g), 2 * timeTraveled/3, (4*vertComponent) / (3*g), finish.x, finish.y);
    CGPathAddCurveToPoint(projectilePath, 0, 30, 60, 60, 60, finish.x, finish.y);
    
    SKAction * projectileMotion = [SKAction followPath:projectilePath duration:1.0];

    
    [roundHEAT runAction:projectileMotion];
      */
    
    
}

-(int)calculateHorizontalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * cos(turretPosition);
}
-(int)calculateVerticalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * sin(turretPosition);
}

@end
