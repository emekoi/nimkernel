//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

#ifndef _STDLIB_H_
#define _STDLIB_H_

#include "stddef.h"

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1


void *malloc(size_t size);
void *calloc(size_t count, size_t size);
void *realloc(void *p, size_t size);
void free(void *p);

void abort() __attribute__((noreturn));
void exit(int status) __attribute__((noreturn));

#endif
