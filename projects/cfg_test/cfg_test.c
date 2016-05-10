#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

int main()
{
	int fd, i;
	void *cfg;
	char *name = "/dev/mem";
	
	if ((fd = open(name, O_RDWR)) < 0)
	{
		perror("open");
		return 1;
	}

	cfg = mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);

	i=0;
	while(1) {
		*((uint32_t *)(cfg + 16)) = 1 << (i%7);
		sleep(1);
		printf("%d\n", *((uint32_t *)(cfg + 16)));
		i++;
	}
	
	munmap(cfg, sysconf(_SC_PAGESIZE));
	close(fd);
	return 0;
}
