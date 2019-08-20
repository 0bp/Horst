//
//  HorstButtonBarView.m
//  Horst
//
//  Created by Boris Penck on 27.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstButtonBarView.h"

@implementation HorstButtonBarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect
{
  NSColor * startingColor = [NSColor colorWithSRGBRed:0.3f green:0.3f blue:0.3f alpha:0.5f];
  NSColor * endingColor =   [NSColor colorWithSRGBRed:0.2f green:0.2f blue:0.2f alpha:0.5f];
  
  NSGradient* aGradient = [[NSGradient alloc]
                            initWithStartingColor:startingColor
                                      endingColor:endingColor];
  
  [aGradient drawInRect:rect angle:270];
}

@end
