//
//  TankzScene.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "TankzGameState.h"

@interface TankzScene : SKScene

@property int playerCount;


- (id) initWithSize:(CGSize)size andPlayerCount:(int)count;

- (void) updateWithGameState:(TankzGameState *)GameState;

@end
