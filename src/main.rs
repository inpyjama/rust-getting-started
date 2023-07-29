#![no_std]
#![no_main]

use core::ptr::read;
use core::ptr::write_volatile;

use core::panic;

#[panic_handler]
fn panic(_panic_info: &panic::PanicInfo) -> ! {
    loop {}
}

#[link_section = ".vector_table.reset_vector"]
#[no_mangle]
pub static __RESET_VECTOR: fn() -> ! = reset_handler;

pub fn reset_handler() -> ! {
    extern "C" {
        static mut _etext: u32;
        static mut _sbss: u32;
        static mut _ebss: u32;
        static mut _srelocate: u32;
        static mut _erelocate: u32;
    }

    // Initialize Data
    unsafe {
        let mut etext: *mut u32 = &mut _etext;
        let mut srelocate: *mut u32 = &mut _srelocate;
        let erelocate: *mut u32 = &mut _erelocate;

        if etext != srelocate {
            while srelocate < erelocate {
                write_volatile(srelocate, read(etext));
                srelocate = srelocate.offset(1);
                etext = etext.offset(1);
            }
        }
    }

    // zeroize bss
    unsafe {
        let mut sbss: *mut u32 = &mut _sbss;
        let ebss: *mut u32 = &mut _ebss;

        while sbss < ebss {
            write_volatile(sbss, 0);
            sbss = sbss.offset(1);
        }
    }

    // Call main
    main()

}

#[no_mangle]
fn main() -> ! {
    let a = 2;
    let b = 4;
    let _c = a + b;
    loop {}
}
