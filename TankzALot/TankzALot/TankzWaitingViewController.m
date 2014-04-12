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

-(id) initWithSession:(MCSession * ) session isHost:(BOOL)isHost {
    if(self = [super init]) {
        self.session = session;
        self.isHost = isHost;
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

    // Do any additional setup after loading the view.
}

-(void)onCancelButtonClick {
    
    [self.session disconnect];
    
    TankzViewController *tankzVC = (TankzViewController *)[self presentingViewController];
    tankzVC.isHost = NO;
    tankzVC.isClient = NO;
    tankzVC.onWaitScreenClient = NO;
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"CLICKED CANCEL BUTTON");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)userChange:(NSArray *) connectedUsers {
    [self.tableView reloadData];
    
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
