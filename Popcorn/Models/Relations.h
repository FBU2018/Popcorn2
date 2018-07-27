//
//  Relations.h
//  Popcorn
//
//  Created by Ernest Omondi on 7/26/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>

@interface Relations : PFObject <PFSubclassing>
@property (strong, nonatomic) NSArray * _Nullable myfollowersIds;
@property (strong, nonatomic) NSArray * _Nullable myfollowingIds;
+ (nonnull NSString *)parseClassName;
@end
