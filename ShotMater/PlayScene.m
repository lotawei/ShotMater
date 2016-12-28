//
//  PlayScene.m
//  ShotMater
//
//  Created by lw on 16/3/19.
//  Copyright © 2016年 lw. All rights reserved.
//

#import "PlayScene.h"

@implementation PlayScene
{
    NSString   *score;
    int      record;
}

static const uint32_t   zidancategory=0x1;
static const uint32_t   mostercategory=0x2;
static const uint32_t   playercategory=0x3;
static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}
-(instancetype)initWithSize:(CGSize)size
{
    
    if (self=[super  initWithSize:size]) {
        self.backgroundColor=[UIColor  whiteColor];
        
        score=[NSString  stringWithFormat:@"score:%d分",record];
     
        [self createcontent];
        [self addmoster];
    }
    return self;
}
-(SKSpriteNode *)player
{
    if (_player==nil) {
        _player=[SKSpriteNode  spriteNodeWithImageNamed:@"player.png"];
        
        _player.name=@"player";
        _player.position=CGPointMake(100,200);
        _player.anchorPoint=CGPointMake(0.5,0.5);

    }
    
    _player.physicsBody=[SKPhysicsBody  bodyWithRectangleOfSize:_player.size];
    _player.physicsBody.dynamic=NO;
    _player.physicsBody.contactTestBitMask=zidancategory;
    _player.physicsBody.categoryBitMask=playercategory;
    _player.physicsBody.collisionBitMask=0;
    
    
    
    
    return _player
    ;

}
-(void)didMoveToView:(SKView *)view
{
    [self  creategroup];
    
}
-(void)createcontent
{
         [self addChild:self.player];
    
    SKLabelNode   *lable=[SKLabelNode labelNodeWithText:score];
    lable.name=@"score";
    //tianjia guai  wu
    lable.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter ;
    
    lable.position=CGPointMake(0, 0);
    lable.fontSize = 16 ;
    lable.fontColor  =  [UIColor  blackColor];
    [self addChild:lable];
    
    self.physicsWorld.gravity=CGVectorMake(0,0);
    self.physicsWorld.contactDelegate=self;
 
    
    
    
}

-(void)addmoster
{
  
    SKSpriteNode   *moster=[SKSpriteNode  spriteNodeWithImageNamed:@"master2.png"];
    moster.anchorPoint=CGPointMake(0.5, 0.5);
    //移动速度
    int  minduration=5;
    int  maxduration=9;
    int  rangeduration=maxduration-minduration;
    int  realduration=(arc4random()%rangeduration)+minduration;
    //竖直方向的位置
    int minY=moster.size.height/2;
    int  maxY=self.frame.size.height-moster.size.height/2;
    int  rangeY=maxY-minY;
    int  realeY=(arc4random()%rangeY)+minY;
    
    moster.position=CGPointMake(self.frame.size.width-moster.size.width/2, realeY);
    moster.physicsBody=[SKPhysicsBody  bodyWithRectangleOfSize:moster.size];
    moster.physicsBody.dynamic=YES;
    moster.physicsBody.contactTestBitMask=zidancategory;
    moster.physicsBody.categoryBitMask=mostercategory;
    moster.physicsBody.collisionBitMask=4;
    moster.physicsBody.usesPreciseCollisionDetection=YES;
    [self insertChild:moster atIndex:0];
    
    //怪物移动
    SKAction   *move=[SKAction  moveToX:0 duration:realduration];
    SKAction   *done=[SKAction  removeFromParent];
    [moster  runAction:[SKAction  sequence:@[move,done]]];
    
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    

    SKSpriteNode * zidan = [SKSpriteNode spriteNodeWithImageNamed:@"zidan"];
    zidan.position=self.player.position;
    if (zidan!=NULL) {
        
        
        CGPoint offset = rwSub(location, _player.position);
        
        
       
        if (offset.x <= 0) return;
        
        zidan.physicsBody=[SKPhysicsBody  bodyWithRectangleOfSize:zidan.size];
        zidan.physicsBody.dynamic=NO;
        zidan.physicsBody.contactTestBitMask=mostercategory;
        zidan.physicsBody.categoryBitMask=zidancategory;
        zidan.physicsBody.collisionBitMask=0;
        zidan.physicsBody.usesPreciseCollisionDetection=YES;
        
        [self addChild:zidan];
        
        
    
        CGPoint direction = rwNormalize(offset);
        
        
    
        CGPoint shootAmount = rwMult(direction, 1000);
        
      
        CGPoint realDest = rwAdd(shootAmount, zidan.position);
        
        
        // 9 - Create the actions
        float velocity = 480.0/1.0;
        float realMoveDuration = self.size.width / velocity;
        SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        [zidan runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];

    }
    
    
    
    
}


- (void)updateWithTimeSinceLastUpdate:(NSTimeInterval)timeSinceLast {
    self.lastspawntime+=timeSinceLast;
    if (self.lastspawntime>20) {
        self.lastspawntime=0;
        [self  addmoster];
    }

    



}
    
    
    

// 每一帧都会跳用这个函数

-(void)update:(NSTimeInterval)currentTime
{
    NSTimeInterval   sincelasttime=currentTime-self.lastupdatetime;
    if (sincelasttime>1) {
        sincelasttime=4.0/60.0;
        self.lastupdatetime=currentTime;
        
    }
    [self  updateWithTimeSinceLastUpdate:sincelasttime];
    
   
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{

  
    SKPhysicsBody   *a;
    SKPhysicsBody   *b;
    if (contact.bodyA.categoryBitMask ==playercategory||contact.bodyB.categoryBitMask==playercategory) {
        a=contact.bodyA;
        b=contact.bodyB;
        [self  removecontactnode:a.node andmonster:b.node];
        
        //游戏结束负责写这里的逻辑
        
        
        
    }
    else   if(contact.bodyA.categoryBitMask==zidancategory||contact.bodyB.categoryBitMask==zidancategory)
    {
        a=contact.bodyA;
        b=contact.bodyB;
        [self  removecontactnode:a.node andmonster:b.node];
        SKLabelNode   *lavb=(SKLabelNode*)[self childNodeWithName:@"score"];
      
        record+=4;
         score=[NSString  stringWithFormat:@"score:%d分",record];
        lavb.text=score;
        
        
    }
}
-(void)removecontactnode:(SKNode*)player  andmonster:(SKNode*)monster
{
    
    
    [player removeFromParent];
    [monster removeFromParent];
}
-(void)creategroup
{
//    SKAction   *move=[SKAction moveByX:600 y:200 duration:2];
//    SKAction   *scale=[SKAction  scaleBy:2 duration:1];
//    SKAction   *rotation=[SKAction  rotateByAngle:M_1_PI duration:2];
//     SKAction   *scaleog=[SKAction  scaleBy:1 duration:1];
//    [self.player runAction:[SKAction  group:@[move,scale,rotation,scaleog]]];
    
}



@end
