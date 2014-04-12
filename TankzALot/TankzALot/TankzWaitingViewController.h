//
//  TankzWaitingViewController.h
//  TankzALot
//
//  Created by App Jam on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface TankzWaitingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
-(void)userChange:(NSArray *) connectedUsers;

-(id) initWithSession:(MCSession * ) session isHost:(BOOL)isHost;
@end
