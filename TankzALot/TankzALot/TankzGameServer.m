//
//  TankzGameServer.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameServer.h"

@interface TankzGameServer ()

@property (strong,nonatomic) TankzGameState *currentState;
@property (strong,nonatomic) TankzGameState *nextState;

@end

@implementation TankzGameServer



-(TankzGameState*)getGameState{
    return self.currentState;
    
}

@end
