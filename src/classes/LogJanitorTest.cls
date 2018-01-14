/**
 * @author Javier G. Manzano
 * @description Test class for LogJanitor.cls
 * @date 14 January 2018
 */
@IsTest
public class LogJanitorTest {
    @TestSetup
    static void seedDatabase(){
        ApexLogger__c apxlog = new ApexLogger__c();
        insert apxlog;

        Log__c log1 = new Log__c(Name='test 1');
        Log__c log2 = new Log__c(Name='test 2');
        insert new Log__c[]{ log1, log2};

        Test.setCreatedDate(log1.Id, DateTime.now().addMonths(-2));
        Test.setCreatedDate(log2.Id, DateTime.now().addYears(-2));
    }

    @IsTest
    static void testDeletionOfRecords1monthOld(){
        ApexLogger__c apxlog = ApexLogger__c.getOrgDefaults();
        apxlog.LogLifespan__c = 30;
        update apxlog;

        Test.startTest();
        Database.executeBatch(new LogJanitor());
        Test.stopTest();

        Log__c[] logs = [SELECT Id, CreatedDate FROM Log__c];
        System.assertEquals(0, logs.size());
    }

    @IsTest
    static void testDeletionOfRecords1yearOld(){
        ApexLogger__c apxlog = ApexLogger__c.getOrgDefaults();
        apxlog.LogLifespan__c = 365;
        update apxlog;

        Test.startTest();
        Database.executeBatch(new LogJanitor());
        Test.stopTest();

        Log__c[] logs = [SELECT Id FROM Log__c];
        System.assertEquals(1, logs.size());
    }
}