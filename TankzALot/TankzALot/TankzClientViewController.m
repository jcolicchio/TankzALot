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
    
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
    SKView *spriteView = (SKView *) self.view;
    
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    TankzScene *scene = [[TankzScene alloc] initWithSize:spriteView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [spriteView presentScene:scene];
    
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
