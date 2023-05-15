Instrucciones para probar las interrupciones (Checkpoint 2)
int3 -> breakpoint

xor eax, eax
div eax -> divide by zero

mov eax, [0xFFFF0000] -> genera protection fault


PIC

0x20, 0xA0: ICW1 -> Config(Cascada, ICN4 Si, ...) 
0x21, 0xA1: ICW2 -> Offset
            ICW3 -> Configuración Master
            ICW4 -> Config (8086, No auto EOI, etc.)




f) ¿Qué es el buffer auxiliar de traducción (translation lookaside buffer o TLB) y por qué es necesario purgarlo (tlbflush) al introducir modificaciones a nuestras estructuras de paginación (directorio, tabla de páginas o CR3)?

Al igual que en el caso de la segmentación en donde  el procesador posee un cache asociado a cada registro de segmento para leer una sola vez el descriptor, en la Unidad de Paginación existe un caché de traducciones: el Translation Lookaside Buffer (o TLB)

Es una memoria caché pequeña donde guardamos las traducciones. 
Guardo SOLO el par directorio-tabla y lo pone al lado del descriptor de página que encontré gracias a la dirección lineal (directorio,tabla y offset).Es decir, guarda la traducción. 
La idea es que primero busque en la TLB la página y si no lo encuentro hago todo los pasos de ir y buscarlo con en las tablas. 
Al ser una memoria tipo caché los accesos se hacen muy rápidos. La política de desalojo en la TLB es LRU. Para esto utiliza algunos bits de control.
Es necesario purgarlo para poder tener la versión más actualizada de las páginas y, además, puede llegar a ocurrir que la TLB se llene por completo y nunca encuentre después las demás páginas que vaya a usar ocurriendo así una pérdida de acceso a las páginas.
