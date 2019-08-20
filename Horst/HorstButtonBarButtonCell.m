//
//  HorstButtonBarButtonCell.m
//  Horst
//
//  Created by Boris Penck on 27.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstButtonBarButtonCell.h"

@implementation HorstButtonBarButtonCell

-(void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
  //[super drawBezelWithFrame:frame inView:controlView];
}


-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  if([self isHighlighted]) 
  {
    NSColor * startingColor = [NSColor colorWithSRGBRed:0.1f green:0.1f blue:0.1f alpha:0.5f];
    NSColor * endingColor =   [NSColor colorWithSRGBRed:0.1f green:0.1f blue:0.1f alpha:0.5f];
    
    NSGradient* aGradient = [[NSGradient alloc]
                             initWithStartingColor:startingColor
                             endingColor:endingColor];
    
    [aGradient drawInRect:cellFrame angle:270];
    
  }
  [self setHighlighted:NO];
  [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
