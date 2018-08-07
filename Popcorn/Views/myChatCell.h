//
//  myChatCell.h
//  Popcorn
//
//  Created by Ernest Omondi on 8/7/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chat.h"

@interface myChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *myChatTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
-(void)configureCellWithChat:(Chat *)chat;
@end
