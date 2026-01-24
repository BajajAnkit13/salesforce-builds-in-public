@isTest
public class RiskServiceTest {
    @TestSetup
static void setupTestData() {
    // Create all accounts
    List<Account> accounts = new List<Account>();
    
    // Account 1 - High Revenue Tech (0 cases)
    accounts.add(new Account(
        Name = 'High Revenue Tech',
        AnnualRevenue = 15000000,
        Industry = 'Technology'
    ));
    
    // Account 2 - Low Revenue Unknown (12 cases)
    accounts.add(new Account(
        Name = 'Low Revenue Unknown',
        AnnualRevenue = 500000,
        Industry = null
    ));
    
    // Account 3 - Null Revenue Finance (5 cases)
    accounts.add(new Account(
        Name = 'Null Revenue Finance',
        AnnualRevenue = null,
        Industry = 'Finance'
    ));
    
    // Account 4 - Medium Revenue Manufacturing (2 cases)
    accounts.add(new Account(
        Name = 'Medium Revenue Manufacturing',
        AnnualRevenue = 2000000,
        Industry = 'Manufacturing'
    ));
    
    // Accounts 5-9 for bulk testing (varied data)
    accounts.add(new Account(
        Name = 'Bulk Test 1',
        AnnualRevenue = 8000000,
        Industry = 'Healthcare'
    ));
    
    accounts.add(new Account(
        Name = 'Bulk Test 2',
        AnnualRevenue = 1500000,
        Industry = 'Retail'
    ));
    
    accounts.add(new Account(
        Name = 'Bulk Test 3',
        AnnualRevenue = 12000000,
        Industry = 'Technology'
    ));
    
    accounts.add(new Account(
        Name = 'Bulk Test 4',
        AnnualRevenue = 3000000,
        Industry = 'Finance'
    ));
    
    accounts.add(new Account(
        Name = 'Bulk Test 5',
        AnnualRevenue = null,
        Industry = null
    ));
    
    // Insert all accounts in one DML
    insert accounts;
    
    // Create cases
    List<Case> cases = new List<Case>();
    
    // Get Account IDs (we need to query because insert gave them IDs)
    Map<String, Id> accountNameToId = new Map<String, Id>();
    for (Account acc : accounts) {
        accountNameToId.put(acc.Name, acc.Id);
    }
    
    // 12 open cases for 'Low Revenue Unknown'
    for (Integer i = 0; i < 12; i++) {
        cases.add(new Case(
            AccountId = accountNameToId.get('Low Revenue Unknown'),
            Status = 'New',
            Subject = 'Test Case ' + i
        ));
    }
    
    // 5 open cases for 'Null Revenue Finance'
    for (Integer i = 0; i < 5; i++) {
        cases.add(new Case(
            AccountId = accountNameToId.get('Null Revenue Finance'),
            Status = 'Working',
            Subject = 'Test Case ' + i
        ));
    }
    
    // 2 open cases for 'Medium Revenue Manufacturing'
    for (Integer i = 0; i < 2; i++) {
        cases.add(new Case(
            AccountId = accountNameToId.get('Medium Revenue Manufacturing'),
            Status = 'Escalated',
            Subject = 'Test Case ' + i
        ));
    }
    
    // Add some CLOSED cases to verify they're NOT counted
    // These should NOT affect risk scores
    cases.add(new Case(
        AccountId = accountNameToId.get('High Revenue Tech'),
        Status = 'Closed',
        Subject = 'Closed Case 1'
    ));
    
    cases.add(new Case(
        AccountId = accountNameToId.get('Low Revenue Unknown'),
        Status = 'Closed',
        Subject = 'Closed Case 2'
    ));
    
    // Insert all cases in one DML
    insert cases;
}
@isTest
static void testHighRevenueNoCase_LowRisk() {
    // ARRANGE - Get the account we created in @TestSetup
    Account acc = [SELECT Id FROM Account WHERE Name = 'High Revenue Tech' LIMIT 1];
    List<Id> accountIds = new List<Id>{acc.Id};
    
    // ACT - Call the service
    Test.startTest();
    List<RiskResult> results = RiskService.calculateRiskForAccounts(accountIds);
    Test.stopTest();
    
    // ASSERT - Check returned results
    System.assertEquals(1, results.size(), 'Should return 1 result');
    System.assertEquals(0, results[0].riskScore, 'Risk score should be 0');
    System.assertEquals('Low', results[0].riskLevel, 'Risk level should be Low');
    System.assertEquals(acc.Id, results[0].accountId, 'Account ID should match');
    
    // ASSERT - Verify database was updated
    Account updatedAcc = [SELECT Risk_Score__c, Risk_Level__c FROM Account WHERE Id = :acc.Id];
    System.assertEquals(0, updatedAcc.Risk_Score__c, 'Database Risk Score should be 0');
    System.assertEquals('Low', updatedAcc.Risk_Level__c, 'Database Risk Level should be Low');
}
@isTest
static void testLowRevenueManyCase_HighRisk() {
    // ARRANGE
    Account acc = [SELECT Id FROM Account WHERE Name = 'Low Revenue Unknown' LIMIT 1];
    List<Id> accountIds = new List<Id>{acc.Id};
    
    // ACT
    Test.startTest();
    List<RiskResult> results = RiskService.calculateRiskForAccounts(accountIds);
    Test.stopTest();
    
    // ASSERT - Check returned results
    System.assertEquals(1, results.size(), 'Should return 1 result');
    System.assertEquals(100, results[0].riskScore, 'Risk score should be 100');
    System.assertEquals('High', results[0].riskLevel, 'Risk level should be High');
    
    // ASSERT - Verify database
    Account updatedAcc = [SELECT Risk_Score__c, Risk_Level__c FROM Account WHERE Id = :acc.Id];
    System.assertEquals(100, updatedAcc.Risk_Score__c, 'Database Risk Score should be 100');
    System.assertEquals('High', updatedAcc.Risk_Level__c, 'Database Risk Level should be High');
}
@isTest
static void testNullRevenue_MediumRisk() {
    // ARRANGE
    Account acc = [SELECT Id FROM Account WHERE Name = 'Null Revenue Finance' LIMIT 1];
    List<Id> accountIds = new List<Id>{acc.Id};
    
    // ACT
    Test.startTest();
    List<RiskResult> results = RiskService.calculateRiskForAccounts(accountIds);
    Test.stopTest();
    
    // ASSERT - Check returned results
    System.assertEquals(1, results.size(), 'Should return 1 result');
    System.assertEquals(60, results[0].riskScore, 'Risk score should be 60');
    System.assertEquals('Medium', results[0].riskLevel, 'Risk level should be Medium');
    
    // ASSERT - Verify database
    Account updatedAcc = [SELECT Risk_Score__c, Risk_Level__c FROM Account WHERE Id = :acc.Id];
    System.assertEquals(60, updatedAcc.Risk_Score__c, 'Database Risk Score should be 60');
    System.assertEquals('Medium', updatedAcc.Risk_Level__c, 'Database Risk Level should be Medium');
}
@isTest
static void testUnknownIndustry_HigherRisk() {
    // ARRANGE
    Account acc = [SELECT Id FROM Account WHERE Name = 'Medium Revenue Manufacturing' LIMIT 1];
    List<Id> accountIds = new List<Id>{acc.Id};
    
    // ACT
    Test.startTest();
    List<RiskResult> results = RiskService.calculateRiskForAccounts(accountIds);
    Test.stopTest();
    
    // ASSERT - Check returned results
    System.assertEquals(1, results.size(), 'Should return 1 result');
    System.assertEquals(50, results[0].riskScore, 'Risk score should be 50');
    System.assertEquals('Medium', results[0].riskLevel, 'Risk level should be Medium');
    
    // ASSERT - Verify database
    Account updatedAcc = [SELECT Risk_Score__c, Risk_Level__c FROM Account WHERE Id = :acc.Id];
    System.assertEquals(50, updatedAcc.Risk_Score__c, 'Database Risk Score should be 50');
    System.assertEquals('Medium', updatedAcc.Risk_Level__c, 'Database Risk Level should be Medium');
}
@isTest
static void testBulkProcessing() {
    // ARRANGE - Get ALL accounts
    List<Account> allAccounts = [SELECT Id, Name FROM Account];
    List<Id> accountIds = new List<Id>();
    for (Account acc : allAccounts) {
        accountIds.add(acc.Id);
    }
    
    // ACT - Call service with all accounts at once
    Test.startTest();
    List<RiskResult> results = RiskService.calculateRiskForAccounts(accountIds);
    Test.stopTest();
    
    // ASSERT - Verify all accounts were processed
    System.assertEquals(9, results.size(), 'Should process all 9 accounts');
    
    // ASSERT - Verify all accounts in database have scores
    List<Account> updatedAccounts = [
        SELECT Id, Name, Risk_Score__c, Risk_Level__c 
        FROM Account 
        WHERE Id IN :accountIds
    ];
    
    for (Account acc : updatedAccounts) {
        System.assertNotEquals(null, acc.Risk_Score__c, 
            'Account ' + acc.Name + ' should have Risk Score');
        System.assertNotEquals(null, acc.Risk_Level__c, 
            'Account ' + acc.Name + ' should have Risk Level');
    }
    
    // ASSERT - Spot check specific accounts
    // Find 'High Revenue Tech' in results
    RiskResult highRevResult = null;
    RiskResult lowRevResult = null;
    
    for (RiskResult result : results) {
        for (Account acc : allAccounts) {
            if (acc.Id == result.accountId) {
                if (acc.Name == 'High Revenue Tech') {
                    highRevResult = result;
                }
                if (acc.Name == 'Low Revenue Unknown') {
                    lowRevResult = result;
                }
            }
        }
    }
    
    System.assertNotEquals(null, highRevResult, 'Should find High Revenue Tech in results');
    System.assertEquals(0, highRevResult.riskScore, 'High Revenue Tech should have score 0');
    System.assertEquals('Low', highRevResult.riskLevel, 'High Revenue Tech should be Low risk');
    
    System.assertNotEquals(null, lowRevResult, 'Should find Low Revenue Unknown in results');
    System.assertEquals(100, lowRevResult.riskScore, 'Low Revenue Unknown should have score 100');
    System.assertEquals('High', lowRevResult.riskLevel, 'Low Revenue Unknown should be High risk');
}
}