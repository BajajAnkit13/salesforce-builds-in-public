    public class RiskDataFetcher {
    public static List<Account> fetchAccountData(List<Id> accountIds) {
    // TODO: Query Account records
    // SELECT Id, AnnualRevenue, Industry
    // FROM Account
    // WHERE Id IN :accountIds
    List<Account> accountData = [SELECT Id, AnnualRevenue, Industry FROM Account WHERE Id IN :accountIds];
    // TODO: Return the queried list of Accounts
    // Note: This will be used by RiskService to process each account
    return accountData; // Placeholder
    }    
    // Method to fetch open case counts
    public static Map<Id, Integer> fetchOpenCaseCount(List<Id> accountIds) {
    // TODO: Query to count open Cases per Account
    // Use AggregateResult with:
    // SELECT AccountId, COUNT(Id) caseCount
    // FROM Case
    // WHERE AccountId IN :accountIds
    // AND Status != 'Closed'
    // GROUP BY AccountId
    AggregateResult[] groupedResult =  [SELECT AccountId, COUNT(Id) caseCount FROM Case 
    WHERE AccountId IN:accountIds AND Status != 'Closed' GROUP BY AccountId];
    Map<Id, Integer> openCasesMap = new Map<Id, Integer> ();
    for (Id accId : accountIds) {
    openCasesMap.put(accId ,0);
    }

    // TODO: Loop through AggregateResult
    // Extract AccountId and count (caseCount)
    // Store in Map<Id, Integer>
    // Key = AccountId, Value = count of open cases
    for( AggregateResult ar : groupedResult) {
    Id accId = (Id) ar.get('AccountId');
    Integer caseCount = (Integer) ar.get('caseCount');
    openCasesMap.put(accId, caseCount);
    }
    // TODO: Handle accounts with zero cases
    // Initialize all accountIds in the map with count = 0
    // This ensures every input account has an entry (never null)
    // Business logic: 0 open cases = 0 risk points (valid scenario)   
    //  return null; // Placeholder
    return openCasesMap;
    }

    }