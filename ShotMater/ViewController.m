//
//  ViewController.m
//  ShotMater
//
//  Created by lw on 16/3/19.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "PlayScene.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView *sk= (SKView*)self.view;
    PlayScene  *ascene=[[PlayScene  alloc]initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
   
    
    [sk presentScene:ascene];
    sk.showsDrawCount=YES;
    sk.showsFPS=YES;
    sk.showsNodeCount=YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
