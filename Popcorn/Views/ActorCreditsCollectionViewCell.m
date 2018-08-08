//
//  ActorCreditsCollectionViewCell.m
//  Popcorn
//
//  Created by Sarah Embry on 7/25/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ActorCreditsCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ActorCreditsCollectionViewCell
-(void) configureCell:(NSArray *)credits atIndexPath:(NSIndexPath *)indexPath{
    //sets default image in case there is no poster available
    [self.posterView setImage:[UIImage imageNamed:@"poster-placeholder.png"]];
    
    if(![credits[indexPath.item][@"poster_path"] isEqual:[NSNull null]]){
        NSString *posterURLString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:credits[indexPath.item][@"poster_path"]];
        NSURL *posterURL = [NSURL URLWithString:posterURLString];
        self.posterView.alpha = 0.0;
        [self.posterView setImageWithURL:posterURL];
        [UIView animateWithDuration:0.3 animations:^{
            self.posterView.alpha = 1.0;
        }];
    }
    self.titleLabel.text = credits[indexPath.item][@"title"];
}
@end
