//
//  UserSearchCell.h
//  Popcorn
//
//  Created by Rucha Patki on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@interface UserSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

- (void) configureCell:(NSArray *)users withIndexPath:(NSIndexPath *)indexPath;

@end
