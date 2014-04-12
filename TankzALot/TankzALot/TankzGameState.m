//
//  TankzGameState.m
//  TankzALot
//
//  Created by Novacoast User on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameState.h"

@implementation TankzGameState


-(TankzGameState*)copyGameState
{
    TankzGameState *newGameState = [[TankzGameState alloc] init];
    newGameState.playerList = [NSMutableArray arrayWithArray:self.playerList];
    newGameState.turn = self.turn;
    newGameState.playingState = self.playingState;
    
    return newGameState;
}


@end


