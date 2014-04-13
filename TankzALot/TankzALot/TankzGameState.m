//
//  TankzGameState.m
//  TankzALot
//
//  Created by Novacoast User on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameState.h"

@implementation TankzGameState

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.playerList forKey:@"playerList"];
    [aCoder encodeInt:self.turn forKey:@"turn"];
    [aCoder encodeInt:self.shooter forKey:@"shooter"];
    [aCoder encodeInt:self.gravity forKey:@"gravity"];
    [aCoder encodeInt:self.height forKey:@"height"];
    [aCoder encodeInt:self.playingState forKey:@"playingState"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.playerList = [aDecoder decodeObjectForKey:@"playerList"];
        self.turn = [aDecoder decodeIntForKey:@"turn"];
        self.shooter = [aDecoder decodeIntForKey:@"shooter"];
        self.gravity = [aDecoder decodeIntForKey:@"gravity"];
        self.height = [aDecoder decodeIntForKey:@"height"];
        self.playingState = [aDecoder decodeIntForKey:@"playingState"];
    }
    
    return self;
}

-(TankzGameState*)copyGameState
{
    TankzGameState *newGameState = [[TankzGameState alloc] init];
    newGameState.playerList = [NSMutableArray arrayWithArray:self.playerList];
    newGameState.turn = self.turn;
    newGameState.gravity = self.gravity;
    newGameState.playingState = self.playingState;
    
    return newGameState;
}


@end


