#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <parse.h>
#include <pthread.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <errno.h>
#define PARSE_TIME_INTERVAL 5

double glucAdd[25] = {3,6,9,12,16,18,21,24,27,30,33,36,40,40,40,40,40,40,40,40,40,40,40,40,40};
double glucBase = 80;
double glucagonBase = 25;
double bloodInsulinBase = 10;
double glucose;
double glucagon;
double bloodInsulin;
int foodRequestFlag;
int foodRequestEnableFlag;
int foodRequestAcceptFlag;
int digestTime;
struct timeEmulate {
    int hour;
    int min;
};
struct timeEmulate time;//
void initial(void){
	glucose = glucoseBase;
	glucagon = glucagonBase;
	bloodInsulin = bloodInsulinBase;
	foodRequestAcceptFlag = 0;
	foodRequestFlag = 0;
	foodRequestEnableFlag = 0;
	foodRequestAcceptFlag = 0;
}

void updateOnParse(const char *column, int value)
{
	ParseClient client = parseInitialize("cpeO9iWiYi6v5PDXfes8FgCyzNrqraRj06Op4k3s", "syPYZyZDh0VZSyY66eOQhXdmGNCCwN3w6bBnlrXi");
	char data[100] = "{ \"";
	char strValue[4];
	sprintf(strValue, "%d", value);
	strcat(data, column);
	strcat(data, "\": ");
	strcat(data, strValue);
	strcat(data, " }");	
	parseSendRequest(client, "PUT", "/1/classes/patient/ofeFERPC8s", data, NULL);
	printf("Pushed data  %s\n", data);
}


void statesCallback(ParseClient client, int error, const char *buffer) {
	int i, j, tmpRequestFlag, tmpAcceptFlag;
	if (error == 0 && buffer != NULL) {
		printf("received push: '%s'\n", buffer);
		char *tmpBuffer;
		tmpBuffer = (char*) buffer;//change tmp from buffer
		for(i = 0, j = 0; *(tmpBuffer + i) != '\0'; i++){
			if(*(tmpBuffer + i) == '"'){
				j++;
				if(j == 4){
					tmpRequestFlag = *(tmpBuffer + i + 2) - 48;
				}
				if(j == 14){
					tmpAcceptFlag = *(tmpBuffer + i + 2) - 48;
				}
			
			}
		}
		if(foodRequestEnableFlag == 1 && tmpRequestFlag == 1){
			foodRequestFlag = 1;
			foodRequestEnableFlag = 0;
		}
		if(foodRequestFlag == 1){
			foodRequestAcceptFlag = tmpAcceptFlag;//foodRequestAcceptFlag = the corresponding value in buffer
		}
	}
}


void *updateByParse(void){
	ParseClient client = parseInitialize("cpeO9iWiYi6v5PDXfes8FgCyzNrqraRj06Op4k3s", "syPYZyZDh0VZSyY66eOQhXdmGNCCwN3w6bBnlrXi");
	while(1){
		parseSendRequest(client, "GET", "/1/classes/patient/ofeFERPC8s", NULL, statesCallback);
		sleep(1);
	}
}

void requestCallback(ParseClient client, int error, const char *buffer)
{
	int tmp;
	if (error == 0 && buffer != NULL) {
		tmp = (char)*(buffer + 19) - 48;
		if(foodRequestEnableFlag == 1 && tmp == 1){
			foodRequestFlag = 1;
			foodRequestEnableFlag = 0;
		}
		//printf("push: %d\n", bulb.health);
		//updateOnParse("Health", bulb.health);
	}
}

void *threadPushNotifications()
{
    pthread_detach(pthread_self());
    ParseClient client = parseInitialize("cpeO9iWiYi6v5PDXfes8FgCyzNrqraRj06Op4k3s", "syPYZyZDh0VZSyY66eOQhXdmGNCCwN3w6bBnlrXi");
    char *installationId = parseGetInstallationId(client);
    
    /* We need to set the InstallationId forcefully. Setting installationId to dataUUID based on null string is incorrect
     logic as there is a possibility that the installationId was previously set to some junk value.
     Typically this will break the push notification subscription */
    parseSetInstallationId(client, dataUUID);
    printf("lightbulb::threadPushNotifications():New Installation ID set to : %s\n", installationId);
    printf("lightbulb::threadPushNotifications():Installation ID is : %s\n", installationId);
    parseSetPushCallback(client, requestCallback);
    parseStartPushService(client);
    parseRunPushLoop(client);
}

void *updateTime(void *time)
{
    struct timeEmulate *timer = (struct timeEmulate *)time;
    int ticker = 0;
    while (1)
    {
        char strTime[10];
        if (timer->min == 55)
            timer->hour = (timer->hour + 1)%24;
        timer->min = (timer->min + 5)%60;
        printf("updateBulbTime():: Time: %d:%d\n", timer->hour, timer->min);
        sprintf(strTime, "%d:%d", timer->hour, timer->min);
        //clientSendSocket(PORT_TIME, strTime);
        
        // Push the time to Parse cloud at periodic intervals (5 seconds default)
        if (++ticker > PARSE_TIME_INTERVAL)
        {
            updateOnParse("Hour", timer->hour);
            updateOnParse("Minute", timer->min);
            ticker = 0;
            
        }
        sleep(1);
    }
}


void BloodChange(void){//(int foodRequestFlag, int foodRequestAcceptFlag){
	int priorGlucose;
	int foodRequestCounter;
	if(foodRequestFlag == 0){
		glucose = glucoseBase;
		glucagon = glucagonBase;
		bloodInsulin = bloodInsulinBase;
	}
	else{
		foodRequestCounter = 0;
		if(foodRequestAcceptFlag == 0){
			glucose = glucose--;
			glucagon = constant1 / glucose;
			foodRequestCounter ++;
		}
		if(glucose < 75){
			printf("hungry\n");//sending notification to the doctor's APP
		}
		if(foodRequestAcceptFlag == 1 && glucose > 70){
			//digestTime
			for(digestTime = 0; digestTime < 25; digestTime = digestTime + 5){
				priorGlucose = glucose;
				if(digestTime < 14){
					glucose = glucAdd[digestTime] + glucBase;
				}
				else{
					glucose = glucose - (constant2 * totalInsulin);
				}
				if(glucose < 70){
					break;
				}
				glucagon = constant1 / glucose;
				bloodInsulin = bloodInsulin + ((glucose - priorGlucose) *invSeverity);
				sleep(1);
			}
			foodRequestFlag = 0;
			foodRequestAcceptFlag = 0;
			updateOnParse("FoodRequestFlag", foodRequestFlag);
			updateOnParse("RequestAcceptFlag", foodRequestFlag);//update on parse
		}
		if(glucose < 70){
			printf("initial");//send another warning msg
			initial();
		}
	}
}

void *updateBase(void){
	int piorMin == 0;
	while(1){
		if((time.hour == 7 && time.min == 0) || (time.hour == 12 && time.min == 0) || (time.hour == 18 && time.min == 0)){//timing condition
			//send notification
			if(piorMin == 55){//at the beginning of the food time
				foodRequestEnableFlag = 1;
			}
			BloodChange();
		}
		piorMin = time.min;
	}
}

int main(void){
	time.hour = 0;
	time.min = 0;
	initial();
	pthread_t threadPush, threadTime, threadSensor, threadUpdateBase, threadInsulin, threadUpdateByParse;
    pthread_mutex_init(&lock, NULL);
	pthread_mutex_lock(&lock);
    pthread_mutex_unlock(&lock);
	pthread_create(&threadPush, NULL, threadPushNotifications, NULL);
    pthread_create(&threadTime, NULL, updateTime, &time);
	pthread_create(&threadUpdateBase, NULL, updateBase, NULL);
	pthread_create(&threadUpdateByParse, NULL, updateByParse, NULL);
	
}









