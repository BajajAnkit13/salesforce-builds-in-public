public class RiskClassifier {
// Method to classify risk level
    public static String classifyRisk(Decimal totalScore) {
// TODO: Convert score to Low/Medium/High
String riskLevel = '';
// TODO: Check if totalScore is between 0-30 
// If yes, return 'Low'
// TODO: Check if totalScore is between 31-70 
// If yes, return 'Medium' 
// TODO: Check if totalScore is between 71-100
// If yes, return 'High'
// TODO: Handle edge case - what if totalScore is null or negative? 
// Decide on default behavior return null;
if(totalScore >=0 && totalScore <= 30) {
riskLevel = 'Low';
}
else if (totalScore >= 31 && totalScore <= 70) {
riskLevel = 'Medium';
}
else if (totalScore >= 71 && totalScore <= 100) {
riskLevel = 'High';
}

return riskLevel;
    }

}