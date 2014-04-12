//
//  TankzViewController.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/11/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzClientViewController.h"
#import "TankzViewController.h"

@interface TankzViewController ()

@end

@implementation TankzViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)launchGame:(id)sender {
    [self presentViewController:[[TankzClientViewController alloc] init] animated:YES completion:nil];
}

@end
