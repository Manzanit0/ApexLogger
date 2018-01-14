# ApexLogger
Minimalist logging service for Salesforce.com Apex.

### Installation
You can install the package through the following link: 
[`https://login.salesforce.com/packaging/installPackage.apexp?p0=04t58000000MypY`]()

### Key features
* Specific object to save the logs to.
* Possibility of specifing the lifespan of logs - A daily batch deletes older log records.
* Enablement/Disablement of the logging through a custom setting.
* Specific permission set to see the logs.
* No-brainer API for the cozy developer :)

### Example

````Java
public class AccountRenamer {
    private Logger logger;

    public AccountRenamer() {
        logger = new Logger('Account Renamer'); // Gets the log record corresponding to today or creates a new one in case it doesn't exist.
    }

    public static void rename(Account acc, String newName){
        logger.info('Renaming started...'); // Adds an information line to the log.
        try {
            /* Some code */
            logger.info('Renaming finished succesfully.');
        }
        catch(Exception e){
            logger.error(e.getMessage()); // Adds a new line with the error as well as setting the HasErrors__c field to true in the log.
        }

        logger.persistLog(); // Must be invoked at the end of the transaction in order to update the log record.
    }
}
````
