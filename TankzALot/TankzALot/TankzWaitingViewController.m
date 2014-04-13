//
//  TankzWaitingViewController.m
//  TankzALot
//
//  Created by App Jam on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzViewController.h"
#import "TankzWaitingViewController.h"
#import "NameCell.h"
@interface TankzWaitingViewController ()


@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) MCSession *session;
@property (strong,nonatomic) UILabel *label;

@property BOOL isHost;

@end

@implementation TankzWaitingViewController


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.session.connectedPeers count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NameCell * nameCell = [self.tableView dequeueReusableCellWithIdentifier:@"nameCell"];
    
//    [nameCell.titleLabel setText:@"DICKS DICKS DICKS"];
    NSString * text = ((MCPeerID *)[self.session.connectedPeers objectAtIndex:indexPath.row]).displayName;
    [nameCell.titleLabel setText:text];

    return nameCell;
}

-(id) initWithSession:(MCSession * ) session isHost:(BOOL)isHost advertiser:(MCNearbyServiceAdvertiser *)advertiser {
    if(self = [super init]) {
        self.session = session;
        self.isHost = isHost;
        self.advertiser = advertiser;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 + 60, self.view.frame.size.width, self.view.frame.size.height/2 - 60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    
    [self.tableView registerClass:[NameCell class] forCellReuseIdentifier:@"nameCell"];
    
    
    
    //Text
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, 60)];
    self.label.text = @"Currently connected players";
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if(self.isHost)
        cancelButton.frame = CGRectMake(0, 22, self.view.frame.size.width/2, 38);
    else //Split the button in 2, one for cancel, for for okay
        cancelButton.frame = CGRectMake(0, 22, self.view.frame.size.width, 38);
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton addTarget:self action:@selector(onCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];

    
    //Start game button
    if(self.isHost) {
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        startButton.frame = CGRectMake(self.view.frame.size.width/2, 22, self.view.frame.size.width/2, 38);
        [startButton setBackgroundColor:[UIColor whiteColor]];
        [startButton addTarget:self action:@selector(onStartButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.view addSubview:startButton];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void) onStartButtonClick {
    
  
    NSError *error = nil;
    NSLog(@"THERE IS A PROBLEM HERE");
    NSLog(@"SIZE OF ARRAY %d",self.session.connectedPeers.count);
    
    for (int i = 0; i < self.session.connectedPeers.count; i++) {
        NSString *message = [NSString stringWithFormat:@"%d", (i + 1)];
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        if (![self.session sendData:data
                            toPeers:@[[self.session.connectedPeers objectAtIndex:i]]
                           withMode:MCSessionSendDataReliable
                              error:&error]) {
            NSLog(@"[Error] %@", error);
        }
    }
    
    //Tells host to call game as well
    TankzViewController *view = (TankzViewController *)[self presentingViewController];
    [view launchGame:0]; //host always gets the 0 player ID
    
    NSLog(@"stop advertising");
    [self.advertiser stopAdvertisingPeer];

}

-(void)onCancelButtonClick {
    NSLog(@"CLICKED CANCEL BUTTON, DISCONNECTED FROM SESSION");

    [self.session disconnect];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [((TankzViewController *) self.presentingViewController) resetSession];
        [self  dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userChange:(NSArray *) connectedUsers {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    NSLog(@"YO WE GOT A CALLBACK");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
