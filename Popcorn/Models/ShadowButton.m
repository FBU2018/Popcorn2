//
//  ShadowButton.m
//  Popcorn
//
//  Created by Sarah Embry on 8/6/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ShadowButton.h"

@implementation ShadowButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setupView{
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    
}

-(id)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super initWithCoder:aDecoder])){
        [self setupView];
    }
    
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentEdgeInsets = UIEdgeInsetsMake(1.0,1.0,-1.0,-1.0);
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.8;
    
    [super touchesBegan:touches withEvent:event];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
    
    [super touchesEnded:touches withEvent:event];
    
}

@end
