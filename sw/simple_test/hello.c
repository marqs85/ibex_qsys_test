#include <stdio.h>
#include <string.h>

volatile int *gpio_addr = (int*)0x100000;
volatile int *jtag_uart_data = (int*)0x100010;
volatile int *jtag_uart_ctrl = (int*)0x100014;

const char msg[] = "Hello World!\n";

int main(int argc, char **argv)
{
    int i;
    volatile int j=0;

    for (i=0; i<strlen(msg); i++) {
        while ((*jtag_uart_ctrl >> 16) == 0) ;

        *jtag_uart_data = msg[i];
    }

    *gpio_addr = 0xf0;

    // Toggle LEDs every 1sec when running from SRAM/cache
    while (1) {
        j = ((j+1) % 1000000);
        if (j == 0)
            *gpio_addr ^= 0xff;
    };

    return 0;
}
