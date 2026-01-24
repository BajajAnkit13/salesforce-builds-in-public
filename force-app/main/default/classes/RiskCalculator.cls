    public class RiskCalculator {
        // Method to calculate total risk score
        public static Decimal calculateTotalScore(Decimal revenue, Integer openCaseCount, String industry) {
    Decimal totalRisk = 0;
    Decimal revenueRisk = 0;
    Decimal caseRisk = 0;
    Decimal industryRisk = 0;
        // TODO: Calculate Revenue Risk (0-40 points)
        // If revenue > 10,000,000 → 0 points
        // If revenue between 5,000,000 - 10,000,000 → 10 points
        // If revenue between 1,000,000 - 5,000,000 → 20 points
        // If revenue < 1,000,000 → 40 points
        // If revenue is null → 30 points
    if(revenue == null) {
    revenueRisk = 30;
    }
    else if(revenue > 10000000) {
    revenueRisk = 0;
    }
    else if(revenue >= 5000000 && revenue <= 10000000) {
    revenueRisk = 10;
    }
    else if (revenue >= 1000000 && revenue < 5000000) {
    revenueRisk = 20;
    }  
    else  { // revenue < 1000000
    revenueRisk = 40;
    }
        // TODO: Calculate Open Case Risk (0-40 points)
        // If openCaseCount = 0 → 0 points
        // If openCaseCount between 1-3 → 10 points
        // If openCaseCount between 4-7 → 20 points
        // If openCaseCount between 8-10 → 30 points
        // If openCaseCount > 10 → 40 points
    if(openCaseCount == 0) {
    caseRisk = 0;
    }
    else if (openCaseCount >= 1 && openCaseCount <= 3) {
    caseRisk = 10;
    }
    else if (openCaseCount >= 4 && openCaseCount <= 7) {
    caseRisk = 20;
    }
    else if (openCaseCount >= 8 && openCaseCount <= 10) {
    caseRisk = 30;
    }   
    else if (openCaseCount > 10) {
    caseRisk = 40;
    }
        // TODO: Calculate Industry Risk (0-20 points)
        // If industry = 'Technology' → 0 points
        // If industry = 'Healthcare' → 5 points
        // If industry = 'Finance' → 10 points
        // If industry = 'Retail' → 15 points
        // If industry is null or other value → 20 points
    if (industry == null) {
    industryRisk = 20;}  
    else if(industry == 'Technology') {
    industryRisk = 0;
    }
    else if (industry == 'Healthcare') {
    industryRisk =5;
    }
    else if (industry == 'Finance') {
    industryRisk = 10;
    }
    else if (industry == 'Retail') {
    industryRisk = 15;
    }
    else { industryRisk = 20;}  
        // TODO: Sum all three risk components
        // totalRisk = revenueRisk + caseRisk + industryRisk
    totalRisk = revenueRisk + caseRisk + industryRisk;
        
        // TODO: Return total risk score (should be 0-100)
        
        return totalRisk; // Placeholder
    }

    }