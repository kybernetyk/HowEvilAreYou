//
//  HowEvilAppDelegate.h
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright flux forge 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowEvilAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

