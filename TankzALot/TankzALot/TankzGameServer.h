//
//  TankzGameServer.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TankzGameState.h"

@interface TankzGameServer : NSObject

-(TankzGameState*)getGameState;


@end
