//
//  AppDelegate.h
//  MyLvJing
//
//  Created by uhut on 15/4/20.
//  Copyright (c) 2015年 KZW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    PhotoViewController *rootViewController;
}

@property (strong, nonatomic) UIWindow *window;


@end

