#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<syslog.h>

int main(int argc,char *argv[]){

	openlog("writer", LOG_PID | LOG_CONS, LOG_USER);

	if(argc != 3){
		syslog(LOG_ERR, "usage: %s <file> <string>", argv[0]);
		fprintf(stderr, "usage: %s <file> <string>\n", argv[0]);
		closelog();
		return 1;
	}


	char *file_path = argv[1];
	char *write_str = argv[2];

	FILE *fp = fopen(file_path, "w");
	if(fp == NULL){
		syslog(LOG_ERR,"Failed to open file at location %s for writing",file_path);
		perror("fopen");
		closelog();
		return 1;
	}

	size_t len = strlen(write_str);
	size_t written = fwrite(write_str, sizeof(char), len, fp);

	if(written < len){
		syslog(LOG_ERR, "Failed to write string to %s", file_path);
		fprintf(stderr, "Failed to write full string\n");
		fclose(fp);
		closelog();
		return 1;
	}

	syslog(LOG_DEBUG, "Writing %s to %s",write_str,file_path);

	fclose(fp);
	closelog();
	return 0;

}
