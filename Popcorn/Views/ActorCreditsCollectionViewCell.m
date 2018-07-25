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
    [self.posterView setImage:[UIImage imageNamed:@"poster-placeholder.png"]];
   // NSString *posterURLString = [@"https://image.tmdb.org/t/p/w500" stringByAppendingString:credits[]];
//    NSURL *posterURL = [NSURL URLWithString:posterURLString];
//    [self.posterView setImageWithURL:posterURL];
}
@end
