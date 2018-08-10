//
//  LibraryCell.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "LibraryCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

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
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView = backgroundView;
    
    self.titleLabel.text = shelfInfo[@"name"];
    NSString *itemCount = [shelfInfo[@"item_count"] stringValue];
    self.numberItemsLabel.text = [itemCount stringByAppendingString:@" items"];
    self.shelfId = shelfInfo[@"id"];
    self.listType = shelfInfo[@"list_type"];
    
    //set image
    NSString *shelfIdString = [self.shelfId stringValue];
    [[APIManager shared] getShelfMovies:shelfIdString completion:^(NSArray *movies, NSError *error) {
        if(error == nil){
            NSLog(@"Successfully got movies on shelves");
            NSMutableArray *moviesArray = [NSMutableArray array];
            moviesArray = [Movie moviesWithDictionaries:movies];
            self.shelfImageView.image = nil;
            if(moviesArray.count > 0){
                self.movieForImage = moviesArray[0];
                [self.shelfImageView setImageWithURL:self.movieForImage.posterUrl];
            }
            else{
                self.shelfImageView.image = [UIImage imageNamed:@"poster-placeholder"];
            }
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];

}

@end
