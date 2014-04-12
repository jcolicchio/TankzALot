//
//  TankzGameServer.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TankzGameState.h"
#import "TankzPlayer.h"

typedef enum{
    TankzPlayerCommandMoveLeft = 0,
    TankzPlayerCommandMoveRight = 1,
    TankzPlayerCommandAimCW = 2,
    TankzPlayerCommandAimCCW = 3,
    TankzPlayerCommandFire = 4
    
} TankzPlayerCommand;



@interface TankzGameServer : NSObject


@property (nonatomic) int gravity;

//used by client to obtain current game state
-(TankzGameState*)getGameState;

//used by client to update current game state
-(void)sendPlayerCommand:(TankzPlayerCommand)playerCommand andPlayerID:(int)playerID;


@end
