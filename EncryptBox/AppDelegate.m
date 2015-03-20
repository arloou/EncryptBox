//
//  AppDelegate.m
//  EncryptBox
//
//  Created by ucs on 15/1/20.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString * filePath=[DOCUMENTPATH stringByAppendingPathComponent:INTRODUCEFILENAME];
    NSFileManager * fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        NSString * message_En=@"Apple Watch works with its paired iPhone to display local and remote notifications. Initially, Apple Watch uses a minimal interface to display incoming notifications. When the user’s movement indicates a desire to see more information, the minimal interface changes to a more detailed interface displaying the contents of the notification. You can customize this detailed interface and add custom graphics or arrange the notification data differently from the default interface provided by the system Apple Watch provides automatic support for the actionable notifications introduced in iOS 8. Actionable notifications are a way to add buttons to your notification interface that reflect actions the user might take. For example, a notification for a meeting invite might include buttons to accept or reject the invitation. When your iOS app registers support for actionable notifications, Apple Watch automatically adds appropriate buttons to the notification interfaces on Apple Watch. All you need to do is handle the actions that the user selects. You do this in your WatchKit extension.";
        NSString * message_Ch=@"EncryptBox是一款加密保存各类账户信息的应用，简单精致和绝对安全，应用本身不联网，用户的所有账户敏感信息经过用户自定秘钥后进行AES 256bit高级加密标准加密(美国联邦政府采用的一种区块加密标准)，以文件形式保存在应用沙盒中，便于转移，但文件内容无法被编译或攻破，即便是开发者本身也无法获取用户的信息。是一款先进的佩戴式智能手表，可持续监测用户的身体状况。它使用LED光学心率监测器来监测心率，可计算卡路里摄入，具有GPS功能，并且可以像普通手表一样看时间。Surge是目前Fitbit 旗下最强大最精工的一款，售价约250美元(合人民币1550元)。奥巴马之前曾透露过他对新兴的可佩戴式科技很感兴趣。在美国科技网站Re/code 2月对奥巴马的访谈中，他曾表示在Fitbit和Apple watch之间难以抉择。17日，奥巴马就戴着Fitbit智能手表亮相公众活动。                                                                                                                                        ";

        NSDictionary * messageDic=[NSDictionary dictionaryWithObjectsAndKeys:message_En,@"En",message_Ch,@"Ch", nil];
        
        [messageDic writeToFile:filePath atomically:YES];
    }
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 每当进入唤醒这个应用，退回首页，重新输入密码
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (appRootVC.presentedViewController) {
        [appRootVC.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lzz.EncryptBox" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EncryptBox" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EncryptBox.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
