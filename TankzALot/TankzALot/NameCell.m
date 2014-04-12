//
//  NameCell.m
//  TankzALot
//
//  Created by App Jam on 4/12/14.
//  Copyright (c) 2014 LAHacks. All rights reserved.
//

#import "NameCell.h"

@implementation NameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 500, 30)];
        [self addSubview: self.titleLabel];
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
