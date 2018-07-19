//
//  PCMovieDetailViewController.m
//  Popcorn
//
//  Created by Sarah Embry on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMovieDetailViewController.h"
#import "CastCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "PCShelfPickerViewController.h"
#import "PCReviewViewController.h"

@interface PCMovieDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *castCollectionView;


- (IBAction)didTapRating:(id)sender;

@property (strong, nonatomic) NSArray *castList;


@end

@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.castCollectionView.delegate = self;
    self.castCollectionView.dataSource = self;
    
    [self configureDetails];
    
    //format the cast collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.castCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 2;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureDetails{
    self.titleLabel.text = self.movie.title;
    self.summaryLabel.text = self.movie.overview;
    NSString *ratingString = [@"Average rating: " stringByAppendingString:[[self.movie.rating stringValue] stringByAppendingString:@"/10"]];
    self.ratingLabel.text = ratingString;
    self.dateLabel.text = self.movie.releaseDateString;
    //CHANGE THE PLACEHOLDER IMAGE FOR POSTERS & BACKDROP
    [self.posterImageView setImageWithURL:self.movie.posterUrl placeholderImage:[UIImage imageNamed:@"person placeholder.png"]];
    
 
    [self.backdropImageView setImageWithURL:self.movie.backdropUrl placeholderImage:[UIImage imageNamed:@"person placeholder.png"]];
    
    //adds a dark tint to the backdrop so text is readable
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backdropImageView.frame.size.width, self.backdropImageView.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self.backdropImageView addSubview:overlay];
    
    
    [self fetchCast];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"detailToPicker"]){
        PCShelfPickerViewController *receiver = [segue destinationViewController];
        receiver.movie = self.movie;
        receiver.shelves = self.shelves;
    }
    else if ([segue.identifier isEqualToString:@"detailToReviews"]){
        PCReviewViewController *receiver = [segue destinationViewController];
        receiver.movie = self.movie;
    }
}


- (IBAction)didTapRating:(id)sender {
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CastCollectionViewCell *cell = [self.castCollectionView dequeueReusableCellWithReuseIdentifier:@"CastCollectionViewCell" forIndexPath:indexPath];
    
    [cell configureCell:self.castList withIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.castList.count;
}


-(void) fetchCast{
    NSString *stringID = [self.movie.movieID stringValue];
    [[APIManager shared] getCast:stringID completion:^(NSArray *fullCastList, NSError *error){
            if(fullCastList.count > 20){
                self.castList = [fullCastList subarrayWithRange:NSMakeRange(0, 19)];
            }
            else{
                self.castList = fullCastList;
            }
            NSLog(@"%@", self.castList);
            [self.castCollectionView reloadData];
     }];
}



@end
