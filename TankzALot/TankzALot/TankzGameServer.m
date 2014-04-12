//
//  TankzGameServer.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameServer.h"
#import "TankzClientViewController.h"

@interface TankzGameServer ()

@property (strong,nonatomic) TankzGameState *gameState;

@end

@implementation TankzGameServer

-(id)initWithViewController:(TankzClientViewController*)vc{
    if(self = [super init]){
        self.gravity=10;
        self.gameState.turn=0;
        //initialize game with number of players
        [self startGame:2];
    }
    return self;
}
-(void)startGame:(int)numPlayers{
    TankzPlayer* player1 = [[TankzPlayer alloc] init];
    player1.name = @"Player1";
    player1.playerID = 0;
    player1.position = CGPointMake(200,200);
    player1.turretPosition = 0;
    player1.health = 100;
    player1.fuel = 100;
    player1.power = 50;
    
    [self.gameState.playerList addObject:player1];
    
    TankzPlayer* player2 = [[TankzPlayer alloc] init];
    player2.name = @"Player2";
    player2.playerID = 0;
    player2.position = CGPointMake(100,200);
    player2.turretPosition = 0;
    player2.health = 100;
    player2.fuel = 100;
    player2.power = 50;
    
    [self.gameState.playerList addObject:player2];
    
    
    
    
}




-(TankzGameState*)getGameState{
    return self.gameState;
    
}

-(void)sendPlayerCommand:(TankzPlayerCommand)playerCommand andPlayerID:(int)playerID{
    
    //validate to make sure it's their turn
    if(playerID != self.gameState.turn){
        return;
    }
    TankzPlayer *playerState = ((TankzPlayer*)[self.gameState.playerList objectAtIndex:playerID]);
    
    //attempt to do the action
    if (playerCommand == TankzPlayerCommandMoveLeft){
        int playerFuel = playerState.fuel;
        if (playerFuel>0){
            //STUB: update CGPoint position
            playerState.position = CGPointMake(playerState.position.x-1, playerState.position.y);
            playerState.fuel = playerFuel-1;
            
        }
        NSLog(@"Move Right");
        
    }else if(playerCommand == TankzPlayerCommandMoveRight){
        
        int playerFuel = playerState.fuel;
        if (playerFuel>0){
            //STUB: update CGPoint position
            playerState.position = CGPointMake(playerState.position.x+1,playerState.position.y);
            playerState.fuel = playerFuel-1;
            
        }
        NSLog(@"Move Right");
        
    }else if(playerCommand == TankzPlayerCommandAimCCW){
        if (playerState.turretPosition>180){
            playerState.turretPosition++;
        }
        NSLog(@"Aim CCW");
    }else if(playerCommand == TankzPlayerCommandAimCW){
        if(playerState.turretPosition<0){
            playerState.turretPosition--;
        }
        NSLog(@"Aim CW");
    }else if(playerCommand == TankzPlayerCommandFire){
        
        int vertComponent = [self calculateVerticalComponent:playerState.power andTurretPosition:playerState.turretPosition];
        int horizComponent = [self calculateHorizontalComponent:playerState.power andTurretPosition:playerState.turretPosition];
        
        float timeTraveled = 2*playerState.power/self.gravity;
        
        int distance = timeTraveled*horizComponent;
        
        //check if shot direction is left or right
        CGPoint bombsite = CGPointMake(playerState.position.x+distance, playerState.position.y);
        
        //check if any players are within range of the bullet
        //deal damage to players within range of bullet
        for(TankzPlayer *player in self.gameState.playerList) {
            int a = player.position.x - bombsite.x;
            int b = player.position.y - bombsite.y;
            int c = sqrt(a*a+b*b);
            
            //TODO:do damage based on distance
            if(c < 3){
                player.health = player.health-50;
            }
        }
        
        //move turn to next player who isn't dead
        
        int numPlayers = [self.gameState.playerList count];
        TankzPlayer *cycledPlayer = (TankzPlayer*)[self.gameState.playerList objectAtIndex:playerID];
        while (cycledPlayer.health < 0){
            self.gameState.turn++;
            if (self.gameState.turn >= numPlayers)
                self.gameState.turn=0;
        }
        
        NSLog(@"Shots Fired!");
        
    }
    
    [self.viewController updateWithGameState:[self getGameState]];
    
}

/*
-(int)main{ //test
    NSMutableArray *phonyPlayerList = [[NSMutableArray alloc] init];
    
    TankzPlayer* phonyPlayer1 = [[TankzPlayer alloc] init];
    
    phonyPlayer1.name = @"Player1";
    
    phonyPlayer1.playerID = 0;
    
    phonyPlayer1.position = CGPointMake(200,200);
    
    phonyPlayer1.turretPosition = 3;
    
    [phonyPlayerList addObject:phonyPlayer1];
    
    TankzPlayer* phonyPlayer2 = [[TankzPlayer alloc] init];
    
    phonyPlayer2.name = @"Player2";
    
    phonyPlayer2.playerID = 1;
    
    
    phonyPlayer2.position = CGPointMake(100,180);
    
    phonyPlayer2.turretPosition = 45;
    
    [phonyPlayerList addObject:phonyPlayer2];
    
    self.gameState.playerList = phonyPlayerList;
    
    NSLog(@"value: %f",phonyPlayer2.turretPosition);
    sendPlayerCommand
    NSLog(@"new value: %f",phonyPlayer2.turretPosition);
    
    return 0;
}
*/

-(int)calculateHorizontalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * cos(M_PI/180*turretPosition);
}
-(int)calculateVerticalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * sin(M_PI/180*turretPosition);
}

@end
