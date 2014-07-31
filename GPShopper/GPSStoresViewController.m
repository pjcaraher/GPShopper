//
//  GPSStoresViewController.m
//  GPShopper
//
//  Created by Patrick Caraher on 7/31/14.
//  Copyright (c) 2014 GPShopper. All rights reserved.
//

#import "GPSStoresViewController.h"
#import <GPShopper/SCUIViewControllerCategory.h>

@interface GPSStoresViewController ()
@property IBOutlet UIButton *storePresentationButton;
@end

@implementation GPSStoresViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Stores";
    self.locationDetectionFailureMessage = @"Unable to detect location.  Check settings to ensure location services are enabled.";
    self.searchQuery = @"store_location";
    self.geolocation = [SCGeoLocation defaultLocation];
    self.searchConstraint = [SCSearchConstraint newDefaultConstraint];
    
    UIImage *btnImage = [UIImage imageNamed: (SCStoreLocatorStorePresentationMap == storePresentation
                                              ? @"storelocator_listview"
                                              : @"storelocator_mapview")];
    
    [self.storePresentationButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setStorePresentationControlHidden: (BOOL)h
                            presentation: (enum SCStoreLocatorStorePresentation)p
{
    UIImage *btnImage = [UIImage imageNamed: (p == SCStoreLocatorStorePresentationMap
                                     ? @"storelocator_listview"
                                     : @"storelocator_mapview")];

    [self.storePresentationButton setImage:btnImage forState:UIControlStateNormal];
}

-(void)gotoStoreInfoPageForProduct: (SCSearchResultProduct *)p
{
    SCStoreInfoViewController *vc=[[SCStoreInfoViewController alloc]
                                   initWithNibName: @"SCStoreInfoViewController"
                                   bundle: [NSBundle mainBundle]];
    [vc setStoreData: [p nearestPhysicalInstance]];
    [vc setTitle: [self title]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<SCTableEntry>)newTableEntryForSearchProduct:(SCSearchResultProduct *)p
{
    id <SCTableEntry> tableEntry = [super newTableEntryForSearchProduct:p];
    
    // Customize here, if you wish.  For example:
    // [(SCBaseTableEntry*)tableEntry setXibName:@"MyStoreTableCell"];
    
    return tableEntry;
}

- (NSArray *)newTableSectionsFromSearchResultList:(SearchResultList *)l
{
    if (!l)
    {
        NSLog(@"!l -- newTableSectionsFromSearchResults");
        return nil;
    }
    
    NSMutableArray *res=[[NSMutableArray alloc] init];
    
    SCBaseTableSection *sec=[[SCBaseTableSection alloc] init];
    
    if([[l products] count] == 0)
    {
        if([[l grpids] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Stores were found within 50 miles." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
    }
    
    for (SCSearchResultProduct *p in [l products])
    {
        SCBaseTableEntry *en=[self newTableEntryForSearchProduct: p];
        if (en)
        {
            [[sec entries] addObject: en];
        }
    }
    
    [res addObject: sec];
    
    return res;
}

@end
