#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

typedef struct {
	int16_t cos;
	int16_t sin;
} dds_t;

int main()
{
	int fd, i;
	void *cfg, *ram;
	char *name = "/dev/mem";
	dds_t *dds;
	
	if ((fd = open(name, O_RDWR)) < 0)
	{
		perror("open");
		return 1;
	}

	cfg = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);
	ram = mmap(NULL, 1024*sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x1E000000);

	for (i=0; i<1024; i++) *((uint32_t *)(ram+i*4+0)) = 0;

	*((uint32_t *)(cfg + 0)) = 0;
	*((uint32_t *)(cfg + 0)) = 3;
	*((uint32_t *)(cfg + 4)) = 1024;

	sleep(1);
	for (i=0; i<1024; i++){
		dds = (dds_t *)(ram+i*4+0);
		printf("cos = %d, sin =%d, cos^2 + sin^2 = %d\n", dds->cos, dds->sin, dds->cos*dds->cos+dds->sin*dds->sin);
	}

	munmap(cfg, sysconf(_SC_PAGESIZE));
	munmap(ram, 1024*sysconf(_SC_PAGESIZE));
	close(fd);
	return 0;
}
