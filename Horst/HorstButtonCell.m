//
//  HorstButtonCell.m
//  Horst
//
//  Created by Boris Penck on 21.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstButtonCell.h"

@implementation HorstButtonCell


- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  return nil;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  NSRect backgroundFrame = cellFrame;
  
  backgroundFrame.origin.x -= 1;
  backgroundFrame.origin.y -= 1;
  backgroundFrame.size.height -= 1;
  backgroundFrame.size.width += 3;
  
  if([self isHighlighted]) {
    
    NSColor * topBorder = [NSColor colorWithSRGBRed:0.54f green:0.78f blue:0.94f alpha:1];
    NSColor * topBorder2 = [NSColor colorWithSRGBRed:0.54f green:0.78f blue:0.94f alpha:1];
    NSColor * topColor = [NSColor colorWithSRGBRed:0.27f green:0.62f blue:0.9f alpha:1.0f];
    NSColor * bottomColor = [NSColor colorWithSRGBRed:0.15f green:0.47f blue:0.82f alpha:1.0f];
    
    NSGradient * gradient = [[NSGradient alloc] initWithColorsAndLocations:
                             topBorder, (CGFloat)0.0,
                             topBorder2, (CGFloat)0.043,
                             topColor, (CGFloat)0.043,
                             bottomColor, (CGFloat)1.0,
                             nil];
    
    
    NSColor * shadowTop = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.3f];
    NSColor * shadowBottom = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    
    NSGradient * shadow = [[NSGradient alloc] initWithColorsAndLocations:
                           shadowTop, 0.0f,
                           shadowBottom, 1.0f,
                           nil];
    
    NSRect shadowFrame = cellFrame;
    shadowFrame.origin.x -= 1;
    shadowFrame.origin.y = cellFrame.origin.y+cellFrame.size.height;
    shadowFrame.size.height = 3;
    shadowFrame.size.width += 3;
    
    [gradient drawInRect:backgroundFrame angle:90.0f];
    [shadow drawInRect:shadowFrame angle:90.0f];
    
  }
  
  [super drawWithFrame:cellFrame inView:controlView];
}


@end
