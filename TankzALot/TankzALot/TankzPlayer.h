//
//  TankzPlayer.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TankzPlayer : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (nonatomic) int playerID;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) int health;
@property (nonatomic) int turretPosition; // 0-180. 180 is dead left, 0 is dead right.
@property (nonatomic) CGPoint position;
@property (nonatomic) int fuel;
@property (nonatomic) int power;

@end
