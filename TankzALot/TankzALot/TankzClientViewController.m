//
//  TankzClientViewController.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TankzClientViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface TankzClientViewController ()

@end

@implementation TankzClientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    
    self.animation_engaged = 0;
    
    return self;
}

-(id)initwithPlayerID:(int) playerID  andSession:(MCSession * ) session {
    if(self) {
        self.my_player_id = playerID;
        self.gameServer = [[TankzGameServer alloc] initWithViewController:self andSession:session];

    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the game server
    /*
    // for now, we'll create a fake gamestate and update once.
    TankzGameState* phonyGameState = [[TankzGameState alloc] init];
    
    NSMutableArray *phonyPlayerList = [[NSMutableArray alloc] init];
    
    TankzPlayer* phonyPlayer1 = [[TankzPlayer alloc] init];
    
    phonyPlayer1.name = @"Player1";
    
    phonyPlayer1.playerID = 0;
    
    phonyPlayer1.color = [SKColor orangeColor];
    
    phonyPlayer1.position = CGPointMake(200,200);
    
    phonyPlayer1.turretPosition = 3;
    
    [phonyPlayerList addObject:phonyPlayer1];
    
    TankzPlayer* phonyPlayer2 = [[TankzPlayer alloc] init];
    
    phonyPlayer2.name = @"Player2";
    
    phonyPlayer2.playerID = 1;
    
    phonyPlayer2.color = [SKColor blueColor];
    
    phonyPlayer2.position = CGPointMake(100,180);
    
    phonyPlayer2.turretPosition = 45;
    
    [phonyPlayerList addObject:phonyPlayer2];
    
    phonyGameState.playerList = phonyPlayerList;
    */
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
    SKView *spriteView = (SKView *) self.view;
    
    //spriteView.showsDrawCount = YES;
    //spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    self.scene = [[TankzScene alloc] initWithSize:spriteView.bounds.size];
    
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    [spriteView presentScene:self.scene];

    TankzGameState * initialGameState = [self.gameServer getGameState];
    [self.scene initalizeToGameState:initialGameState];
    //phonyPlayer2.turretPosition += 45;
    //[self.scene updateWithGameState:phonyGameState];
    
    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *fireButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    CGSize buttonSize = CGSizeMake(60, 40);
    [leftButton setFrame:CGRectMake(0, self.view.frame.size.height - buttonSize.height*1.5f, buttonSize.width, buttonSize.height)];
    [downButton setFrame:CGRectMake(buttonSize.width, self.view.frame.size.height - buttonSize.height, buttonSize.width, buttonSize.height)];
    [rightButton setFrame:CGRectMake(2*buttonSize.width, self.view.frame.size.height - buttonSize.height*1.5f, buttonSize.width, buttonSize.height)];
    [upButton setFrame:CGRectMake(buttonSize.width, self.view.frame.size.height - buttonSize.height*2.0f, buttonSize.width, buttonSize.height)];
    
    [fireButton setFrame:CGRectMake(self.view.frame.size.width - buttonSize.width * 1.5f, self.view.frame.size.height - buttonSize.height * 1.5f, buttonSize.width * 1.5f, buttonSize.height * 1.5f)];
    
    [self createTimer];
    
    [leftButton addTarget:self action:@selector(pressLeft) forControlEvents:UIControlEventTouchDown];
    [downButton addTarget:self action:@selector(pressDown) forControlEvents:UIControlEventTouchDown];
    [rightButton addTarget:self action:@selector(pressRight) forControlEvents:UIControlEventTouchDown];
    [upButton addTarget:self action:@selector(pressUp) forControlEvents:UIControlEventTouchDown];
    [fireButton addTarget:self action:@selector(fire) forControlEvents:UIControlEventTouchDown];
    
    [upButton addTarget:self action:@selector(stopAnim) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [downButton addTarget:self action:@selector(stopAnim) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [leftButton addTarget:self action:@selector(stopAnim) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [rightButton addTarget:self action:@selector(stopAnim) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [downButton setTitle:@"V" forState:UIControlStateNormal];
    [rightButton setTitle:@">" forState:UIControlStateNormal];
    [upButton setTitle:@"^" forState:UIControlStateNormal];
    
    [fireButton setTitle:@"FIRE" forState:UIControlStateNormal];
    
    [leftButton setBackgroundColor:[UIColor blackColor]];
    [downButton setBackgroundColor:[UIColor blackColor]];
    [rightButton setBackgroundColor:[UIColor blackColor]];
    [upButton setBackgroundColor:[UIColor blackColor]];
    [fireButton setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:leftButton];
    [self.view addSubview:downButton];
    [self.view addSubview:rightButton];
    [self.view addSubview:upButton];
    [self.view addSubview:fireButton];
    
    // I guess here is where we go
    // while (TankzGameServer says it's not my turn)
    // {
    //      [scene updateWithGameState:[gameServer getGameState]];
    // }
    
}

- (TankzScene *)display
{
    SKView *spriteView = (SKView *) self.view;
    
    TankzScene *scene = [[TankzScene alloc] initWithSize:spriteView.bounds.size];
    
    return scene;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// redundancy ahoy
// someone should figure out how to turn every press down event into one function
// but it isn't going to be me

- (void) createTimer {
    if(!self._timer){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self._timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                                  
        float timeoutInSeconds = 0.1;
                                  
        dispatch_source_set_timer(self._timer, dispatch_time(DISPATCH_TIME_NOW,timeoutInSeconds * NSEC_PER_SEC), timeoutInSeconds * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        
          dispatch_source_set_event_handler(self._timer, ^{
                if( self.animation_engaged == TankzAimUp ){
                    [self.gameServer sendPlayerCommand:TankzPlayerCommandAimCCW andPlayerID:self.my_player_id];
                }else if ( self.animation_engaged == TankzAimDown ) {
                        [self.gameServer sendPlayerCommand:TankzPlayerCommandAimCW andPlayerID:self.my_player_id];
                }else if ( self.animation_engaged == TankzMoveLeft ) {
                    [self.gameServer sendPlayerCommand:TankzPlayerCommandMoveLeft andPlayerID:self.my_player_id];
                }else if ( self.animation_engaged == TankzMoveRight ) {
                    [self.gameServer sendPlayerCommand:TankzPlayerCommandMoveRight andPlayerID:self.my_player_id];
                }
                else {
                    // nothing
                }
          });
        
    }
    dispatch_resume(self._timer);
}

- (void) pressUp {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gameServer sendPlayerCommand:TankzPlayerCommandAimCCW andPlayerID:self.my_player_id];
        self.animation_engaged = TankzAimUp;
    });
}

- (void) pressDown {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gameServer sendPlayerCommand:TankzPlayerCommandAimCW andPlayerID:self.my_player_id];
        self.animation_engaged = TankzAimDown;
    });
}

- (void) pressLeft {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gameServer sendPlayerCommand:TankzPlayerCommandMoveLeft andPlayerID:self.my_player_id];
        self.animation_engaged = TankzMoveLeft;
    });
}

- (void) pressRight {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gameServer sendPlayerCommand:TankzPlayerCommandMoveRight andPlayerID:self.my_player_id];
        self.animation_engaged = TankzMoveRight;
    });
}

- (void) stopAnim{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.animation_engaged = TankzStop;
    });
}

- (void) fire{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gameServer sendPlayerCommand:TankzPlayerCommandFire andPlayerID:self.my_player_id];
    });
}

- (void) updateWithGameState:(TankzGameState *)gameState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.scene updateWithGameState:gameState];
    });
}

@end
