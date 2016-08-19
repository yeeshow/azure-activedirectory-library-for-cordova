/*******************************************************************************
 * Copyright (c) Microsoft Open Technologies, Inc.
 * All Rights Reserved
 * See License in the project root for license information.
 ******************************************************************************/

#import "CordovaAdalUtils.h"

@implementation CordovaAdalUtils

// + (id)ADUserInformationToDictionary:(ADUserInformation *)obj
// {
//     if (!obj)
//     {
//         return [NSNull null];
//     }
//     
//     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
//     
//     [dict setObject:ObjectOrNull(obj.userId) forKey:@"userId"];
//     if ([obj userIdDisplayable])
//     {
//         [dict setObject:ObjectOrNull(obj.userId) forKey:@"displayableId"];
//     }
//     [dict setObject:ObjectOrNull([obj userId]) forKey:@"uniqueId"];
//     [dict setObject:ObjectOrNull([obj familyName]) forKey:@"familyName"];
//     [dict setObject:ObjectOrNull([obj givenName]) forKey:@"givenName"];
//     [dict setObject:ObjectOrNull([obj identityProvider]) forKey:@"identityProvider"];
//     [dict setObject:ObjectOrNull([obj tenantId]) forKey:@"tenantId"];
//     return dict;
// }

+ (NSMutableDictionary *)ADAuthenticationResultToDictionary:(ADAuthenticationResult *)obj
{
    NSMutableDictionary *dict = (obj.status == AD_SUCCEEDED) ? [CordovaAdalUtils ADTokenCacheStoreItemToDictionary:obj.tokenCacheStoreItem] : [CordovaAdalUtils ADAuthenticationErrorToDictionary:obj.error];
    
    [dict setObject:[NSNumber numberWithInt:obj.status] forKey:@"statusCode"];
    
    return dict;
}


+ (NSMutableDictionary *)ADAuthenticationErrorToDictionary:(ADAuthenticationError *)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:ObjectOrNull(stringForADErrorCode(obj.code)) forKey:@"errorCode"];
    [dict setObject:ObjectOrNull(obj.protocolCode) forKey:@"error"];
    [dict setObject:ObjectOrNull(obj.errorDetails) forKey:@"errorDescription"];
    return dict;
}

+ (NSMutableDictionary *)ADTokenCacheStoreItemToDictionary:(ADTokenCacheStoreItem *)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dict setObject:ObjectOrNull(obj.authority) forKey:@"authority"];
    [dict setObject:ObjectOrNull(obj.clientId) forKey:@"clientId"];
    [dict setObject:ObjectOrNull(obj.tokenType) forKey:@"tokenType"];
    [dict setObject:ObjectOrNull(obj.refreshToken) forKey:@"refreshToken"];
    [dict setObject:ObjectOrNull(obj.policy) forKey:@"policy"];
    [dict setObject:[NSNumber numberWithBool:obj.refreshToken != nil] forKey:@"isMultipleResourceRefreshToken"];
    
    if(obj.token) // could be nil
    {
        [dict setObject:ObjectOrNull(obj.token) forKey:@"token"];
    }
    
    if (obj.expiresOn) // could be nil
    {
        [dict setObject:[NSNumber numberWithDouble:[obj.expiresOn timeIntervalSince1970] * 1000] forKey:@"expiresOn"];
    }
    
   // if (obj.profileInfo)
   // {
   //     //[dict setObject:[CordovaAdalUtils ADUserInformationToDictionary:obj.userInformation] forKey:@"userInfo"];
   //     [dict setObject:ObjectOrNull([obj.profileInfo tenantId]) forKey:@"tenantId"];
   //     [dict setObject:ObjectOrNull(obj.profileInfo.rawIdToken) forKey:@"idToken"];
   // }
    
    return dict;
}

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}

+ (NSString *)mapUserIdToUserName:(ADAuthenticationContext *)authContext
                           userId:(NSString *)userId
{

    // v3.0.0-pre.2 ADKeychainTokenCacheStore definition does not give access to 'allItems'
    
//    // not nil or empty string
//    if (userId && [userId length] > 0)
//    {
//        ADAuthenticationError *error;
//        
//        ADKeychainTokenCacheStore* cacheStore = [ADKeychainTokenCacheStore new];
//        NSArray *cacheItems = [cacheStore allItems:&error];
//        
//        if (error == nil)
//        {
//            for (ADTokenCacheStoreItem *obj in cacheItems)
//            {
//                if ([userId isEqualToString:obj.userInformation.userObjectId])
//                {
//                    return obj.userInformation.userId;
//                }
//            }
//        }
//    }
    
    return userId;
}

static NSString* stringForADErrorCode(NSInteger code)
{
    // See https://github.com/AzureAD/azure-activedirectory-library-for-objc/blob/dev/ADAL/src/public/ADErrorCodes.h
    NSDictionary* errorCodes = @{
                                 [NSNumber numberWithInt:0]:    @"AD_ERROR_SUCCEEDED",
                                 [NSNumber numberWithInt:-1]:   @"AD_ERROR_UNEXPECTED",
                                 [NSNumber numberWithInt:100]:  @"AD_ERROR_DEVELOPER_INVALID_ARGUMENT",
                                 [NSNumber numberWithInt:101]:  @"AD_ERROR_DEVELOPER_AUTHORITY_VALIDATION",
                                 [NSNumber numberWithInt:200]:  @"AD_ERROR_SERVER_USER_INPUT_NEEDED",
                                 [NSNumber numberWithInt:201]:  @"AD_ERROR_SERVER_WPJ_REQUIRED",
                                 [NSNumber numberWithInt:202]:  @"AD_ERROR_SERVER_OAUTH",
                                 [NSNumber numberWithInt:203]:  @"AD_ERROR_SERVER_REFRESH_TOKEN_REJECTED",
                                 [NSNumber numberWithInt:204]:  @"AD_ERROR_SERVER_WRONG_USER",
                                 [NSNumber numberWithInt:205]:  @"AD_ERROR_SERVER_NON_HTTPS_REDIRECT",
                                 [NSNumber numberWithInt:206]:  @"AD_ERROR_SERVER_INVALID_ID_TOKEN",
                                 [NSNumber numberWithInt:207]:  @"AD_ERROR_SERVER_MISSING_AUTHENTICATE_HEADER",
                                 [NSNumber numberWithInt:208]:  @"AD_ERROR_SERVER_AUTHENTICATE_HEADER_BAD_FORMAT",
                                 [NSNumber numberWithInt:209]:  @"AD_ERROR_SERVER_UNAUTHORIZED_CODE_EXPECTED",
                                 [NSNumber numberWithInt:210]:  @"AD_ERROR_SERVER_UNSUPPORTED_REQUEST",
                                 [NSNumber numberWithInt:211]:  @"AD_ERROR_SERVER_AUTHORIZATION_CODE",
                                 [NSNumber numberWithInt:300]:  @"AD_ERROR_CACHE_MULTIPLE_USERS",
                                 [NSNumber numberWithInt:301]:  @"AD_ERROR_CACHE_VERSION_MISMATCH",
                                 [NSNumber numberWithInt:302]:  @"AD_ERROR_CACHE_BAD_FORMAT",
                                 [NSNumber numberWithInt:303]:  @"AD_ERROR_CACHE_NO_REFRESH_TOKEN",
                                 [NSNumber numberWithInt:400]:  @"AD_ERROR_UI_MULTLIPLE_INTERACTIVE_REQUESTS",
                                 [NSNumber numberWithInt:401]:  @"AD_ERROR_UI_NO_MAIN_VIEW_CONTROLLER",
                                 [NSNumber numberWithInt:402]:  @"AD_ERROR_UI_NOT_SUPPORTED_IN_APP_EXTENSION",
                                 [NSNumber numberWithInt:403]:  @"AD_ERROR_UI_USER_CANCEL",
                                 [NSNumber numberWithInt:404]:  @"AD_ERROR_UI_NOT_ON_MAIN_THREAD",
                                 [NSNumber numberWithInt:500]:  @"AD_ERROR_TOKENBROKER_UNKNOWN",
                                 [NSNumber numberWithInt:501]:  @"AD_ERROR_TOKENBROKER_INVALID_REDIRECT_URI",
                                 [NSNumber numberWithInt:502]:  @"AD_ERROR_TOKENBROKER_RESPONSE_HASH_MISMATCH",
                                 [NSNumber numberWithInt:503]:  @"AD_ERROR_TOKENBROKER_RESPONSE_NOT_RECEIVED",
                                 [NSNumber numberWithInt:504]:  @"AD_ERROR_TOKENBROKER_FAILED_TO_CREATE_KEY",
                                 [NSNumber numberWithInt:505]:  @"AD_ERROR_TOKENBROKER_DECRYPTION_FAILED"};

    return [errorCodes objectForKey:[NSNumber numberWithInt:(int)code]];

}

@end
