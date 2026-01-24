public class RiskResult {
    // The Account Id this result belongs to
    public Id accountId;
    
    // The calculated risk score (0-100)
    public Decimal riskScore;
    
    // The risk classification: 'Low', 'Medium', or 'High'
    public String riskLevel;
    
    public RiskResult(Id accountId, Decimal riskScore, String riskLevel) { 
    This.accountId = accountId;
    This.riskScore = riskScore;
    This.riskLevel = riskLevel;
 }

}