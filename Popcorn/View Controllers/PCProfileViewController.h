//
//  PCProfileViewController.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/23/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface PCProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *userShelvesLabel;
@property (strong,  nonatomic) PFUser *currentUser;
@end
