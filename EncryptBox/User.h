//
//  User.h
//  EncryptBox
//
//  Created by ucs on 15/1/27.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * enterPassWord;
@property (nonatomic, retain) NSNumber * isFirstLogin;

@end
