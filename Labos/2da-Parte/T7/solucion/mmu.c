/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "i386.h"

#include "kassert.h"

static pd_entry_t *kpd = (pd_entry_t *)KERNEL_PAGE_DIR;
static pt_entry_t *kpt = (pt_entry_t *)KERNEL_PAGE_TABLE_0;

/* static const uint32_t identity_mapping_end = 0x003FFFFF;
static const uint32_t user_memory_pool_end = 0x02FFFFFF; */

static paddr_t next_free_kernel_page = 0x100000;
static paddr_t next_free_user_page = 0x400000;

/**
 * kmemset asigna el valor c a un rango de memoria interpretado
 * como un rango de bytes de largo n que comienza en s
 * @param s es el puntero al comienzo del rango de memoria
 * @param c es el valor a asignar en cada byte de s[0..n-1]
 * @param n es el tamaño en bytes a asignar
 * @return devuelve el puntero al rango modificado (alias de s)
 */
static inline void *kmemset(void *s, int c, size_t n)
{
  uint8_t *dst = (uint8_t *)s;
  for (size_t i = 0; i < n; i++)
  {
    dst[i] = c;
  }
  return dst;
}

/**
 * zero_page limpia el contenido de una página que comienza en addr
 * @param addr es la dirección del comienzo de la página a limpiar
 */
static inline void zero_page(paddr_t addr)
{
  kmemset((void *)addr, 0x00, PAGE_SIZE);
}

void mmu_init(void) {}

/**
 * mmu_next_free_kernel_page devuelve la dirección de la próxima página de kernel disponible
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de kernel
 */
paddr_t mmu_next_free_kernel_page(void)
{
  paddr_t aux = next_free_kernel_page;
  next_free_kernel_page += PAGE_SIZE;
  return aux;
}

/**
 * mmu_next_free_user_page devuelve la dirección de la próxima página de usuarix disponible
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de usuarix
 */
paddr_t mmu_next_free_user_page(void)
{
  paddr_t aux = next_free_user_page;
  next_free_user_page += PAGE_SIZE;
  return aux;
}

/**
 * mmu_init_kernel_dir inicializa las estructuras de paginación vinculadas al kernel y
 * realiza el identity mapping
 * @return devuelve la dirección de memoria de la página donde se encuentra el directorio
 * de páginas usado por el kernel
 */
paddr_t mmu_init_kernel_dir(void)
{
  zero_page(KERNEL_PAGE_TABLE_0);
  zero_page(KERNEL_PAGE_DIR);
  // Hay que completar lo inicial de las tablas acá
  kpd[0].pt = KERNEL_PAGE_TABLE_0 >> 12; // Revisar esto
  kpd[0].attrs = 0x003;
  for (uint16_t i = 0; i < 1024; i++)
  {
    kpt[i].page = i;
    kpt[i].attrs = 0x003; // Es asi? 003 = Read Only & 1 | Directorio de Páginas
  }
  return KERNEL_PAGE_DIR;
}

/**
 * mmu_map_page agrega las entradas necesarias a las estructuras de paginación de modo de que
 * la dirección virtual virt se traduzca en la dirección física phy con los atributos definidos en attrs
 * @param cr3 el contenido que se ha de cargar en un registro CR3 al realizar la traducción
 * @param virt la dirección virtual que se ha de traducir en phy
 * @param phy la dirección física que debe ser accedida (dirección de destino)
 * @param attrs los atributos a asignar en la entrada de la tabla de páginas
 */

void mmu_map_page(uint32_t cr3, vaddr_t virt, paddr_t phy, uint32_t attrs)
{
  uint32_t cr3aux = CR3_TO_PAGE_DIR(cr3);
  uint32_t pd_index = VIRT_PAGE_DIR(virt);
  uint32_t pt_index = VIRT_PAGE_TABLE(virt);
  // uint32_t offset = VIRT_PAGE_OFFSET(virt);

  // Se inicia el directorio
  pd_entry_t *apd = (pd_entry_t *)cr3aux;

  uint32_t attrsauxpd = apd[pd_index].attrs;
  attrsauxpd = attrsauxpd & 1;
  uint32_t pageAuxPd = 0;

  // Si la pagina está presente, la traemos, si no, mmu_next_free_kernel_page
  if (attrsauxpd == 1)
  {
    pageAuxPd = apd[pd_index].pt;
  }
  else
  {
    pageAuxPd = (uint32_t)mmu_next_free_kernel_page();
    pageAuxPd = pageAuxPd >> 12;
    apd[pd_index].pt = pageAuxPd;
  }
  apd[pd_index].attrs = attrs;
  pageAuxPd = pageAuxPd << 12;

  // Se inicia la tabla de páginas
  pt_entry_t *apt = (pt_entry_t *)pageAuxPd;

  // Si la pagina está presente, la traemos, si no, mmu_next_free_kernel_page
  // if (attrsauxpt != 1) {
  apt[pt_index].page = phy >> 12;
  apt[pt_index].attrs = attrs;

  tlbflush();
}

/**
 * mmu_unmap_page elimina la entrada vinculada a la dirección virt en la tabla de páginas correspondiente
 * @param virt la dirección virtual que se ha de desvincular
 * @return la dirección física de la página desvinculada
 */

paddr_t mmu_unmap_page(uint32_t cr3, vaddr_t virt)
{
  uint32_t cr3aux = CR3_TO_PAGE_DIR(cr3);
  uint32_t pd_index = VIRT_PAGE_DIR(virt);
  uint32_t pt_index = VIRT_PAGE_TABLE(virt);

 // Se obtiene el page directory
  pd_entry_t *apd = (pd_entry_t *) cr3aux;

  // Se obtiene el page directory entry
  uint32_t PDE = apd[pd_index].pt;
  PDE = PDE << 12;

  // Se obtiene el page table
  pt_entry_t *apt = (pt_entry_t *) PDE;
  
  // Ahora se revisan los atributos
  apt[pt_index].attrs = (apt[pt_index].attrs & 0xFFE);

  paddr_t dirRet = apt[pt_index].page;
  dirRet = dirRet << 12;
  tlbflush(); 
  return dirRet;
}

#define DST_VIRT_PAGE 0xA00000
#define SRC_VIRT_PAGE 0xB00000

/**
 * copy_page copia el contenido de la página física localizada en la dirección src_addr a la página física ubicada en dst_addr
 * @param dst_addr la dirección a cuya página queremos copiar el contenido
 * @param src_addr la dirección de la página cuyo contenido queremos copiar
 *
 * Esta función mapea ambas páginas a las direcciones SRC_VIRT_PAGE y DST_VIRT_PAGE, respectivamente, realiza
 * la copia y luego desmapea las páginas. Usar la función rcr3 definida en i386.h para obtener el cr3 actual
 */

void copy_page(paddr_t dst_addr, paddr_t src_addr) {

  uint32_t cr3aux = rcr3();
  uint32_t attrsaux = 0x003; // PREGUNTAR

  uint8_t *dstp = (uint8_t*) DST_VIRT_PAGE;
  uint8_t *srcp = (uint8_t*) SRC_VIRT_PAGE;

  mmu_map_page(cr3aux, DST_VIRT_PAGE, dst_addr ,attrsaux);
  mmu_map_page(cr3aux, SRC_VIRT_PAGE, src_addr ,attrsaux);
  
  uint32_t size = PAGE_SIZE/(sizeof(uint32_t));

  //for (uint32_t i = 0; i < size; i++)
  for (uint32_t i = 0; i < PAGE_SIZE; i++)
  {
    dstp[i] = srcp[i];
      /*     *dstp = *srcp;
          dstp++;
          srcp++;  */
  }
 
  mmu_unmap_page(cr3aux, DST_VIRT_PAGE);
  mmu_unmap_page(cr3aux, SRC_VIRT_PAGE);
 
 }

/**
 * mmu_init_task_dir inicializa las estructuras de paginación vinculadas a una tarea cuyo código se encuentra en la dirección phy_start
 * @pararm phy_start es la dirección donde comienzan las dos páginas de código de la tarea asociada a esta llamada
 * @return el contenido que se ha de cargar en un registro CR3 para la tarea asociada a esta llamada
 */

/**
 #define TASK_CODE_VIRTUAL 0x08000000
#define TASK_CODE_PAGES 2
#define TASK_STACK_BASE 0x08003000
*/

paddr_t mmu_init_task_dir(paddr_t phy_start)
{

  paddr_t pageDir = mmu_next_free_kernel_page();
  paddr_t cr3 = pageDir;
  // zero_page(pageDir);

  for (paddr_t i = 0; i < 1024; i++)
  {
    vaddr_t pageSizeAux = ((vaddr_t)i) << 12;
    mmu_map_page(cr3, pageSizeAux, (PAGE_SIZE * i), 0x003); // Es asi la dir fisica?
  }

  for (uint16_t i = 0; i < TASK_CODE_PAGES; i++)
  {
    mmu_map_page(cr3, TASK_CODE_VIRTUAL + (PAGE_SIZE * i), phy_start + (PAGE_SIZE * i), 0x005); // 0000 0000 0101 = 0x005
  }

  // -> 0x08003000
  mmu_map_page(cr3, TASK_STACK_BASE - PAGE_SIZE, mmu_next_free_user_page(), 0x007); // 0000 0000 0111 = 0x007

  return cr3; // Que valor de CR3 se retornamos¿?
}
