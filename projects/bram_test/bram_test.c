#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

int main()
{
	int fd, i;
	void *cfg, *sts, *reader;
	char *name = "/dev/mem";
	
	if ((fd = open(name, O_RDWR)) < 0)
	{
		perror("open");
		return 1;
	}

	cfg = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);
	sts = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40001000);
	reader = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40002000);

	*((uint32_t *)(cfg + 0)) = 0;
	//*((uint32_t *)(cfg + 4)) = 1024-1;
	*((uint32_t *)(cfg + 4)) = 2048-1;
	*((uint32_t *)(cfg + 0)) = 2;
	*((uint32_t *)(cfg + 0)) = 3;
	sleep(1);
	for (i=0; i<1024; i++){
		printf("bram data = %d\n", *((uint32_t *)(reader+i*4)));
	}
	printf("bram addr = %d\n", *((uint32_t *)(sts+0)));
	
	munmap(cfg, sysconf(_SC_PAGESIZE));
	munmap(sts, sysconf(_SC_PAGESIZE));
	munmap(reader, sysconf(_SC_PAGESIZE));
	close(fd);
	return 0;
}
