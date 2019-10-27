#include <conio.h>
typedef unsigned char byte;
#define ControllersIO (byte*)0x4016
#define Controller2Read (byte*)0x0417
#define PPUWriteAddr(addr) *(byte*)0x2006=(addr>>8);*(byte*)0x2006=addr&0xff;
#define PPUData (byte*)0x2007
void main() {
	unsigned int i;
	cprintf("Hello NES\n");
	i=0x3f00;
	while(i!=0x3f10) {
		PPUWriteAddr(i);
		*PPUData=0x5;
	}
	for(;;);
}
