#ifndef CLIENTE_H
#define CLIENTE_H

#define NAME_LEN 21

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

typedef struct cliente_str
{
    char nombre[NAME_LEN];
    char apellido[NAME_LEN];
    uint64_t compra;
    uint32_t dni;
} cliente_t;

typedef struct packed_cliente_str {
    char nombre[NAME_LEN];
    char apellido[NAME_LEN];
    uint64_t compra;
    uint32_t dni;
} __attribute__((packed)) packed_cliente_t;

#endif