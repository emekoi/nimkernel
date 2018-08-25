//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

#ifndef _STDDEF_H_
#define _STDDEF_H_ 1

#define NULL ((void *) 0)

typedef unsigned long size_t;
typedef long          ssize_t;
typedef long          intptr_t;
typedef typeof (((int *)0) - ((int *)0)) ptrdiff_t;

#endif
