//
//  SearchCell.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "SearchCell.h"
#import "UIImageView+AFNetworking.h"


@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCell: (Movie *) movie{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView = backgroundView;
    
    self.titleLabel.text = movie.title;
    self.releaseDateLabel.text = movie.releaseDateString;
    self.posterView.image = nil;
    [self.posterView setImageWithURL:movie.posterUrl placeholderImage:[UIImage imageNamed:@"poster-placeholder.png"]];
    self.ratingLabel.text = [@"Average rating: " stringByAppendingString:[movie.ratingString stringByAppendingString:@"/10"]];
}

@end
