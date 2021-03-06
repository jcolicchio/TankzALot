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

@property (strong, nonatomic) TankzGameState *gameState;
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
    
    [self makeTerrainatHeight:GameState.height];
    
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
    self.gameState = GameState;
    
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
         
            if ( GameState.playingState == TankzPlayingStateFiring && GameState.shooter == player.playerID){
                [self tankFires:tank fromAngle:player.turretPosition * M_PI/180 withPower:player.power withGravity:GameState.gravity stopsAt:GameState.height];
            }
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
    
    SKSpriteNode *healthBar = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(60, 5)];
                               
    healthBar.position = CGPointMake(0, hull.size.height * 2);
    healthBar.name = @"healthBar";
    [hull addChild:healthBar];
    
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

    //rotation animation
    //[gun runAction:[SKAction rotateToAngle:rad duration:0.0]];
    
    gun.zRotation = rad;
}

// how
// maybe just like a straight line for now
- (void) makeTerrainatHeight:(int)height
{
    NSLog(@"Is this actually getting called?");
    
    SKShapeNode *ground = [[SKShapeNode alloc] init];
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, 0, height);
    CGPathAddLineToPoint(pathToDraw, NULL, self.frame.size.width, height);
    ground.path = pathToDraw;
    [ground setStrokeColor:[SKColor orangeColor]];
    [self addChild:ground];
}

- (void) tankFires:(SKSpriteNode*)tank fromAngle:(float)rad withPower:(int)pow withGravity:(int)g stopsAt:(int)terrain
{
    SKSpriteNode *roundHEAT = [[SKSpriteNode alloc] initWithColor:[SKColor whiteColor] size:CGSizeMake(3,3)];
    
    [self addChild:roundHEAT];
    
    //roundHEAT.position = CGPointMake(gun.position.x, gun.position.y);
    
    roundHEAT.position = CGPointMake(tank.position.x, tank.position.y);
    
    //CGMutablePathRef projectilePath = CGPathCreateMutable();

    //CGPoint start = CGPointMake(roundHEAT.position.x + gun.size.width/2,roundHEAT.position.y);
    
    //CGPathMoveToPoint(projectilePath, nil, start.x, start.y);
    
    float velocity_x = pow * cos(rad);
    NSLog(@"scene velocity_x_0: %f", velocity_x);
    float velocity_y = pow * sin(rad);
    NSLog(@"scene velocity_y_0: %f", velocity_y);
    float position_x = roundHEAT.position.x;
    float position_y = roundHEAT.position.y;
    
    NSLog(@"scene position: %f, %f", position_x, position_y);
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    int i = 0;
    while( true ){
        // each iteration represents one time unit
        float timescale = 0.5;
        position_x += velocity_x * timescale;
        position_y += velocity_y * timescale;
        velocity_y -= g * timescale;
        
        //SKAction sequence:
        //[roundHEAT runAction:[SKAction moveTo:CGPointMake(position_x, position_y) duration:0.1]];
        
        if(position_y < terrain){
            break;
        }
        
        //[actions addObject:[SKAction moveTo:CGPointMake(position_x, position_y) duration:0.1]];
        //the bullet will be at position_x, position_y
        //for each tank past frame 2, make sure
        BOOL hit = false;
        if(i > 2) {
            for(TankzPlayer *player in self.gameState.playerList) {
                int a = (player.position.x - position_x);
                int b = (player.position.y - position_y);
                int c = sqrt(a*a+b*b);
                
                if( c < 25) {
                    //DIRECT HIT!
                    hit = true;
                    break;
                }
            }
        }
        if(hit)
            break;
        [actions addObject:[SKAction moveTo:CGPointMake(position_x, position_y) duration:0.1]];

        i++;
    }
    
    
    [roundHEAT runAction:[SKAction sequence:@[[SKAction sequence:actions], [SKAction removeFromParent]]] completion:^{
      
        for(TankzPlayer *player in self.gameState.playerList) {
            //Update the health bar
            int healthValue = player.health;
            int length = (healthValue/100.0) * 60;
            
            SKSpriteNode* tank = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"%d",player.playerID]];
            
            SKSpriteNode *healthBar =  (SKSpriteNode*) [tank childNodeWithName:@"healthBar"];
            NSLog(@"HEALTH VALUE IS %d",healthValue);
            NSLog(@"HEALTH BAR IS %d",length);
            
            healthBar.size = CGSizeMake(length, 5);
            if (healthValue < 50)
                healthBar.color = [SKColor yellowColor];
            if (healthValue < 25)
                healthBar.color = [SKColor redColor];
            
            if(healthValue <= 0)
                [tank setHidden:YES];
        }
        
        if(self.gameState.winner > -1) {
            //declare the winner!
            SKLabelNode *winner = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
            [winner setText:@"Tankz For Playing!"];
            [winner setFontSize:25.0];
            [winner setColor:[UIColor whiteColor]];
            [winner setPosition:CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame))];
            [self addChild:winner];
        }
    }];
}

-(float)calculateHorizontalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * cos(turretPosition);
}
-(float)calculateVerticalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * sin(turretPosition);
}

@end
