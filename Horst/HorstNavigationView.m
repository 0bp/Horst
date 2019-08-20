//
//  HorstNavigationView.m
//  Horst
//
//  Created by Boris Penck on 22.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstNavigationView.h"

@implementation HorstNavigationView

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
  NSColor * startingColor = [NSColor colorWithSRGBRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
  NSColor * endingColor =   [NSColor colorWithSRGBRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
  
  NSGradient* aGradient = [[NSGradient alloc]
                             initWithStartingColor:startingColor
                             endingColor:endingColor];

  [aGradient drawInRect:[self bounds] angle:270];
  
  /* Shadow */
  
  NSColor * startingColor2 = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
  NSColor * endingColor2 =   [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
  
  NSGradient* aGradient2 = [[NSGradient alloc]
                            initWithStartingColor:startingColor2
                            endingColor:endingColor2];
  
  NSRect shadow = NSMakeRect(self.bounds.origin.x+self.bounds.size.width-4, 
                             self.bounds.origin.y,
                             4, 
                             self.bounds.size.height);
  
  [aGradient2 drawInRect:shadow angle:180];

}
@end
