//
//  fullImageView.h
//  IO_Manager
//
//  Created by Matias Seibert on 12/6/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "overlayControl.h"

@interface fullImageView : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (nonatomic, strong) id delegate;
- (id)initWithImage:(UIImage *)image;
- (IBAction)donePressed:(id)sender;

@end
