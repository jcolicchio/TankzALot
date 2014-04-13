//
//  TankzPlayer.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzPlayer.h"

@implementation TankzPlayer

- (id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.playerID = [aDecoder decodeIntForKey:@"playerID"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.health = [aDecoder decodeIntForKey:@"health"];
        self.turretPosition = [aDecoder decodeIntForKey:@"turretPosition"];
        self.position = [aDecoder decodeCGPointForKey:@"position"];
        self.fuel = [aDecoder decodeIntForKey:@"fuel"];
        self.power = [aDecoder decodeIntForKey:@"power"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInt:self.playerID forKey:@"playerID"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeInt:self.health forKey:@"health"];
    [aCoder encodeInt:self.turretPosition forKey:@"turretPosition"];
    [aCoder encodeCGPoint:self.position forKey:@"position"];
    [aCoder encodeInt:self.fuel forKey:@"fuel"];
    [aCoder encodeInt:self.power forKey:@"power"];
}

@end
