#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

int main()
{
	int fd, i;
	void *cfg, *ram;
	char *name = "/dev/mem";
	
	if ((fd = open(name, O_RDWR)) < 0)
	{
		perror("open");
		return 1;
	}

	cfg = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);
	ram = mmap(NULL, 1024*sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x1E000000);

	for (i=0; i<2048; i++) *((uint32_t *)(ram+i*4+0)) = 0;

	*((uint32_t *)(cfg + 0)) = 0;
	*((uint32_t *)(cfg + 0)) = 3;
	*((uint32_t *)(cfg + 4)) = 2048;

	sleep(1);

	for (i=0; i<2048; i++){
		printf("ram data = %d\n", *((uint32_t *)(ram+i*4+0)));
	}

	munmap(cfg, sysconf(_SC_PAGESIZE));
	munmap(ram, 1024*sysconf(_SC_PAGESIZE));
	close(fd);
	return 0;
}
