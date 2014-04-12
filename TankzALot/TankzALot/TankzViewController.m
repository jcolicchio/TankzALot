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
#import "TankzWaitingViewController.h"

@interface TankzViewController ()

@property (strong,nonatomic) MCSession *session;
@property (strong,nonatomic) MCBrowserViewController * browserVC;
@property (strong,nonatomic) MCNearbyServiceBrowser * browser;
@property (strong,nonatomic) MCPeerID *localPeerID;
@property (strong,nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (strong,nonatomic) TankzWaitingViewController * waitingVC;

@property BOOL isHost;
@property BOOL isClient;
@property BOOL onWaitScreenClient;

//Joiner's view
//@property (nonatomic, strong) MCAdvertiserAssistant *games_list;


//MCSessionState

@end

@implementation TankzViewController



static NSString * const XXServiceType = @"TankzALot";

-(void)showBrowse {
    self.isClient = YES;
    
//    [self presentViewController:self.browserVC
//                       animated:YES
//                     completion:
//     ^{
//         [self.browser startBrowsingForPeers];
//     }];
// 
    
    [self presentViewController:self.browserVC animated:YES completion:nil];
    
    NSLog(@"BROWSING");
    
}

-(void)advertise {
    self.isHost = YES;
    
    self.advertiser =
    [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                      discoveryInfo:nil
                                        serviceType:XXServiceType];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
    
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
    
    //Create session
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID
                                        securityIdentity:nil
                                    encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    
    
    
    //Initalize Browser view
    
//    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID serviceType:XXServiceType];
//    self.browser.delegate = self;

    //    self.browserVC =
    //    [[MCBrowserViewController alloc] initWithBrowser:self.browser
    //                                             session:self.session];
    
    
    //Other way of doing it
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:XXServiceType session:self.session];
    self.browserVC.delegate = self;
    

}

-(void)goToClientWaitScreen {
    [self browserViewControllerDidFinish : self.browserVC];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Initalize booleans for the fuck of it
    self.onWaitScreenClient = NO;
    self.isHost = NO;
    self.isClient = NO;

    
}


-(MCNearbyServiceBrowser *) initalizeServiceBrowserWithPeerID:(MCPeerID *)localPeerID andServiceType:(NSString *)serviceType {
    
    
    MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:localPeerID serviceType:serviceType];
    browser.delegate = self;
    return browser;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)launchGame:(id)sender {
    [self presentViewController:[[TankzClientViewController alloc] init] animated:YES completion:nil];
}


-(void) browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"PEER SHIT LOST PEER");
    
}
-(void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    //NSLog(@"FOUND PEER");
    //int timeInterval = 10000;
    NSLog(@"FOUND PEER %@", peerID.displayName);
    [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:1000 ];
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
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@" Session shit");
    
}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@" Session shit did start to recieve");
    
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@" Session shit recieved data");
    
}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@" Session shit receive stream");
    
}
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
//    NSDictionary * dict = @{@"peerID": peerID,
//                           @"state" : [NSNumber numberWithInt:state]
//                           };
    
    if(self.isClient && self.onWaitScreenClient) {
        [self.waitingVC userChange:session.connectedPeers];
    }
    
    if(self.isClient && !self.onWaitScreenClient) {
        self.onWaitScreenClient = YES;
        
        [self.browser stopBrowsingForPeers];
        [self.browserVC dismissViewControllerAnimated:YES completion:^{
            self.waitingVC = [[TankzWaitingViewController alloc] initWithSession:session isHost:self.isHost];
            [self presentViewController:self.waitingVC animated:YES completion:^{
                [self.waitingVC userChange:session.connectedPeers]; //Call with the current connected peers(just the one dude);
            }];
        }];
        
    }
    NSLog(@"Peer %@ changed to state %@",peerID.displayName,[NSNumber numberWithInt:state]);
    NSLog(@" Session shit didChangeState");
    
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    invitationHandler(YES, self.session);

}
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
}



@end
