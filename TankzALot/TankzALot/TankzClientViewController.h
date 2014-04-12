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

@interface TankzClientViewController : UIViewController

@property (strong, nonatomic) TankzGameServer *gameServer;

@property (nonatomic) int my_player_id;

@property (nonatomic, strong) TankzScene *scene;

- (void) initalizeToGameState:(TankzGameState *)gameState;

- (void) updateWithGameState:(TankzGameState*)gameState;

@end
