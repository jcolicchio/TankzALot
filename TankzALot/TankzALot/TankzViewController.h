//
//  TankzViewController.h
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface TankzViewController : UIViewController <MCNearbyServiceAdvertiserDelegate,MCSessionDelegate,MCNearbyServiceBrowserDelegate, MCBrowserViewControllerDelegate>
//MCBrowserViewControllerDelegate
@property BOOL isHost;
@property BOOL onWaitScreenClient;
@property (strong,nonatomic) MCPeerID * host;


@end
