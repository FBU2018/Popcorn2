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
#import "PCRatingViewController.h"
#import "PCActorDetailViewController.h"
#import "Parse.h"
//this cell has the same properties as the actor credits collectionview cell
#import "ActorCreditsCollectionViewCell.h"
#import "PCWriteReviewViewController.h"

@interface PCMovieDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *castCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *ratingButton;
@property (weak, nonatomic) IBOutlet UICollectionView *similarToCollectionView;


- (IBAction)didTapRating:(id)sender;

@property (strong, nonatomic) NSArray *castList;

@property (strong, nonatomic) NSArray *similarToList;

@end

@implementation PCMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.castCollectionView.delegate = self;
    self.castCollectionView.dataSource = self;
    
    self.similarToCollectionView.delegate = self;
    self.similarToCollectionView.dataSource = self;
    
    [self.castCollectionView layoutIfNeeded];
    
    [self configureDetails];
    
   [self.similarToCollectionView layoutIfNeeded];
    
    //format the cast collection view
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.castCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 2;
    
    UICollectionViewFlowLayout *similarLayout = (UICollectionViewFlowLayout *)self.similarToCollectionView.collectionViewLayout;
    similarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    similarLayout.minimumInteritemSpacing = 2;
    

}

-(void) viewWillAppear:(BOOL)animated{
    [self fetchRating];
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
    //TO DO: CHANGE THE PLACEHOLDER IMAGE FOR POSTERS & BACKDROP
    [self.posterImageView setImageWithURL:self.movie.posterUrl placeholderImage:[UIImage imageNamed:@"person placeholder.png"]];
    
 
    [self.backdropImageView setImageWithURL:self.movie.backdropUrl placeholderImage:[UIImage imageNamed:@"person placeholder.png"]];
    
    //adds a dark tint to the backdrop so text is readable
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backdropImageView.frame.size.width, self.backdropImageView.frame.size.height)];
    [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self.backdropImageView addSubview:overlay];
    
    
    [self fetchCast];
   // [self fetchRating];
    [self fetchSimilar];
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
    else if ([segue.identifier isEqualToString:@"detailToRating"]){
        PCRatingViewController *receiver = [segue destinationViewController];
        receiver.movie = self.movie;
    }
    else if ([segue.identifier isEqualToString:@"detailToActorDetail"]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.castCollectionView indexPathForCell:tappedCell];
        NSDictionary *actor = self.castList[indexPath.item];
        
        PCActorDetailViewController *receiver = [segue destinationViewController];
        receiver.actorID = actor[@"id"];
    }
    else if ([segue.identifier isEqualToString:@"detailToReview"]){
        PCWriteReviewViewController *receiver = [segue destinationViewController];
        receiver.currentMovie = self.movie;
    }
}


- (IBAction)didTapRating:(id)sender {
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(collectionView == self.castCollectionView){
        CastCollectionViewCell *cell = [self.castCollectionView dequeueReusableCellWithReuseIdentifier:@"CastCollectionViewCell" forIndexPath:indexPath];
        [cell configureCell:self.castList withIndexPath:indexPath];
        return cell;
    }
    else{
        //change this to be the collection view cell for similar to when the time comes
        ActorCreditsCollectionViewCell *cell = [self.similarToCollectionView dequeueReusableCellWithReuseIdentifier:@"actorCreditsCollectionViewCell" forIndexPath:indexPath];
        [cell configureCell:self.similarToList atIndexPath:indexPath];
        return cell;
    }
    
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.castCollectionView){
        return self.castList.count;
    }
    else{
        return self.similarToList.count;
    }
}


-(void) fetchCast{
    NSString *stringID = [self.movie.movieID stringValue];
    [[APIManager shared] getCast:stringID completion:^(NSArray *fullCastList, NSError *error){
            if(fullCastList.count > 20){
                self.castList = [fullCastList subarrayWithRange:NSMakeRange(0, 19)];
            }
            else{
                self.castList = fullCastList;
//            NSLog(@"%@", self.castList);
            }
        [self.castCollectionView reloadData];
     }];
}

-(void)fetchRating{
    NSString *stringID = [self.movie.movieID stringValue];
    [[APIManager shared] getRating:stringID withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSObject *rating, NSError *error) {
        if(error != nil){
            NSLog(@"%@", error.localizedDescription);
        }
        else{
            //            check if the object being returned from api call is a dictionary or a boolean
            if([rating isKindOfClass:[NSDictionary class]]){
                NSDictionary *ratingDict = (NSDictionary *)rating;
                [self.ratingButton setTitle:[[ratingDict[@"value"] stringValue]stringByAppendingString:@"/10"] forState:UIControlStateNormal];
                
            }
            //if the result is a boolean, that means the user hasn't rated it yet
            else{
                
            }
        }
    }];
}

-(void) fetchSimilar{
    [[APIManager shared] getSimilar:[self.movie.movieID stringValue] completion:^(NSArray *results, NSError *error) {
        if(error != nil){
            NSLog(@"%@", error);
        }
        else{
            self.similarToList = results;
        }
         [self.similarToCollectionView reloadData];
    }];
   
}

@end