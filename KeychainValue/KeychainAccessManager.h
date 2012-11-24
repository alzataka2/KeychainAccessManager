//
//  KeychainAccessManager.h
//  KeychainValue
//
//  Created by Akinori Takatsu on 12/11/24.
//  Copyright (c) 2012年 Akinori Takatsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainAccessManager : NSObject

// サービス名指定の初期化メソッド(-initは使用しないこと).
- (id)initWithServiceName:(NSString *)serviceName;

// パスワード保存.
- (BOOL)saveGenericPassword:(NSData *)passdata key:(NSString *)key;
// パスワード取得.
- (NSData *)getGenericPasswordForKey:(NSString *)key;
// パスワード削除.
- (BOOL)deleteGenericPassword:(NSString *)key;

@end
