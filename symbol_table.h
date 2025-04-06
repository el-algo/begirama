#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdbool.h>

typedef struct Symbol {
    char* name;
    char* label;
    int version;
    struct Symbol* next;
} Symbol;

Symbol* lookup_symbol(const char* name);
char* generate_label(const char* name, int version);
Symbol* define_symbol(const char* name);
void free_symbol_table(void);

#endif