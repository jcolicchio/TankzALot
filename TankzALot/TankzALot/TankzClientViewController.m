//
//  TankzClientViewController.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TankzScene.h"
#import "TankzClientViewController.h"

@interface TankzClientViewController ()

@end

@implementation TankzClientViewController

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
    // Do any additional setup after loading the view.
    
    // Initialize the game server
    self.gameServer = [[TankzGameServer alloc] init];
    // gameServer interaction goes here.
    
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
    
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
    SKView *spriteView = (SKView *) self.view;
    
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    TankzScene *scene = [[TankzScene alloc] initWithSize:spriteView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [spriteView presentScene:scene];
    
    [scene initalizeToGameState:phonyGameState];
    phonyPlayer2.turretPosition += 45;
    [scene updateWithGameState:phonyGameState];

    UIButton *upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGSize buttonSize = CGSizeMake(60, 40);
    [leftButton setFrame:CGRectMake(0, self.view.frame.size.height - buttonSize.height, buttonSize.width, buttonSize.height)];
    [downButton setFrame:CGRectMake(160-buttonSize.width/2.0f, self.view.frame.size.height - buttonSize.height, buttonSize.width, buttonSize.height)];
    [rightButton setFrame:CGRectMake(320-buttonSize.width, self.view.frame.size.height - buttonSize.height, buttonSize.width, buttonSize.height)];
    [upButton setFrame:CGRectMake(160-buttonSize.width/2.0f, self.view.frame.size.height - buttonSize.height*2.0f, buttonSize.width, buttonSize.height)];
    
    [leftButton setTitle:@"Left" forState:UIControlStateNormal];
    [downButton setTitle:@"Down" forState:UIControlStateNormal];
    [rightButton setTitle:@"Right" forState:UIControlStateNormal];
    [upButton setTitle:@"Up" forState:UIControlStateNormal];
    
    [leftButton setBackgroundColor:[UIColor redColor]];
    [downButton setBackgroundColor:[UIColor redColor]];
    [rightButton setBackgroundColor:[UIColor redColor]];
    [upButton setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:leftButton];
    [self.view addSubview:downButton];
    [self.view addSubview:rightButton];
    [self.view addSubview:upButton];
    
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

- (void) pressUp {
    
}

- (void) pressDown {
    
}

- (void) pressLeft {
    
}

- (void) pressRight {
    
}

@end
