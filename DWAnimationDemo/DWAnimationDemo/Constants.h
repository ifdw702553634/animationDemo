//
//  Constants.h
//  PhotoSelectDemo
//
//  Created by mude on 17/1/10.
//  Copyright © 2017年 DreamTouch. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//color
#define Rgb2UIColor(r, g, b, a)        [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:((a)/1.0)]

//size
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define SCREEN_WIDTH  ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define TABLEVIEW_RECT CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)
#define TABLEVIEW_RECT_WITHOUTNAV CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20)
//APP INFO
#define APP_DISPLAYNAME     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define ALERT_TITLE APP_DISPLAYNAME
#define VERSION             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define SystemVersion [[UIDevice currentDevice] systemVersion]
#define SystemBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#ifdef DEBUG
#define DBG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DBG(format, ...)
#endif


#define IS_NULL_STRING(__POINTER) \
(__POINTER == nil || \
__POINTER == (NSString *)[NSNull null] || \
![__POINTER isKindOfClass:[NSString class]] || \
![__POINTER length])

#endif /* Constants_h */
