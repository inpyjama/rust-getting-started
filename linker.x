MEMORY
{
  rom : ORIGIN  = 0x00000000, LENGTH = 512K
  ram : ORIGIN  = 0x20000000, LENGTH = 64K
}

EXTERN(__RESET_VECTOR);
EXTERN(reset_handler);
ENTRY(reset_handler);
PROVIDE(_ram_end = ORIGIN(ram) + LENGTH(ram));
STACK_SIZE = DEFINED(__stack_size__) ? __stack_size__ : 0x1000;
/* ? */

/* # Sections */
SECTIONS
{
  .vector_table :
  {
    /* Initial Stack Pointer (SP) value */
    LONG(_ram_end & 0xFFFFFFF8);

    /* Reset vector */
    KEEP(*(.vector_table.reset_vector)); 
  } > rom

  .text :
  {
    _stext = .;
    *(.text .text.*);
    *(.rodata .rodata.*);
    . = ALIGN(4);
    _etext = .;
  } > rom

  .data :
  {
    . = ALIGN(4);
    _srelocate = .;
    *(.data .data.*);
    . = ALIGN(4); 
    _erelocate = .;
  } > ram AT > rom

  .bss (NOLOAD) :
  {
      . = ALIGN(4);
      _sbss = . ;
      *(.bss .bss.*)
      . = ALIGN(4);
      _ebss = . ;
  } > ram

  /* stack section */
  .stack (NOLOAD) :
  {
      . = ALIGN(8);
      _sstack = .;
      . = . + STACK_SIZE;
      . = ALIGN(8);
      _estack = .;
  } > ram

  . = ALIGN(4);
  _end = . ;
}