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
@property (strong, nonatomic) NSArray * _Nullable myfollowers;
@property (strong, nonatomic) NSArray * _Nullable myfollowings;
+ (nonnull NSString *)parseClassName;
@end
