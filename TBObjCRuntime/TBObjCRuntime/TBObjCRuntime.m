//
//  TBObjCRuntime.m
//  TBObjCRuntime
//
//  Created by tanB on 8/3/13.
//  Copyright (c) 2013 tanB. All rights reserved.
//

#import "TBObjCRuntime.h"
#import <objc/runtime.h>


/***********	Wrapper class		***********/
@interface TBIvar: NSObject {
@private
    Ivar _ivar;
}
- (id)initWithIvar:(Ivar)ivar;
@end

@interface TBMethod: NSObject {
@private
    Method _method;
}
- (id)initWithMethod:(Method)method;
@end

@interface TBMethodDescription: NSObject {
@private
    struct objc_method_description _method_description;
}
- (id)initWithMethodDescription:(struct objc_method_description)method_description;
@end

@interface TBProperty: NSObject {
@private
    objc_property_t _property;
}
- (id)initWithProperty:(objc_property_t)property;
@end

@interface TBProtocol: NSObject {
@private
    Protocol *_protocol;
}
- (id)initWithProtocol:(Protocol *)property;
- (NSArray *)requiredInstanceMethods;
- (NSArray *)instanceMethods;
- (NSArray *)requiredClassMethods;
- (NSArray *)classMethods;
- (NSArray *)properties;
- (NSArray *)protocols;
@end

@implementation TBIvar
- (id)initWithIvar:(Ivar)ivar
{
    self = [super init];
    if (!self) return nil;
    _ivar = ivar;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"%@, %@", [self name], [self typeEncoding]];
}

- (NSString *)name
{
    return [NSString stringWithUTF8String:ivar_getName(_ivar)];
}

- (NSString *)typeEncoding
{
    return [NSString stringWithUTF8String:ivar_getTypeEncoding(_ivar)];
}

@end

@implementation TBMethod
- (id)initWithMethod:(Method)method
{
    self = [super init];
    if (!self) return nil;
    _method = method;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"%@, %@, %@", [self name], [self argumentsType], [self returnType]];
}

- (NSString *)name
{
    return NSStringFromSelector(method_getName(_method));
}

- (NSString *)returnType
{
    char *copied_type = method_copyReturnType(_method);
    NSString *return_type = [NSString stringWithUTF8String:copied_type];
    free(copied_type);
    return return_type;
}

- (NSString *)argumentsType
{
    int num_of_args = method_getNumberOfArguments(_method);
    NSMutableArray *argsTypes = [@[] mutableCopy];
    for (int i = 0; i < num_of_args; i++) {
        char *copied_type = method_copyArgumentType(_method, i);
        argsTypes[i] = [NSString stringWithUTF8String:copied_type];
        free(copied_type);
    }
    return [argsTypes componentsJoinedByString:@""];
}
@end

@implementation TBMethodDescription
- (id)initWithMethodDescription:(struct objc_method_description)method_description
{
    self = [super init];
    if (!self) return nil;
    _method_description = method_description;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"%@, %@", [self name], [self types]];
}

- (NSString *)name
{
    return NSStringFromSelector(_method_description.name);
}

- (NSString *)types
{
    return [NSString stringWithUTF8String:_method_description.types];
}
@end


@implementation TBProperty
- (id)initWithProperty:(objc_property_t)property
{
    self = [super init];
    if (!self) return nil;
    _property = property;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"%@, %@", [self name], [self attributes]];
}

- (NSString *)name
{
    return [NSString stringWithUTF8String:property_getName(_property)];
}

- (NSString *)attributes
{
    return [NSString stringWithUTF8String:property_getAttributes(_property)];
}

@end

@implementation TBProtocol
- (id)initWithProtocol:(Protocol *)protocol
{
    self = [super init];
    if (!self) return nil;
    _protocol = protocol;
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"%@", [self name]];
}

- (NSString *)name
{
    return [NSString stringWithUTF8String: protocol_getName(_protocol)];
}

- (NSArray *)requiredInstanceMethods
{
    unsigned int count;
    NSMutableArray *array = [@[] mutableCopy];
    struct objc_method_description *list = protocol_copyMethodDescriptionList(_protocol, YES, YES, &count);
    for (int i = 0; i < count; i++) {
        array[i] = [[TBMethodDescription alloc] initWithMethodDescription:list[i]];
    }
    free(list);
    return array;
}

- (NSArray *)instanceMethods
{
    unsigned int count;
    NSMutableArray *array = [@[] mutableCopy];
    struct objc_method_description *list = protocol_copyMethodDescriptionList(_protocol, NO, YES, &count);
    for (int i = 0; i < count; i++) {
        array[i] = [[TBMethodDescription alloc] initWithMethodDescription:list[i]];
    }
    free(list);
    return array;
}

- (NSArray *)requiredClassMethods
{
    unsigned int count;
    NSMutableArray *array = [@[] mutableCopy];
    struct objc_method_description *list = protocol_copyMethodDescriptionList(_protocol, YES, NO, &count);
    for (int i = 0; i < count; i++) {
        array[i] = [[TBMethodDescription alloc] initWithMethodDescription:list[i]];
    }
    free(list);
    return array;
}

- (NSArray *)classMethods
{
    unsigned int count;
    NSMutableArray *array = [@[] mutableCopy];
    struct objc_method_description *list = protocol_copyMethodDescriptionList(_protocol, NO, NO, &count);
    for (int i = 0; i < count; i++) {
        array[i] = [[TBMethodDescription alloc] initWithMethodDescription:list[i]];
    }
    free(list);
    return array;
}

- (NSArray *)properties
{
    unsigned int count;
    objc_property_t *list = protocol_copyPropertyList(_protocol, &count);
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < count; i++) {
        array[i] = [[TBProperty alloc] initWithProperty:list[i]];
    }
    free(list);
    return array;
}

- (NSArray *)protocols
{
    unsigned int count;
    Protocol * __unsafe_unretained *list = protocol_copyProtocolList(_protocol, &count);
    
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < count; i++) {
        array[i] = [[TBProtocol alloc] initWithProtocol:list[i]];
    }
    free(list);
    return array;
}
@end


/***********	TBObjCRuntime category		***********/
@implementation NSObject (TBObjCRuntime)
+ (NSArray *)tb_ivars
{
    unsigned int count;
    Ivar *list = class_copyIvarList(self, &count);
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < count; i++) {
        array[i] = [[TBIvar alloc] initWithIvar:list[i]];
    }
    free(list);
    return array;
}

+ (NSArray *)tb_methods
{
    unsigned int count;
    Method *list = class_copyMethodList(self, &count);
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < count; i++) {
        array[i] = [[TBMethod alloc] initWithMethod:list[i]];
    }
    free(list);
    return array;
}

+ (NSArray *)tb_properties
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList(self, &count);
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < count; i++) {
        array[i] = [[TBProperty alloc] initWithProperty:list[i]];
    }
    free(list);
    return array;
}

+ (NSArray *)tb_protocols
{
    unsigned int count;
    Protocol * __unsafe_unretained *list = class_copyProtocolList(self, &count);
   
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < count; i++) {
        array[i] = [[TBProtocol alloc] initWithProtocol:list[i]];
    }
    free(list);
    return array;
}

NSString * tb_descriptionForClassName(NSString *className)
{
    Class cls = NSClassFromString(className);
    NSMutableArray *desc_arr = [@[] mutableCopy];
    [desc_arr addObjectsFromArray:@[@"--description--\n",
                                    @"class:\n\t", className, @"\n"]];
    [desc_arr addObject:@"\n"];

    [desc_arr addObject:@"ivars:\n"];
    NSArray *ivars = [cls tb_ivars];
    for (TBIvar *ivar in ivars) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[ivar description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"properties:\n"];
    NSArray *properties = [cls tb_properties];
    for (TBProperty *property in properties) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[property description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"protocols:\n"];
    NSArray *protocols = [cls tb_protocols];
    for (TBProperty *protocol in protocols) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[protocol description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    Class meta_cls = objc_getMetaClass([className UTF8String]);
    [desc_arr addObject:@"class_methods:\n"];
    NSArray *class_methods = [meta_cls tb_methods];
    for (TBMethod *method in class_methods) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[method description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];

    [desc_arr addObject:@"instance_methods:\n"];
    NSArray *methods = [cls tb_methods];
    for (TBMethod *method in methods) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[method description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    return [desc_arr componentsJoinedByString:@""];
}

NSString * tb_descriptionForProtocolName(NSString *protocolName)
{
    TBProtocol *protocol = [[TBProtocol alloc] initWithProtocol:NSProtocolFromString(protocolName)];
    NSMutableArray *desc_arr = [@[] mutableCopy];
    [desc_arr addObjectsFromArray:@[@"--description--\n",
     @"protocol:\n\t", protocolName, @"\n"]];
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"properties:\n"];
    NSArray *properties = [protocol properties];
    for (TBProperty *property in properties) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[property description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];

    [desc_arr addObject:@"inherited_protocols:\n"];
    NSArray *protocols = [protocol protocols];
    for (TBProtocol *inherited_protocol in protocols) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[inherited_protocol description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"optional_class_methods:\n"];
    NSArray *optional_class_methods = [protocol classMethods];
    for (TBMethodDescription *optional_class_method in optional_class_methods) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[optional_class_method description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"required_class_methods:\n"];
    NSArray *required_class_methods = [protocol requiredClassMethods];
    for (TBMethodDescription *required_class_method in required_class_methods) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[required_class_method description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"optional_instance_methods:\n"];
    NSArray *optional_instance_methods = [protocol instanceMethods];
    for (TBMethodDescription *optional_instance_method in optional_instance_methods) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[optional_instance_method description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    [desc_arr addObject:@"required_instance_methods:\n"];
    NSArray *required_instance_methods = [protocol requiredInstanceMethods];
    for (TBMethodDescription *required_instance_method in required_instance_methods) {
        [desc_arr addObject:@"\t"];
        [desc_arr addObject:[required_instance_method description]];
        [desc_arr addObject:@"\n"];
    }
    [desc_arr addObject:@"\n"];
    
    return [desc_arr componentsJoinedByString:@""];
}
@end
