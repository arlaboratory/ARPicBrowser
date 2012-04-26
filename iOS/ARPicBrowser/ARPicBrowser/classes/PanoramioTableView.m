//
//  PanoramioTableView.m
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import "PanoramioTableView.h"
#import "PanoramioViewCell.h"
#import "panoramioObject.h"

@implementation PanoramioTableView

@synthesize dataArray = _dataArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    _panoramioTable = nil;
    [super viewDidUnload];
    self.dataArray = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isVisible=TRUE;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    isVisible=FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 *
 *Refresh data.
 *
 *@param [NSMutableArray]dataArray Array with the new data.
 *
 */
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_panoramioTable reloadData];
    if(isVisible && [Information returnAlertActive]){
        [Information stopProcessAlert];
    }
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanoramioViewCell* panoramioCell = [tableView dequeueReusableCellWithIdentifier:@"panoramioCell"];
    
    PanoramioObject* panObject = [_dataArray objectAtIndex:indexPath.row];
    [panoramioCell.title setText:panObject.title];
    [panoramioCell.date setText:panObject.imageDate];
    [panoramioCell.iconImageView setImage:panObject.imagePlace];
    
    return panoramioCell;
}

/**
 *
 *Show the place's image.
 *
 *@param [NSString]url Url of the selected image.
 *
 *@param [NSString]titleImage Title of the selected image.
 *
 */
- (void)showImage:(NSString *)url andTitle:(NSString*)titleImage
{
    PanoramioPicture *controller = [[PanoramioPicture alloc] init];
    [controller setUrl:url];
    [controller setTitleImage:titleImage];
    [self presentModalViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PanoramioObject* panObject = [_dataArray objectAtIndex:indexPath.row];
    if (panObject) {
        [self showImage:panObject.imageUrl andTitle:panObject.title];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
