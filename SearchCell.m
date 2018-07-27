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
    self.titleLabel.text = movie.title;
    self.releaseDateLabel.text = movie.releaseDateString;
    self.posterView.image = nil;
    [self.posterView setImageWithURL:movie.posterUrl];
    self.ratingLabel.text = [@"Average rating: " stringByAppendingString:[movie.ratingString stringByAppendingString:@"/10"]];
}

@end
