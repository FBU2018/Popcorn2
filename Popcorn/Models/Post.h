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
@property (strong, nonatomic) NSString *authorUsername;
@property (strong, nonatomic) NSString *movieId;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSMutableArray *shelves;
@property (strong, nonatomic) NSString *postType; //either review or shelfUpdate
@property (strong, nonatomic) NSString *authorSessionId;

+ (nonnull NSString *)parseClassName;
+ (void) postReviewWithUser: ( NSString * _Nullable )authorId ofUsername: (NSString*) username withSession: (NSString * _Nullable)sessionId andMovie: ( NSString * _Nullable )movieId withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) postShelfUpdateWithUser: ( NSString * _Nullable )authorId ofUsername: (NSString*) username withSession: (NSString * _Nullable) sessionId andMovie: ( NSString * _Nullable )movieId andShelves: (NSMutableArray *_Nullable) shelves withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
