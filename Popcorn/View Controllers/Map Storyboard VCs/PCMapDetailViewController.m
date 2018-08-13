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
#import "TheaterHeader.h"

@interface PCMapDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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
    
    [self getMovies];
    [self getLists];
    
    layout.headerReferenceSize = CGSizeMake(0, 240);
}

- (void)getLists{
    [[APIManager shared] getShelvesWithSessionId:PFUser.currentUser[@"sessionId"] andAccountId: PFUser.currentUser[@"accountId"] andCompletionBlock:^(NSArray *results, NSError *error) {
        if(error == nil){
            self.shelves = results;
            NSLog(@"Successfully got all of user's shelves");
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


- (void)getMovies{
    for(NSString *movieName in self.moviesPlaying){
        NSString *movieNameInput = [movieName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        [[APIManager shared] searchMoviesWithString:movieNameInput andPageNumber:@"1" andResultsCompletionHandler:^(NSArray *results) {
            if(results.count <= 0){
                NSLog(@"movieInputName: %@", movieNameInput);
            }
            else{
                NSDictionary *oneMovie = results[0];
                [self.dictionaryMovies addObject:oneMovie];
                self.movies = [Movie moviesWithDictionaries:self.dictionaryMovies];
                
                [self.collectionView reloadData];
            }

        } andErrorCompletionHandler:^(NSError *error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    TheaterHeader *header;
    if(kind == UICollectionElementKindSectionHeader){
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TheaterHeader" forIndexPath:indexPath];
        header.theaterNameLabel.text = self.theatreTitle;
        header.addressLabel.text = self.theatreInfo[@"vicinity"];
        header.ratingLabel.text = [@"Rating: " stringByAppendingString:self.rating];
        
        NSString *photoReference = self.theatreInfo[@"photos"][0][@"photo_reference"]; //use to get photo
        
        [[APIManagerMovieGlu shared] getPhotoFromReference:photoReference completion:^(NSData *imageData, NSError *error) {
            if(error != nil){
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully got image");
                UIImage *image = [UIImage imageWithData:imageData];
                header.theaterImage.image = image;
                
            }
        }];
    }
    return header;
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
