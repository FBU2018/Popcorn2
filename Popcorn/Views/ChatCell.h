//
//  ChatCell.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chat.h"
#import "ParseUI.h"
#import "PFUser+ExtendedUser.h"


@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *chatTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
-(void)configureCell:(Chat *)chat withUserObjectId:(NSString *)objectId andIndexPath:(NSIndexPath *)indexPath;
@end
