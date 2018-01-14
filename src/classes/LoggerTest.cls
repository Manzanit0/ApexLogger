/**
 * @author Javier G. Manzano
 * @description Test class for Logger.cls
 * @date 13 January 2018
 */
@IsTest
private class LoggerTest {
    @TestSetup
    static void configureApexLogger(){
        ApexLogger__c apxlog = new ApexLogger__c();
        insert apxlog;
    }

    @IsTest
    static void testErrorLogging() {
        Test.startTest();
        Logger logger = new Logger('New Transaction');
        logger.error('Testing error');
        logger.persistLog();
        Test.stopTest();

        Log__c[] logs = [SELECT Id, Name, HasErrors__c, Message__c FROM Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals(true, logs[0].HasErrors__c);
        System.assertEquals(Date.today().format(), logs[0].Name);
        System.assert(logs[0].Message__c.contains(LogType.ERROR.name()));
    }

    @IsTest
    static void testInfoLogging() {
        Test.startTest();
        Logger logger = new Logger('New Transaction');
        logger.info('Testing info');
        logger.persistLog();
        Test.stopTest();

        Log__c[] logs = [SELECT Id, Name, HasErrors__c, Message__c FROM Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals(false, logs[0].HasErrors__c);
        System.assertEquals(Date.today().format(), logs[0].Name);
        System.assert(logs[0].Message__c.contains(LogType.INFO.name()));
    }

    @IsTest
    static void testWarningLogging() {
        Test.startTest();
        Logger logger = new Logger('New Transaction');
        logger.warning('Testing info');
        logger.persistLog();
        Test.stopTest();

        Log__c[] logs = [SELECT Id, Name, HasErrors__c, Message__c FROM Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals(false, logs[0].HasErrors__c);
        System.assertEquals(Date.today().format(), logs[0].Name);
        System.assert(logs[0].Message__c.contains(LogType.WARNING.name()));
    }

    @IsTest
    static void testDebugLogging() {
        Test.startTest();
        Logger logger = new Logger('New Transaction');
        logger.debug('Testing info');
        logger.persistLog();
        Test.stopTest();

        Log__c[] logs = [SELECT Id, Name, HasErrors__c, Message__c FROM Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals(false, logs[0].HasErrors__c);
        System.assertEquals(Date.today().format(), logs[0].Name);
        System.assert(logs[0].Message__c.contains(LogType.DEBUG.name()));
    }

    @IsTest
    static void testLogException(){
        Log__c log1 = new Log__c(Name =Date.today().format());
        Log__c log2 = new Log__c(Name =Date.today().format());
        insert new Log__c[]{ log1, log2 };

        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            Logger logger = new Logger('New Transaction');
        }
        catch (LogException ex){
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown);
    }

    @IsTest
    static void testDisabledLogs(){
        ApexLogger__c apxlog = ApexLogger__c.getOrgDefaults();
        apxlog.Enabled__c = false;
        update apxlog;

        Test.startTest();
        Logger logger = new Logger('New Transaction');
        logger.info('Testing info');
        logger.persistLog();
        Test.stopTest();

        Log__c[] logs = [SELECT Id, Name, HasErrors__c, Message__c FROM Log__c];
        System.assert(logs.isEmpty());
    }
}