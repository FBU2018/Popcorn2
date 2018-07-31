//
//  ReviewCell.m
//  Popcorn
//
//  Created by Sarah Embry on 7/19/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "ReviewCell.h"
#import "Movie.h"

@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(NSArray *)reviews withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *review = reviews[indexPath.row];
    self.reviewerName.text = review[@"author"];
    self.reviewContent.text = review[@"content"];
//    NSArray *reviewContent = [review allValues];
//    self.reviewContent.text = reviewContent[0];
}

@end
