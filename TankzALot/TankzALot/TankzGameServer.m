//
//  TankzGameServer.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameServer.h"

@interface TankzGameServer ()

@property (strong,nonatomic) TankzGameState *gameState;

@end

@implementation TankzGameServer

-(id)init{
    self.gravity=10;
    return self;
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
            
            playerState.fuel = playerFuel-1;
            
        }
        
    }else if(playerCommand == TankzPlayerCommandMoveRight){
        
        int playerFuel = playerState.fuel;
        if (playerFuel>0){
            //STUB: update CGPoint position
            
            playerState.fuel = playerFuel-1;
            
        }
        
    }else if(playerCommand == TankzPlayerCommandAimCCW){
        if (playerState.turretPosition>180){
            playerState.turretPosition++;
        }
        
    }else if(playerCommand == TankzPlayerCommandAimCW){
        if(playerState.turretPosition<0){
            playerState.turretPosition--;
        }
    }else if(playerCommand == TankzPlayerCommandFire){
        //STUB: fire, move to next player(who isn't dead), handle damage
        
        int vertComponent = [self calculateVerticalComponent:playerState.power andTurretPosition:playerState.turretPosition];
        int horizComponent = [self calculateHorizontalComponent:playerState.power andTurretPosition:playerState.turretPosition];
        
        float timeTraveled = 2*playerState.power/self.gravity;
        
        int distance = timeTraveled*horizComponent;
        
    }
    
    
    
}


-(int)calculateHorizontalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * cos(M_PI/180*turretPosition);
}
-(int)calculateVerticalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * sin(M_PI/180*turretPosition);
}

@end
