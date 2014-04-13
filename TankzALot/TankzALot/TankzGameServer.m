//
//  TankzGameServer.m
//  TankzALot
//
//  Created by Joseph Colicchio on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "TankzGameServer.h"
#import "TankzClientViewController.h"
#import <SpriteKit/SpriteKit.h>

@interface TankzGameServer ()

@property (strong,nonatomic) TankzGameState *gameState;
@property (strong,nonatomic) MCSession *session; // Pointer to the other users on the network

@end

@implementation TankzGameServer

- (void) session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void) session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

- (void) session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    //if we receive the game state
    
    NSLog(@"got frame!");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSObject *state = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([state isKindOfClass:[TankzGameState class]]) {
            NSLog(@"got state from guy!");
            TankzGameState *newGameState = (TankzGameState *)state;
            //NSLog(@"it works?");
            //NSLog(@"players: %lu, gravity: %d", (unsigned long)[newGameState.playerList count], newGameState.gravity);
            [self setGameState:newGameState];
        }
    });
}

- (void) session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}

- (void) session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}


-(id)initWithViewController:(TankzClientViewController*)vc andSession:(MCSession *) session {
    if(self = [super init]){
        self.session = session;
        self.gameState = [[TankzGameState alloc]init];
        self.gameState.gravity=10;
        self.gameState.height = 200;
        self.gameState.turn=0;
        self.viewController = vc;
        self.gameState.playingState = 0;
        //initialize game with number of players
        self.gameState.playerList = [[NSMutableArray alloc]init];
        [self startGame:2];
        
        session.delegate = self;
    }
    return self;
}
-(void)startGame:(int)numPlayers{
    TankzPlayer* player1 = [[TankzPlayer alloc] init];
    player1.name = @"Player1";
    player1.playerID = 0;
    player1.position = CGPointMake(200,200);
    player1.turretPosition = 0;
    player1.color = [SKColor orangeColor];
    player1.health = 100;
    player1.fuel = 100;
    player1.power = 50;
    
    [self.gameState.playerList addObject:player1];
    
    TankzPlayer* player2 = [[TankzPlayer alloc] init];
    player2.name = @"Player2";
    player2.playerID = 1;
    player2.position = CGPointMake(100,200);
    player2.turretPosition = 0;
    player2.color = [SKColor blueColor];
    player2.health = 100;
    player2.fuel = 100;
    player2.power = 50;
    
    [self.gameState.playerList addObject:player2];
    
    
    
    
}



-(TankzGameState*)getGameState{
    return self.gameState;
    
}

-(void) setGameState:(TankzGameState *) state {
    _gameState = state;
    [self.viewController updateWithGameState:state];
    //now tell the UI to update
    
}

-(void)sendPlayerCommand:(TankzPlayerCommand)playerCommand andPlayerID:(int)playerID{
    
    @synchronized([TankzGameServer class]) {
        //validate to make sure it's their turn
        if(playerID != self.gameState.turn){
            return;
        }
        self.gameState.playingState = TankzPlayingStateRunning;
        TankzPlayer *playerState = ((TankzPlayer*)[self.gameState.playerList objectAtIndex:playerID]);
        
        //attempt to do the action
        if (playerCommand == TankzPlayerCommandMoveLeft){
            int playerFuel = playerState.fuel;
            if (playerFuel>0){
                //STUB: update CGPoint position
                playerState.position = CGPointMake(playerState.position.x-1, playerState.position.y);
                playerState.fuel = playerFuel-1;
                
            }
            NSLog(@"Move Left");
            
        }else if(playerCommand == TankzPlayerCommandMoveRight){
            
            int playerFuel = playerState.fuel;
            if (playerFuel>0){
                //STUB: update CGPoint position
                playerState.position = CGPointMake(playerState.position.x+1,playerState.position.y);
                playerState.fuel = playerFuel-1;
                
            }
            NSLog(@"Move Right");
            
        }else if(playerCommand == TankzPlayerCommandAimCCW){
            if (playerState.turretPosition<180){
                playerState.turretPosition+=5;
            }
            NSLog(@"Aim CCW");
        }else if(playerCommand == TankzPlayerCommandAimCW){
            if(playerState.turretPosition>0){
                playerState.turretPosition-=5;
            }
            NSLog(@"Aim CW");
        }else if(playerCommand == TankzPlayerCommandFire){
            
            self.gameState.playingState = TankzPlayingStateFiring;
            
            //int vertComponent = [self calculateVerticalComponent:playerState.power andTurretPosition:playerState.turretPosition];
            //int horizComponent = [self calculateHorizontalComponent:playerState.power andTurretPosition:playerState.turretPosition];
            
            //do actual path simulation
            
            float rad = playerState.turretPosition * M_PI/180;
            int pow = playerState.power;
            
            float velocity_x = pow * cos(rad);
            NSLog(@"velocity_x_0: %f", velocity_x);
            float velocity_y = pow * sin(rad);
            NSLog(@"velocity_y_0: %f", velocity_y);
            float position_x = playerState.position.x;
            float position_y = playerState.position.y;
            
            NSMutableArray *actions = [[NSMutableArray alloc] init];
            int i = 0;
            while( true ){
                // each iteration represents one time unit
                float timescale = 0.5;
                position_x += velocity_x * timescale;
                position_y += velocity_y * timescale;
                velocity_y -= self.gameState.gravity * timescale;
                NSLog(@"%f", velocity_y);
                
                //SKAction sequence:
                //[roundHEAT runAction:[SKAction moveTo:CGPointMake(position_x, position_y) duration:0.1]];
                
                if(position_y < self.gameState.height){
                    break;
                }
                
                //[actions addObject:[SKAction moveTo:CGPointMake(position_x, position_y) duration:0.1]];
                //the bullet will be at position_x, position_y
                //for each tank past frame 2, make sure
                BOOL hit = false;
                if(i > 2) {
                    for(TankzPlayer *player in self.gameState.playerList) {
                        int a = (player.position.x - position_x);
                        int b = (player.position.y - position_y);
                        int c = sqrt(a*a+b*b);
                        
                        if( c < 15) {
                            //DIRECT HIT!
                            hit = true;
                            player.health -= 50;
                            NSLog(@"player health is now: %d", player.health);
                            break;
                        }
                    }
                }
                
                if(hit)
                    break;
                i++;
            }
            
            //float timeTraveled = 2*(vertComponent)/self.gameState.gravity;
            
            //int distance = timeTraveled*horizComponent;
            
            //check if shot direction is left or right
            //CGPoint bombsite = CGPointMake(playerState.position.x+distance, playerState.position.y);
            
            //check if any players are within range of the bullet
            //deal damage to players within range of bullet
            /*for(TankzPlayer *player in self.gameState.playerList) {
                int a = player.position.x - bombsite.x;
                int b = player.position.y - bombsite.y;
                int c = sqrt(a*a+b*b);
                
                //TODO:do damage based on distance
                if(c < 3){
                    player.health = player.health-50;
                }
            }*/
            
          
            
            //move turn to next player who isn't dead
            
            int numPlayers = (int)[self.gameState.playerList count];
            self.gameState.turn = (self.gameState.turn + 1) % numPlayers;
            
            TankzPlayer *cycledPlayer = (TankzPlayer*)[self.gameState.playerList objectAtIndex:self.gameState.turn];
            BOOL fullLoop = NO;
            while (cycledPlayer.health <= 0 && !fullLoop){
                self.gameState.turn = (self.gameState.turn + 1) % numPlayers;
                cycledPlayer = (TankzPlayer*)[self.gameState.playerList objectAtIndex:self.gameState.turn];
                
                if(self.gameState.turn == playerID) {
                    fullLoop = YES;
                    NSLog(@"WINNER");
                }
            }
            
            
            NSLog(@"Shots Fired!");
            
            
        }
        
        [self.viewController updateWithGameState:[self getGameState]];
        
        //send out updated game state here
        id <NSCoding> gameStateObject = [self getGameState];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:gameStateObject];
        
        //send data to all clients
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            if (![self.session sendData:data
                                toPeers:self.session.connectedPeers
                               withMode:MCSessionSendDataReliable
                                  error:&error]) {
                NSLog(@"[Error] %@", error);
            }
        });
        
        //data should be transferable and unwrappable
        /*NSObject *state = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([state isKindOfClass:[TankzGameState class]]) {
            TankzGameState *newGameState = (TankzGameState *)state;
            NSLog(@"it works?");
            NSLog(@"players: %lu, gravity: %d", (unsigned long)[newGameState.playerList count], newGameState.gravity);
        }*/
        
        //end turn
    }
}

/*
-(int)main{ //test
    NSMutableArray *phonyPlayerList = [[NSMutableArray alloc] init];
    
    TankzPlayer* phonyPlayer1 = [[TankzPlayer alloc] init];
    
    phonyPlayer1.name = @"Player1";
    
    phonyPlayer1.playerID = 0;
    
    phonyPlayer1.position = CGPointMake(200,200);
    
    phonyPlayer1.turretPosition = 3;
    
    [phonyPlayerList addObject:phonyPlayer1];
    
    TankzPlayer* phonyPlayer2 = [[TankzPlayer alloc] init];
    
    phonyPlayer2.name = @"Player2";
    
    phonyPlayer2.playerID = 1;
    
    
    phonyPlayer2.position = CGPointMake(100,180);
    
    phonyPlayer2.turretPosition = 45;
    
    [phonyPlayerList addObject:phonyPlayer2];
    
    self.gameState.playerList = phonyPlayerList;
    
    NSLog(@"value: %f",phonyPlayer2.turretPosition);
    sendPlayerCommand
    NSLog(@"new value: %f",phonyPlayer2.turretPosition);
    
    return 0;
}
*/

-(int)calculateHorizontalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * cos(M_PI/180*turretPosition);
}
-(int)calculateVerticalComponent:(int)powerComponent andTurretPosition:(int)turretPosition{
    return powerComponent * sin(M_PI/180*turretPosition);
}

@end
