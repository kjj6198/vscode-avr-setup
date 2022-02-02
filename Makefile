CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump

MCU   = atmega32u4
F_CPU = 16000000UL  
BAUD  = 9600UL
TARGET = $(basename $@)

PROGRAMMER_TYPE=avr109
PROGRAMMER_ARGS=-P /dev/tty.usbmodem13101
SOURCES = $(wildcard gpio/*.c ./includes/*.c)
OBJECTS = $(SOURCES:.c=.o)
HEADERS = $(SOURCES:.c=.h)

TARGET_ARCH = -mmcu=$(MCU)
CPPFLAGS = $(TARGET_ARCH) -DF_CPU=$(F_CPU) -DBAUD=$(BAUD) -I. -I$(LIBDIR)
CFLAGS = -Os -g -std=gnu99 -Wall
CFLAGS += -ffunction-sections -fdata-sections 
LDFLAGS = -Wl,-Map,$(TARGET)/$(TARGET).map 
LDFLAGS += -Wl,--gc-sections 

%.o: %.c $(HEADERS) Makefile	
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<;

%.elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $(TARGET)/$@;

%.hex: %.elf
	 $(OBJCOPY) -j .text -j .data -O ihex $(TARGET)/$< $(TARGET)/$@;

%.eeprom: %.elf
	$(OBJCOPY) -j .eeprom --change-section-lma .eeprom=0 -O ihex $< $@ 

%.lst: %.elf
	$(OBJDUMP) -S $(TARGET)/$< > $(TARGET)/$@

disasm: $(filename).lst

clean:
	rm **/*.map **/*.elf **/*.hex

size: $(filename)
	avr-size -C --mcu=$(MCU) $(filename)

flash: $(filename)
	avrdude -c $(PROGRAMMER_TYPE) -p $(MCU) $(PROGRAMMER_ARGS) -U flash:w:$(filename)