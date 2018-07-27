//
//  PCUserProfileViewController.h
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface PCUserProfileViewController : UIViewController
@property (strong,  nonatomic) PFUser *currentUser;
@property (nonatomic) BOOL following;
@end
