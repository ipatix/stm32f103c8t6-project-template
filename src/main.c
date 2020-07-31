#include <libopencm3/stm32/rcc.h>
#include <libopencm3/stm32/gpio.h>

int main(void) {
    /*
     * This is just a demo program so you can test if your setup works.
     * You may remove this and replace it with your actual program
     */
    rcc_periph_clock_enable(RCC_GPIOC);
    gpio_set_mode(GPIOC, GPIO_MODE_OUTPUT_2_MHZ, GPIO_CNF_OUTPUT_PUSHPULL, GPIO13);

    while(1) {
        gpio_set(GPIOC, GPIO13);
        for (volatile int i = 0; i < 100000; i++) { }
        gpio_clear(GPIOC, GPIO13);
        for (volatile int i = 0; i < 100000; i++) { }
    }
}
