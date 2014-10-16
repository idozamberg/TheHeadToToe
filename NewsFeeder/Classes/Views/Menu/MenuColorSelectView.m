//
//  MenuColorSelectView.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "MenuColorSelectView.h"

#define PLT_COLOR_GREEN [UIColor colorWithRed:175/255.0f green:230/255.0f blue:139/255.0f alpha:1.0f]
#define PLT_COLOR_RED   [UIColor colorWithRed:233/255.0f green: 93/255.0f blue: 78/255.0f alpha:1.0f]
#define PLT_COLOR_BLUE  [UIColor colorWithRed:126/255.0f green:200/255.0f blue:238/255.0f alpha:1.0f]
#define PLT_COLOR_BLACK [UIColor colorWithRed: 68/255.0f green: 68/255.0f blue: 68/255.0f alpha:1.0f]

@implementation MenuColorSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setTitle:(NSString *)title color:(THEME_COLOR_TYPE)color
{
    [lblTitle setText:title];
    
    [btnGreen setBackgroundColor:THEME_COLOR_GREEN];
    [btnRed   setBackgroundColor:THEME_COLOR_RED];
    [btnBlue  setBackgroundColor:THEME_COLOR_BLUE];
    [btnBlack setBackgroundColor:THEME_COLOR_BLACK];
    
    if (color == THEME_COLOR_TYPE_GREEN) {
        [self button_click:btnGreen];
    }
    else if (color == THEME_COLOR_TYPE_RED) {
        [self button_click:btnRed];
    }
    else if (color == THEME_COLOR_TYPE_BLUE) {
        [self button_click:btnBlue];
    }
    else if (color == THEME_COLOR_TYPE_BLACK) {
        [self button_click:btnBlack];
    }
}


- (IBAction) button_click:(id)sender
{
    THEME_COLOR_TYPE color = THEME_COLOR_TYPE_NONE;
    
    UIColor * bgColor;
    UIColor * pltColor;
    if ([sender isEqual:btnGreen]) {
        color = THEME_COLOR_TYPE_GREEN;
        
        bgColor = THEME_COLOR_GREEN;
        pltColor= PLT_COLOR_GREEN;
    }
    else if ([sender isEqual:btnRed]) {
        color = THEME_COLOR_TYPE_RED;
        
        bgColor = THEME_COLOR_RED;
        pltColor= PLT_COLOR_RED;
    }
    else if ([sender isEqual:btnBlue]) {
        color = THEME_COLOR_TYPE_BLUE;
        
        bgColor = THEME_COLOR_BLUE;
        pltColor= PLT_COLOR_BLUE;
    }
    else if ([sender isEqual:btnBlack]) {
        color = THEME_COLOR_TYPE_BLACK;
        
        bgColor = THEME_COLOR_BLACK;
        pltColor= PLT_COLOR_BLACK;
    }
    
    gThemeColor = bgColor;
    
    [self setBackgroundColor:bgColor];
    [viewPallete setBackgroundColor:pltColor];
    
    [btnGreen setSelected:(color == THEME_COLOR_TYPE_GREEN)];
    [btnRed   setSelected:(color == THEME_COLOR_TYPE_RED)];
    [btnBlue  setSelected:(color == THEME_COLOR_TYPE_BLUE)];
    [btnBlack setSelected:(color == THEME_COLOR_TYPE_BLACK)];
    
    
    [btnGreen setRoundedCornersWithRadius:[btnGreen isSelected] ? 4 : 2
                              borderWidth:1
                              borderColor:[UIColor clearColor]];
    
    [btnRed setRoundedCornersWithRadius:[btnRed isSelected] ? 4 : 2
                            borderWidth:1
                            borderColor:[UIColor clearColor]];
    
    [btnBlue setRoundedCornersWithRadius:[btnBlue isSelected] ? 4 : 2
                             borderWidth:1
                             borderColor:[UIColor clearColor]];
    
    [btnBlack setRoundedCornersWithRadius:[btnBlack isSelected] ? 4 : 2
                              borderWidth:1
                              borderColor:[UIColor clearColor]];
    
    if (color != THEME_COLOR_TYPE_NONE) {
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didSelectColor:color:)]) {
                [self.delegate didSelectColor:self
                                        color:color];
            }
        }
    }
}

@end
