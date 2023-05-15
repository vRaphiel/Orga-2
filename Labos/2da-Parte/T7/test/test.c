/* --- PRINTF_BYTE_TO_BINARY macro's --- */
#define PRINTF_BINARY_SEPARATOR
#define PRINTF_BINARY_PATTERN_INT8 "%c%c%c%c%c%c%c%c"
#define PRINTF_BYTE_TO_BINARY_INT8(i) \
    (((i)&0x80ll) ? '1' : '0'),       \
    (((i)&0x40ll) ? '1' : '0'),   \
    (((i)&0x20ll) ? '1' : '0'),   \
    (((i)&0x10ll) ? '1' : '0'),   \
    (((i)&0x08ll) ? '1' : '0'),   \
    (((i)&0x04ll) ? '1' : '0'),   \
    (((i)&0x02ll) ? '1' : '0'),   \
    (((i)&0x01ll) ? '1' : '0')

#define PRINTF_BINARY_PATTERN_INT16 \
    PRINTF_BINARY_PATTERN_INT8 PRINTF_BINARY_SEPARATOR PRINTF_BINARY_PATTERN_INT8
#define PRINTF_BYTE_TO_BINARY_INT16(i) \
    PRINTF_BYTE_TO_BINARY_INT8((i) >> 8), PRINTF_BYTE_TO_BINARY_INT8(i)
#define PRINTF_BINARY_PATTERN_INT32 \
    PRINTF_BINARY_PATTERN_INT16 PRINTF_BINARY_SEPARATOR PRINTF_BINARY_PATTERN_INT16
#define PRINTF_BYTE_TO_BINARY_INT32(i) \
    PRINTF_BYTE_TO_BINARY_INT16((i) >> 16), PRINTF_BYTE_TO_BINARY_INT16(i)
#define PRINTF_BINARY_PATTERN_INT64 \
    PRINTF_BINARY_PATTERN_INT32 PRINTF_BINARY_SEPARATOR PRINTF_BINARY_PATTERN_INT32
#define PRINTF_BYTE_TO_BINARY_INT64(i) \
    PRINTF_BYTE_TO_BINARY_INT32((i) >> 32), PRINTF_BYTE_TO_BINARY_INT32(i)
/* --- end macros --- */

#define VIRT_PAGE_OFFSET(X) (uint16_t)(((uint32_t)(X)) & 0x00000FFF)
#define VIRT_PAGE_TABLE(X) (uint16_t)(((uint32_t)(X) >> 12) & 0x000003FF)
#define VIRT_PAGE_DIR(X) (uint16_t)(((uint32_t)(X) >> 22) & 0x000003FF)

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

int main(){
    uint32_t dato = 0x91432341;
    uint16_t ret = VIRT_PAGE_TABLE(dato);

    printf("Datp " PRINTF_BINARY_PATTERN_INT32 "\n",
           PRINTF_BYTE_TO_BINARY_INT32(dato));

    printf("Ret " PRINTF_BINARY_PATTERN_INT16 "\n",
           PRINTF_BYTE_TO_BINARY_INT16(ret));
    return 0;
}