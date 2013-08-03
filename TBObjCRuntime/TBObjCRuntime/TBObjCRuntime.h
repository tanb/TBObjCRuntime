//
//  TBObjCRuntime.h
//  TBObjCRuntime
//
//  Created by tanB on 8/3/13.
//  Copyright (c) 2013 tanB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TBObjCRuntime)
// Describes ivars, properties, protocols, class methods and instance methods of a given class.
NSString * tb_descriptionForClassName(NSString *className);
// Describes properties, inherited protocols, optional class methods, required class methods, optional instance methods, and required instance methods of a given protocol.
NSString * tb_descriptionForProtocolName(NSString *protocolName);

@end
