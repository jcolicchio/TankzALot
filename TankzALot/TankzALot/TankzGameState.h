//
//  TankzGameState.h
//  TankzALot
//
//  Created by Novacoast User on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TankzPlayingStateReady = 0,
    TankzPlayingStateRunning = 1,
    TankzPlayingStateDone = 2
}TankzPlayingState;

@interface TankzGameState : NSObject


@property (strong,nonatomic) NSMutableArray *playerList;
@property (nonatomic) int turn;
@property (nonatomic) TankzPlayingState playingState;

-(TankzGameState*)copyGameState;
@end
