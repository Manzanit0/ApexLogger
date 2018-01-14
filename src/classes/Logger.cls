/**
 * @author Javier G. Manzano
 * @description Core class to create and persist logs.
 * @date 13 January 2018
 *
 * //TODO: take into account the maximum size of the logs - if the user starts logging many things,
 * //it might be convenient to create multiple log records. Or maybe devide logs by severity.
 */
global class Logger {
    private Log__c log;

    global Logger(String transactionName){
        log = getTodayLog();
        log.Message__c = '\n\n TRANSACTION ' + transactionName;
    }

    global void persistLog(){
        if(logsAreEnabled()){
            upsert log;
        }
    }

    global void debug(String message){
        log(message, LogType.DEBUG);
    }

    global void info(String message){
        log(message, LogType.INFO);
    }

    global void warning(String message){
        log(message, LogType.WARNING);
    }

    global void error(String message){
        log(message, LogType.ERROR);
    }

    private void log(String message, LogType type){
        this.log.Message__c += '\n' + getTime() + ' ' + type.name() + ' - ' + message;
        this.log.HasErrors__c = type == logType.ERROR ? true : false;
    }

    private String getTime(){
        return Datetime.now().format('H:mm');
    }

    private Log__c getTodayLog(){
        String logName = Date.today().format();
        Log__c[] logs = [SELECT Id, Name, Message__c, HasErrors__c FROM Log__c WHERE Name = :logName];

        if(logs.size() > 1){
            throw new LogException('There are two logs with the identifier' + logName);
        }

        return logs.isEmpty() ? new Log__c(Name = logName) : logs[0];
    }

    private Boolean logsAreEnabled(){
        return ApexLogger__c.getOrgDefaults().Enabled__c;
    }
}