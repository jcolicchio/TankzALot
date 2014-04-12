//
//  TankzPlayer.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TankzPlayer : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) int playerID;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) int health;
@property (nonatomic) int turretPosition;
@property (nonatomic) CGPoint position;
@property (nonatomic) int fuel;
@property (nonatomic) int power;

@end
