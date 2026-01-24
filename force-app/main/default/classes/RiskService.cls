public class RiskService {
        // Main orchestration method
public static List<RiskResult> calculateRiskForAccounts(List<Id> accountIds) {
    // TODO: Step 1 - Fetch Account data
    // Call RiskDataFetcher.fetchAccountData(accountIds)
    // Store result in: List<Account> accounts
List<Account> accounts = RiskDataFetcher.fetchAccountData(accountIds);
    
    // TODO: Step 2 - Fetch open case counts
    // Call RiskDataFetcher.fetchOpenCaseCount(accountIds)
    // Store result in: Map<Id, Integer> caseCountsByAccountId
    Map<Id, Integer> caseCountsByAccountId = RiskDataFetcher.fetchOpenCaseCount(accountIds);

    // TODO: Step 3 - Initialize result storage
    // Create: List<RiskResult> results = new List<RiskResult>()
    // Create: List<Account> accountsToUpdate = new List<Account>()
List<RiskResult> results = new List<RiskResult> ();
List<Account> accountsToUpdate = new List<Account>();
    
    // TODO: Step 4 - Process each Account
    // Loop through accounts list
    
        // TODO: Step 4a - Extract data for this account
        // Get: revenue from account.AnnualRevenue
        // Get: industry from account.Industry
        // Get: openCaseCount from caseCountsByAccountId.get(account.Id)
        // Handle case where account has no entry in map (default to 0)

for(Account account : accounts) {
Decimal revenue = account.AnnualRevenue;
String industry  = account.Industry;
 Integer caseCount = caseCountsByAccountId.get(account.Id);      
        // TODO: Step 4b - Calculate risk score
        // Call: RiskCalculator.calculateTotalScore(revenue, openCaseCount, industry)
        // Store result in: Decimal totalScore
Decimal totalScore = RiskCalculator.calculateTotalScore(revenue, caseCount, industry);        
        // TODO: Step 4c - Classify risk level
        // Call: RiskClassifier. classifyRisk(totalScore)
        // Store result in: String riskLevel
String riskLevel = RiskClassifier.classifyRisk(totalScore);
        
        // TODO: Step 4d - Create result object
        // Create new RiskResult with accountId, totalScore, riskLevel
        // Add to results list
RiskResult result = new RiskResult (account.Id, totalScore, riskLevel);
results.add(result);
        
        // TODO: Step 4e - Prepare account for update
        // Set account.Risk_Score__c = totalScore
        // Set account.Risk_Level__c = riskLevel
        // Add account to accountsToUpdate list
    account.Risk_Score__c = totalScore;
account.Risk_Level__c = riskLevel;
accountsToUpdate.add(account);
}
    // TODO: Step 5 - Perform bulk DML
    // Check if accountsToUpdate is not empty
    // UPDATE accountsToUpdate
if(!accountsToUpdate.isEmpty()) {
Update accountsToUpdate;
}
    
    // TODO: Step 6 - Return results
    // Return results list for testing/verification
    
    return results; // Placeholder
}

}