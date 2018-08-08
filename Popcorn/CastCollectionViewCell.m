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
    
    self.castImageView.image = [UIImage imageNamed:@"person placeholder.png"];
    if(![profileURLString isEqual:[NSNull null]]){
        NSString *fullProfileURLString = [baseURLString stringByAppendingString:profileURLString];
        NSURL *profileURL = [NSURL URLWithString:fullProfileURLString];
        self.castImageView.alpha = 0.0;
        [self.castImageView setImageWithURL:
         profileURL];
        [UIView animateWithDuration:0.3 animations:^{
            self.castImageView.alpha = 1.0;
        }];
    }
   
    [self.castImageView.layer setCornerRadius:self.castImageView.frame.size.width / 2];
    [self.castImageView.layer setMasksToBounds:YES];
    
    self.characterNameLabel.text = actor[@"character"];
}
@end
