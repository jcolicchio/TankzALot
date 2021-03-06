//
//  TankzGameServer.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "TankzGameState.h"
#import "TankzPlayer.h"

typedef enum{
    TankzPlayerCommandMoveLeft = 0,
    TankzPlayerCommandMoveRight = 1,
    TankzPlayerCommandAimCW = 2,
    TankzPlayerCommandAimCCW = 3,
    TankzPlayerCommandFire = 4
    
} TankzPlayerCommand;

@class TankzClientViewController;

@interface TankzGameServer : NSObject <MCSessionDelegate>

@property (nonatomic, strong) TankzClientViewController *viewController;




//init modified with ViewController
-(id)initWithViewController:(TankzClientViewController*)vc andSession:(MCSession *) session;

//used by client to obtain current game state
-(TankzGameState*)getGameState;

//used by client to update current game state
-(void)sendPlayerCommand:(TankzPlayerCommand)playerCommand andPlayerID:(int)playerID;


@end
