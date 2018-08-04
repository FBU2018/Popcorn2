//
//  PCMapDetailViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 8/2/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMapDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManagerMovieGlu.h"
#import "APIManager.h"
#import "Movie.h"
#import "TheatreMoviesCell.h"
#import "UIImageView+AFNetworking.h"
#import "PCMovieDetailViewController.h"
#import "Parse.h"

@interface PCMapDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *theatreNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theatreImage;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dictionaryMovies;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *shelves;


@end

@implementation PCMapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing*(postersPerLine - 1))/postersPerLine;
    CGFloat itemHeight = itemWidth*2/1.35;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.dictionaryMovies = [NSMutableArray new];
    self.movies = [NSArray new];
    
    [self setViews];
    [self getMovies];
    [self getLists];
}

- (void)getLists{
    [[APIManager shared] getShelvesWithSessionId:PFUser.currentUser[@"sessionId"] andAccountId: PFUser.currentUser[@"accountId"] andCompletionBlock:^(NSDictionary *shelves, NSError *error) {
        if(error == nil){
            self.shelves = shelves[@"results"];
            NSLog(@"Successfully got all of user's shelves");
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)setViews{
    self.theatreNameLabel.text = self.theatreTitle;
    self.addressLabel.text = self.theatreInfo[@"vicinity"];
    self.ratingLabel.text = [@"Rating: " stringByAppendingString:self.rating];
    
    NSLog(@"photos: %@",
          self.theatreInfo[@"photos"]);
    NSString *photoReference = self.theatreInfo[@"photos"][0][@"photo_reference"]; //use to get photo

    [[APIManagerMovieGlu shared] getPhotoFromReference:photoReference completion:^(NSData *imageData, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully got image");
            UIImage *image = [UIImage imageWithData:imageData];
            self.theatreImage.image = image;

            //adds dark tint so text is readable
            UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.theatreImage.frame.size.width, self.theatreImage.frame.size.height)];
            [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
            [self.theatreImage addSubview:overlay];
        }
    }];
}

- (void)getMovies{
    for(NSString *movieName in self.moviesPlaying){
        NSString *movieNameInput = [movieName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        [[APIManager shared] searchMoviesWithString:movieNameInput andPageNumber:@"1" andResultsCompletionHandler:^(NSArray *results) {
            //TO DO: what happens if no results????
            if(results.count <= 0){
                NSLog(@"movieInputName: %@", movieNameInput);
            }
            else{
                NSDictionary *oneMovie = results[0];
                [self.dictionaryMovies addObject:oneMovie];
                
                if(self.dictionaryMovies.count == self.moviesPlaying.count || [movieName isEqualToString:self.moviesPlaying[self.moviesPlaying.count-1]]){
                    self.movies = [Movie moviesWithDictionaries:self.dictionaryMovies];
                    
                    [self.collectionView reloadData];
                }
            }

        } andErrorCompletionHandler:^(NSError *error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TheatreMoviesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TheatreMoviesCell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.item];
    cell.movie = movie;
    [cell.posterImage setImageWithURL:movie.posterUrl];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.movies.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"movieToDetail"]){
        TheatreMoviesCell *tappedCell = sender;
        PCMovieDetailViewController *receiver = [segue destinationViewController];
        receiver.movie = tappedCell.movie;
        receiver.shelves = self.shelves;
    }
}



@end
