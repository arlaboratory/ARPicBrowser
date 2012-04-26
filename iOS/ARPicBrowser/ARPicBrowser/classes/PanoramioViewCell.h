//
//  PanoramioViewCell.h
//  PanoramioBrowserSample
//
//  Copyright (c) 2011 ARLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanoramioViewCell : UITableViewCell
{
    IBOutlet UILabel* _title;
    IBOutlet UILabel* _date;
    IBOutlet UIImageView* _iconImageView;
}

@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UILabel* date;
@property (strong, nonatomic) UIImageView* iconImageView;

@end
