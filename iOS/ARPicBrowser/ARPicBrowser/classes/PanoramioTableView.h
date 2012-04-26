//
//  PanoramioTableView.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Information.h"
#import "PanoramioPicture.h"

@interface PanoramioTableView : UITableViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* _dataArray;
    IBOutlet UITableView *_panoramioTable;
    bool isVisible;
}

@property (strong, nonatomic) NSMutableArray* dataArray;

@end
