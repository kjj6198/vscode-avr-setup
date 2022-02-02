#ifndef F_CPU
#define F_CPU 16000000UL // 16 MHz clock speed
#endif

#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
	DDRB = 0xFF;
	while (1)
	{
		PORTB = 0xFF;
		_delay_ms(1000); // Wait 1 second
		PORTB = 0x00;
		_delay_ms(1000); // Wait 1 second
	}
}
