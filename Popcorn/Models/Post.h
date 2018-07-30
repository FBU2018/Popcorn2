//
//  Post.h
//  Popcorn
//
//  Created by Rucha Patki on 7/30/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PFUser+ExtendedUser.h"

@interface Post : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *movieId;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSMutableArray *shelves;

+ (nonnull NSString *)parseClassName;
+ (void) postUpdateWithUser: ( NSString * _Nullable )authorId andMovie: ( NSString * _Nullable )movieId withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
