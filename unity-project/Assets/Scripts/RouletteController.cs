using UnityEngine;
using System.Collections.Generic;

public class RouletteController : MonoBehaviour {
    public List<int> lastNumbers = new List<int>();
    public bool isLastRed;
    public Rigidbody ballRigidbody;
    public Transform wheelTransform;
    
    private Dictionary<int, int> numberFrequency = new Dictionary<int, int>();
    
    public void ResetStats() {
        lastNumbers.Clear();
        numberFrequency.Clear();
    }
    
    public void RecordResult(int number) {
        lastNumbers.Add(number);
        if (lastNumbers.Count > 50) lastNumbers.RemoveAt(0);
        
        isLastRed = IsRedNumber(number);
        
        if (!numberFrequency.ContainsKey(number)) {
            numberFrequency[number] = 0;
        }
        numberFrequency[number]++;
    }
    
    public bool IsHotNumber(int number) {
        if (!numberFrequency.ContainsKey(number)) return false;
        return numberFrequency[number] >= 3;
    }
    
    public bool IsRedNumber(int num) {
        int[] reds = {1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36};
        return System.Array.IndexOf(reds, num) >= 0;
    }
    
    public void DisplayAISuggestion(int suggestion) {
        string[] labels = {"Rojo", "Negro", "Par", "Impar", "Hot Number"};
        Debug.Log($"🤖 IA Sugiere: {labels[suggestion]}");
    }
    
    public bool lastResultMatches(int suggestion) {
        int lastNum = lastNumbers[lastNumbers.Count - 1];
        switch(suggestion) {
            case 0: return IsRedNumber(lastNum);
            case 1: return !IsRedNumber(lastNum) && lastNum != 0;
            case 2: return lastNum % 2 == 0 && lastNum != 0;
            case 3: return lastNum % 2 != 0;
            default: return IsHotNumber(lastNum);
        }
    }
}
