//
//  CastCollectionViewCell.m
//  Popcorn
//
//  Created by Sarah Embry on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "CastCollectionViewCell.h"

@implementation CastCollectionViewCell
-(void) configureCell: (NSArray *)castList withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *actor = castList[indexPath.item];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *profileURLString = actor[@"profile_path"];
    
    
    NSString *fullProfileURLString = [baseURLString stringByAppendingString:profileURLString];
    NSURL *profileURL = [NSURL URLWithString:fullProfileURLString];
    [self.castImageView setImageWithURL:profileURL]; 
    [self.castImageView.layer setCornerRadius:45.0f];
    [self.castImageView.layer setMasksToBounds:YES];
    
    self.characterNameLabel.text = actor[@"character"];
}
@end
