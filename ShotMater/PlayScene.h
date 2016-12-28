//
//  PlayScene.h
//  ShotMater
//
//  Created by lw on 16/3/19.
//  Copyright © 2016年 lw. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayScene : SKScene<SKPhysicsContactDelegate>
@property (nonatomic)  NSTimeInterval   lastspawntime;
@property (nonatomic)   NSTimeInterval  lastupdatetime;
@property (nonatomic)  SKSpriteNode   *player;
@end
