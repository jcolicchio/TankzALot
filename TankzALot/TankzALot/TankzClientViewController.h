//
//  TankzClientViewController.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameServer.h"
#import "TankzScene.h"
#import <UIKit/UIKit.h>

//animation controller
typedef enum{
    TankzStop = 0,
    TankzMoveLeft = 1,
    TankzMoveRight = 2,
    TankzAimDown = 3,
    TankzAimUp = 4,
} TankzMove;

@interface TankzClientViewController : UIViewController

@property (strong, nonatomic) TankzGameServer *gameServer;

@property (nonatomic) int my_player_id;

@property (nonatomic, strong) TankzScene *scene;

@property (nonatomic) int animation_engaged;

@property (nonatomic) dispatch_source_t _timer;

-(id)initwithPlayerID:(int) playerID  andSession:(MCSession * ) session;

- (void) updateWithGameState:(TankzGameState*)gameState;

@end
