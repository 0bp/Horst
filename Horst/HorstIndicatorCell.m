//
//  HorstIndicatorCell.m
//  Horst
//
//  Created by Boris Penck on 22.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "HorstIndicatorCell.h"

@implementation HorstIndicatorCell

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  return nil;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  /* Circle for Text */
  if(![[self stringValue] isEqualToString:@"E"]) {

    [[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f] setStroke];
    [[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.2f] setFill];

    NSRect rect = cellFrame;
    rect.size = NSMakeSize(18, 18);
    rect.origin.x += 13.5f;
    rect.origin.y += 2.5f;
  
    NSBezierPath* circlePath = [NSBezierPath bezierPath];
    [circlePath appendBezierPathWithOvalInRect: rect];

    [circlePath stroke];
    [circlePath fill];

    self.tag = 10;
  }

  NSRect backgroundFrame = cellFrame;
  
  if([self isHighlighted]) {
    
    /* Highlighted Background */
    
    backgroundFrame.origin.x -= 1;
    backgroundFrame.origin.y -= 1;
    backgroundFrame.size.height += 2;
    backgroundFrame.size.width += 3;
    
    
    NSColor * topBorder = [NSColor colorWithSRGBRed:0.54f green:0.78f blue:0.94f alpha:1.0f];
    NSColor * topBorder2 = [NSColor colorWithSRGBRed:0.54f green:0.78f blue:0.94f alpha:1.0f];
    NSColor * topColor = [NSColor colorWithSRGBRed:0.27f green:0.62f blue:0.9f alpha:1.0f];
    NSColor * bottomColor = [NSColor colorWithSRGBRed:0.15f green:0.47f blue:0.82f alpha:1.0f];
    NSColor * shadowTop = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    NSColor * shadowBottom = [NSColor colorWithSRGBRed:0.1f green:0.1f blue:0.1f alpha:1.0f];
    
    NSGradient * gradient = [[NSGradient alloc] initWithColorsAndLocations:
                             topBorder, 0.0f,
                             topBorder2, 0.043f,
                             topColor, 0.043f,
                             bottomColor, 0.957f,
                             shadowTop,0.957f,              
                             shadowBottom,1.0f,              
                             nil];
    
    [gradient drawInRect:backgroundFrame angle:90.0f];
    
    
    /* Shadow Right */
    NSColor * startingColor2 = [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    NSColor * endingColor2 =   [NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
      
    NSGradient* aGradient2 = [[NSGradient alloc]
                                initWithStartingColor:startingColor2
                                endingColor:endingColor2];
      
    NSRect shadow = NSMakeRect(cellFrame.origin.x+cellFrame.size.width-2, 
                                 cellFrame.origin.y-2,
                                 4, 
                                 cellFrame.size.height+2);
      
    [aGradient2 drawInRect:shadow angle:180];      

  }  
  
  /* Illegal Character Signal */
  if([[self stringValue] isEqualToString:@"E"])
  {
    NSRect rect = cellFrame;
    rect.size = NSMakeSize(13, 13);
    rect.origin.x += 16.0f;
    rect.origin.y += 19.0f;

    NSImage * image = [NSImage imageNamed:@"Caution.tif"];
    image.size = NSMakeSize(13,13);
    [image compositeToPoint:rect.origin
                      operation:NSCompositeSourceOver];
    
  } else {
    [super drawWithFrame:cellFrame inView:controlView];
  }
}

- (NSRect)drawingRectForBounds:(NSRect)theRect
{
	NSRect newRect = [super drawingRectForBounds:theRect];
  
	if (mIsEditingOrSelecting == NO)
	{
		NSSize textSize = [self cellSizeForBounds:theRect];
    
		float heightDelta = newRect.size.height-2 - textSize.height;	
		if (heightDelta > 0)
		{
			newRect.size.height -= heightDelta;
			newRect.origin.y += (heightDelta / 2);
		}
    newRect.origin.x += 5;
    newRect.size.width -= 5;
	}
	
	return newRect;
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(long)selStart length:(long)selLength
{
	aRect = [self drawingRectForBounds:aRect];
	mIsEditingOrSelecting = YES;	
	[super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
	mIsEditingOrSelecting = NO;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{	
	aRect = [self drawingRectForBounds:aRect];
	mIsEditingOrSelecting = YES;
	[super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
	mIsEditingOrSelecting = NO;
}

@end
