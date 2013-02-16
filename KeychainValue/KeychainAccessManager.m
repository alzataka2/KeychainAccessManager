//
//  KeychainAccessManager.m
//  KeychainValue
//
//  Created by Akinori Takatsu on 12/11/24.
//  Copyright (c) 2012年 Akinori Takatsu. All rights reserved.
//

#import "KeychainAccessManager.h"

#import <Security/Security.h>


@interface KeychainAccessManager()
@property (nonatomic, strong, readwrite) NSString *serviceName;
@end


@implementation KeychainAccessManager

// アプリのBundleIdentifierをServiceNameとして使用する.
- (id)init
{
	return [self initWithServiceName:nil];
}

// serviceNameがnilの場合はアプリのBundleIdentifierをServiceNameとして使用する.
- (id)initWithServiceName:(NSString *)serviceName
{
	self = [super init];
	if (self) {
		if (serviceName) {
			self.serviceName = serviceName;
		} else {
			self.serviceName = [[NSBundle mainBundle] bundleIdentifier];
		}
	}
	
	return self;
}

- (BOOL)saveGenericPassword:(NSData *)passdata key:(NSString *)key
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id<NSCopying>)kSecClass];
	[query setObject:key forKey:(__bridge id<NSCopying>)kSecAttrAccount];
	[query setObject:self.serviceName forKey:(__bridge id<NSCopying>)kSecAttrService];
	
	// 既に登録済みの情報の場合はUpdate、未登録の場合はAddで保存する.
	NSData *data = [self getGenericPasswordForKey:key];
	OSStatus status = noErr;
	if (data) {
		// update.
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		[attributes setObject:passdata forKey:(__bridge id<NSCopying>)kSecValueData];
		[attributes setObject:key forKey:(__bridge id<NSCopying>)kSecAttrAccount];
		[attributes setObject:self.serviceName forKey:(__bridge id<NSCopying>)kSecAttrService];
		
		status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
		if (status != noErr) {
			return NO;
		}
	} else {
		// add.
		NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
		
		[attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id<NSCopying>)kSecClass];
		[attributes setObject:key forKey:(__bridge id<NSCopying>)kSecAttrAccount];
		[attributes setObject:passdata forKey:(__bridge id<NSCopying>)kSecValueData];
		[attributes setObject:self.serviceName forKey:(__bridge id<NSCopying>)kSecAttrService];
		
		status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
		if (status != noErr) {
			return NO;
		}
	}
	
	return YES;
}

- (NSData *)getGenericPasswordForKey:(NSString *)key
{
	NSData *resultData = nil;
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id<NSCopying>)kSecClass];
	[query setObject:key forKey:(__bridge id<NSCopying>)kSecAttrAccount];
	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)kSecReturnData];
	[query setObject:self.serviceName forKey:(__bridge id<NSCopying>)kSecAttrService];
	
	CFTypeRef result = NULL;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
	if (status == errSecSuccess) {
		resultData = (__bridge_transfer NSData*)result;
	}
	
	return resultData;
}

- (BOOL)deleteGenericPassword:(NSString *)key
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id<NSCopying>)kSecClass];
	[query setObject:key forKey:(__bridge id<NSCopying>)kSecAttrAccount];
	[query setObject:self.serviceName forKey:(__bridge id<NSCopying>)kSecAttrService];
	
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != noErr) {
		return NO;
	}
	
	return YES;
}

@end
