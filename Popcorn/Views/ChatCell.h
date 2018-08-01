//
//  ChatCell.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *chatTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
