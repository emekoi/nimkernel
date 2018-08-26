//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

#ifndef _STRING_H_
#define _STRING_H_ 1

#define NULL ((void *)0)

size_t strlen(const char *);
int memcmp(const void *s1, const void *s2, size_t n);
void *memcpy(void *dest, const void *src, size_t n);
void *memset(void *s, int c, size_t n);
void *memmove(void *dest, const void *src, size_t n);

// char *strcat(char *dest, const char *src);
// char *strchr(const char *str, int c);
// int strcmp(const char *str1, const char *str2);
// char *strcpy(char *dest, const char *src);
// char *strncpy(char *dest, const char *src, size_t n);
// char *strstr(const char *haystack, const char *needle);
// char *strtok(char *str, const char *delim);

#endif
