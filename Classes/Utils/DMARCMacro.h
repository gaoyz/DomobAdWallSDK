//
//  DMARCMacros.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/25.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

//
//  ARCMacros.h
//  InnerBand
//
// For an explanation of why these work, see:
//
//     http://raptureinvenice.com/arc-support-without-branches/
//
//  Created by John Blanco on 1/28/12.
//  Rapture In Venice releases all rights to this code.  Feel free use and/or copy it openly and freely!
//
// NOTE: __bridge_tranfer is not included here because releasing would be inconsistent.
//       Avoid it unless you're using ARC exclusively or managing it with __has_feature(objc_arc).
//

#if !defined(__clang__) || __clang_major__ < 3
    #ifndef __bridge
        #define __bridge
    #endif

    #ifndef __bridge_retain
        #define __bridge_retain
    #endif

    #ifndef __bridge_retained
        #define __bridge_retained
    #endif

    #ifndef __autoreleasing
        #define __autoreleasing
    #endif

    #ifndef __strong
        #define __strong
    #endif

    #ifndef __unsafe_unretained
        #define __unsafe_unretained
    #endif

    #ifndef __weak
        #define __weak
    #endif
#endif

#ifndef DM_STRONG
    #if __has_feature(objc_arc)
        #define DM_STRONG strong
#else
        #define DM_STRONG retain
    #endif
#endif

#ifndef DM_WEAK
    #if __has_feature(objc_arc_weak)
        #define DM_WEAK weak
    #elif __has_feature(objc_arc)
        #define DM_WEAK unsafe_unretained
    #else
        #define DM_WEAK assign
    #endif
#endif

#if __has_feature(objc_arc)
    #define DM_SAFE_ARC_PROP_RETAIN strong
    #define DM_SAFE_ARC_RETAIN(x) (x)
    #define DM_SAFE_ARC_RELEASE(x)
    #define DM_SAFE_ARC_AUTORELEASE(x) (x)
    #define DM_SAFE_ARC_BLOCK_COPY(x) (x)
    #define DM_SAFE_ARC_BLOCK_RELEASE(x)
    #define DM_SAFE_ARC_SUPER_DEALLOC()
    #define DM_SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
    #define DM_SAFE_ARC_AUTORELEASE_POOL_END() }
#else
    #define DM_SAFE_ARC_PROP_RETAIN retain
    #define DM_SAFE_ARC_RETAIN(x) ([(x) retain])
    #define DM_SAFE_ARC_RELEASE(x) ([(x) release])
    #define DM_SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
    #define DM_SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
    #define DM_SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
    #define DM_SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
    #define DM_SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    #define DM_SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif
