/*
 * Copyright 2016, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 */

// This file is generated by COGENT version 2.3.0.0-b3438dfb09
// with command ./cogent -g --table-c-types=pass_simple-take-letput.table pass_simple-take-letput.cogent
// at Fri, 15 May 2015 16:46:27 AEST

#include "pass_simple-take-letput.h"

static inline t1* foobar(t1* a1)
{
    t1* r2 = a1;
    u16 r3 = (*r2).x;
    t1* r4 = r2;
    
    (*r4).x = r3;
    
    t1* r5 = r4;
    t1* r6 = r5;
    
    return r6;
}
static inline t2* foo(t2* a1)
{
    t2* r2 = a1;
    u8 r3 = (*r2).x;
    t2* r4 = r2;
    
    (*r4).x = r3;
    
    t2* r5 = r4;
    t2* r6 = r5;
    
    return r6;
}

