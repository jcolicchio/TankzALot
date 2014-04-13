//
//  TankzViewController.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzClientViewController.h"
#import "TankzViewController.h"

#import "TankzGameServer.h"

@interface TankzViewController ()

@property (strong,nonatomic) MCSession *session;
//@property (strong,nonatomic) MCBrowserViewController * browserVC;
@property (strong,nonatomic) MCNearbyServiceBrowser * browser;
@property (strong,nonatomic) MCPeerID *localPeerID;
@property (strong,nonatomic) MCNearbyServiceAdvertiser *advertiser;


//Joiner's view
//@property (nonatomic, strong) MCAdvertiserAssistant *games_list;


//MCSessionState

@end

@implementation TankzViewController



static NSString * const XXServiceType = @"TankzALot";

-(void)showBrowse {
    self.isHost = NO;
    [self.browser startBrowsingForPeers];
    
    self.waitingVC = [[TankzWaitingViewController alloc] initWithSession:self.session isHost:self.isHost];
    [self presentViewController:self.waitingVC animated:YES completion:nil];
    self.onWaitScreenClient = YES;

    
//    //Other way of doing it
//    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:XXServiceType session:self.session];
//    self.browserVC.delegate = self;
//
//    
////    [self presentViewController:self.browserVC
////                       animated:YES
////                     completion:
////     ^{
////         [self.browser startBrowsingForPeers];
////     }];
//// 
//    
//    [self presentViewController:self.browserVC animated:YES completion:nil];
//    
    NSLog(@"BROWSING");
    
}

-(void)advertise {

    if(self.session){
        [self.session disconnect];
    }
    self.host = self.localPeerID;
    self.isHost = YES;
    
    self.advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                      discoveryInfo:nil
                                        serviceType:XXServiceType];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
    
    self.waitingVC = [[TankzWaitingViewController alloc] initWithSession:self.session isHost:self.isHost];
    [self presentViewController:self.waitingVC animated:YES completion:nil];
    self.onWaitScreenClient = YES;

    
    NSLog(@"ADVERTISING");

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //Browse Button
    UIButton *browseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    browseButton.frame = CGRectMake(0, 22, self.view.frame.size.width, 40.0);
    [browseButton setBackgroundColor:[UIColor grayColor]];
    [browseButton addTarget:self action:@selector(showBrowse) forControlEvents:UIControlEventTouchUpInside];
    [browseButton setTitle:@"Browse" forState:UIControlStateNormal];
    [self.view addSubview:browseButton];
    
    //Advertise Button
    UIButton *advertiseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    advertiseButton.frame = CGRectMake(0, 22 + browseButton.frame.size.height , self.view.frame.size.width, 40.0);
    [advertiseButton setBackgroundColor:[UIColor grayColor]];
    [advertiseButton addTarget:self action:@selector(advertise) forControlEvents:UIControlEventTouchUpInside];
    [advertiseButton setTitle:@"Advertise" forState:UIControlStateNormal];
    [self.view addSubview:advertiseButton];
    
    
    //Create peer ID (we can change later, but probably wont)
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    //Initalize Browser view
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID serviceType:XXServiceType];
    self.browser.delegate = self;

    //    self.browserVC =
    //    [[MCBrowserViewController alloc] initWithBrowser:self.browser
    //                                             session:self.session];
    
    
    
    //Create session
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    
    NSLog(@"VIEW DID LOAD, CREATED SESSION");

    

}

-(void)resetSession {
    NSLog(@"REESETING SESSION");
//    if(self.session)
//        [self.session disconnect];
//    self.waitingVC = nil;
    self.host = nil;
    self.isHost = NO;
    self.onWaitScreenClient = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)launchGame:(id)sender {
    
    [self presentViewController:[[TankzClientViewController alloc] initwithPlayerID:0 andSession:self.session] animated:YES completion:nil];
}

-(void) launchGame {
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:[[TankzClientViewController alloc] initwithPlayerID:0           andSession:self.session] animated:YES completion:nil];
        }];
    });
}


-(void) browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"LOST PEER %@", peerID.displayName);
    
}
-(void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    NSLog(@"FOUND PEER %@", peerID.displayName);
    [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:1000];
    NSLog(@"SENT AN INVITATION");

}
-(void) browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
    [self.browser stopBrowsingForPeers];
    NSLog(@"BROSWER VIEW CONTROLLER FINISHED");
}

-(void) browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    NSLog(@"broswer view controller was canceled");
    [self.browser stopBrowsingForPeers];
    //[self.browserVC dismissViewControllerAnimated:YES completion:nil];
    
    [self resetSession];
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@" Session shit");
    
}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@" Session shit did start to recieve");
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"WE RECIEVED A MESSAGE");
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", message);
    
    //Start the game!
    self.session.delegate = nil;
    [self launchGame];
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@" Session shit receive stream");
    
}


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSLog(@"isHost: %d onWaitScreenClient %d",self.isHost,self.onWaitScreenClient);
    NSLog(@"Peer %@ changed to state %@",peerID.displayName,[NSNumber numberWithInt:state]);
    NSLog(@"Number of peers: %d",self.session.connectedPeers.count);
    
    if(!self.onWaitScreenClient && !self.isHost) {
        self.host = peerID;
    }
    
    if(self.onWaitScreenClient) {
        [self.waitingVC userChange:self.session.connectedPeers];
        NSLog(@"UPDATING USERCHANGE");
    }
    
    //If the host disconnects, send everyone back to the main menu
    if(self.session.connectedPeers.count == 0 && state == 0) {
        NSLog(@"DISMISSING SCREEN");
        dispatch_async(dispatch_get_main_queue(),^{
            [self.waitingVC dismissViewControllerAnimated:YES completion:^{
                [self resetSession];
            }];
        });
    }
    

//    if([peerID.displayName isEqualToString:self.host.displayName] && state == 0 && !self.isHost) {
//        NSLog(@"state: %d displayname %@",state,peerID.displayName);
//
//        NSLog(@"HOST WENT DOWN, EXITING SCREEN");
//        if(self.browser)
//            [self.browser stopBrowsingForPeers];
//        if(self.waitingVC) {
//            NSLog(@"GONNA DELETE SOME WAITING VC");
//            [self.waitingVC dismissViewControllerAnimated:YES completion:^{
//                [self resetSession];
//            }];
//        }
//    } else if(!self.isHost && !self.onWaitScreenClient) {
//        NSLog(@"NEW HOST IS: %@",peerID.displayName);
//        self.host = peerID;
//        self.onWaitScreenClient = YES;
//        [self.browser stopBrowsingForPeers];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            BOOL test = YES;
////            [self.browserVC dismissViewControllerAnimated:YES completion:^{
////                self.waitingVC = [[TankzWaitingViewController alloc] initWithSession:session isHost:self.isHost ];
////                [self presentViewController:self.waitingVC animated:YES completion:nil];
////            }];
//        });
//        
//    }
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    invitationHandler(YES, self.session);

}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
}



@end
