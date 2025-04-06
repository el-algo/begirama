#include "symbol_table.h"

// Global symbol table
Symbol* symbol_table = NULL;

// Finds the name of a symbol in the symbol table
Symbol* lookup_symbol(const char* name)
{
    Symbol* current = symbol_table;
    while (current != NULL)
    {
        if (strcmp(current->name, name) == 0)
        {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Creates a label for a specific version of a symbol
char* generate_label(const char* name, int version) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "%s_%d", name, version);
    return strdup(buffer);
}

// Redefines or inserts a symbol into the symbol table
Symbol* define_symbol(const char* name)
{
    Symbol* symbol = lookup_symbol(name);
    // Redefinition
    if (symbol) {
        symbol->version += 1;
        free(symbol->label);
        symbol->label = generate_label(name, symbol->version);
        return symbol;
    }

    // New entry
    symbol = malloc(sizeof(Symbol));
    symbol->name = strdup(name);
    symbol->version = 1;
    symbol->label = generate_label(name, 1);
    symbol->next = symbol_table;
    symbol_table = symbol;
    return symbol;
}

void free_symbol_table()
{
    Symbol* current = symbol_table;
    while (current != NULL)
    {
        Symbol* next = current->next;
        free(current->name);
        free(current);
        current = next;
    }
    symbol_table = NULL;
}