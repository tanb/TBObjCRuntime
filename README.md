TBObjCRuntime
=============

Objective-C Runtime API wrapper

##Functions

###tb_descriptionForClassName
Describes ivars, properties, protocols, class methods and instance methods of a given class.
```objective-c
NSString * tb_descriptionForClassName(NSString *className);
```
###tb_descriptionForProtocolName
Describes properties, inherited protocols, optional class methods, required class methods, optional instance methods, and required instance methods of a given protocol.
```objective-c
NSString * tb_descriptionForProtocolName(NSString *protocolName);
```

##Usage
```objective-c
(lldb) po tb_descriptionForClassName(@"NSUndoManager")
$1 = 0x0710d5b0 --description--
class:
  NSUndoManager

ivars:
        _undoStack, @
        _redoStack, @
        _runLoopModes, @"NSArray"
        _NSUndoManagerPrivate1, Q
        _target, @
        _proxy, @
        _NSUndoManagerPrivate2, ^v
        _NSUndoManagerPrivate3, ^v

properties:

protocols:

class_methods:
        _initializeSafeCategory, @:, v
        _setEndsTopLevelGroupingsAfterRunLoopIterations:, @:c, v
        _endTopLevelGroupings, @:, v

instance_methods:
        undoMenuItemTitle, @:, @
        redoMenuItemTitle, @:, @
        isUndoRegistrationEnabled, @:, c
        removeAllActions, @:, v
        setGroupsByEvent:, @:c, v
        _methodSignatureForTargetSelector:, @::, @
        _forwardTargetInvocation:, @:@, v
        _undoStack, @:, @
        endUndoGrouping, @:, v
        _processEndOfEventNotification:, @:@, v
        _endUndoGroupRemovingIfEmpty:, @:c, c
        disableUndoRegistration, @:, v
        undoNestedGroup, @:, v
        enableUndoRegistration, @:, v
        _shouldCoalesceTypingForText::, @:@@, c
        _commitUndoGrouping, @:, v
        _rollbackUndoGrouping, @:, v
        _delayAutomaticTermination:, @:d, v
        runLoopModes, @:, @
        _scheduleAutomaticTopLevelGroupEnding, @:, v
        beginUndoGrouping, @:, v
        _prepareEventGrouping, @:, v
        _postCheckpointNotification, @:, v
        _cancelAutomaticTopLevelGroupEnding, @:, v
        canRedo, @:, c
        groupsByEvent, @:, c
        _registerUndoObject:, @:@, v
        _setGroupIdentifier:, @:@, v
        canUndo, @:, c
        undoActionName, @:, @
        undoMenuTitleForUndoActionName:, @:@, @
        redoActionName, @:, @
        redoMenuTitleForUndoActionName:, @:@, @
        setLevelsOfUndo:, @:I, v
        levelsOfUndo, @:, I
        setRunLoopModes:, @:@, v
        prepareWithInvocationTarget:, @:@, @
        setActionIsDiscardable:, @:c, v
        undoActionIsDiscardable, @:, c
        redoActionIsDiscardable, @:, c
        finalize, @:, v
        isUndoing, @:, c
        isRedoing, @:, c
        registerUndoWithTarget:selector:object:, @:@:@, v
        setActionName:, @:@, v
        groupingLevel, @:, i
        removeAllActionsWithTarget:, @:@, v
        undo, @:, v
        redo, @:, v
        dealloc, @:, v
        init, @:, @
```
```objective-c
(lldb) po tb_descriptionForProtocolName(@"UITextEffectsOrdering")
$2 = 0x0755f8f0 --description--
protocol:
  UITextEffectsOrdering

properties:

inherited_protocols:

optional_class_methods:

required_class_methods:

optional_instance_methods:

required_instance_methods:
        textEffectsVisibilityLevel, i8@0:4
        textEffectsVisibilityLevelWhenKey, i8@0:4
```
