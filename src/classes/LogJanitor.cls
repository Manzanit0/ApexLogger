/**
 * @author Javier G. Manzano
 * @description Batch which deletes all logs older than the specified logLifespan in the custom settings.
 * @date 13 January 2018
 */
global class LogJanitor implements Database.Batchable<sObject>{
    private String query = 'SELECT Id FROM Log__c WHERE CreatedDate < :deleteBeforeDate';

    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer lifespan = Integer.valueOf(ApexLogger__c.getOrgDefaults().LogLifespan__c);
        Datetime deleteBeforeDate = DateTime.now().addDays(-lifespan);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){
    }
}