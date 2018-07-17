//
//  LibraryCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "LibraryCell.h"

@implementation LibraryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(NSDictionary *)shelfInfo{
    self.titleLabel.text = shelfInfo[@"name"];
    NSString *itemCount = [shelfInfo[@"item_count"] stringValue];
    self.numberItemsLabel.text = [itemCount stringByAppendingString:@" items"];
    
    self.movieId = shelfInfo[@"id"];
    self.listType = shelfInfo[@"list_type"];
}

@end
