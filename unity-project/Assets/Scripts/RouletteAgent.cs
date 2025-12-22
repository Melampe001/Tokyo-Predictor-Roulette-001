using Unity.MLAgents;
using Unity.MLAgents.Sensors;
using Unity.MLAgents.Actuators;
using UnityEngine;

public class RouletteAgent : Agent {
    public RouletteController table;
    
    public override void OnEpisodeBegin() {
        table.ResetStats();
    }
    
    public override void CollectObservations(VectorSensor sensor) {
        // Observar últimos 10 números normalizados
        foreach (int num in table.lastNumbers) {
            sensor.AddObservation(num / 36f);
        }
        sensor.AddObservation(table.isLastRed ? 1f : 0f);
        
        // Observaciones de física
        ObservePhysics(table.ballRigidbody, table.wheelTransform);
    }
    
    public override void OnActionReceived(ActionBuffers actions) {
        int suggestion = actions.DiscreteActions[0];
        table.DisplayAISuggestion(suggestion);
        
        if(table.lastResultMatches(suggestion)) {
            AddReward(0.1f);
        }
    }
    
    public void EvaluateSpin(int winningNumber) {
        if (table.IsHotNumber(winningNumber)) {
            AddReward(1.0f);
        } else {
            AddReward(-0.05f);
        }
        EndEpisode();
    }
    
    public override void Heuristic(in ActionBuffers actionsOut) {
        var discreteActions = actionsOut.DiscreteActions;
        if (Input.GetKey(KeyCode.R)) discreteActions[0] = 0;
        if (Input.GetKey(KeyCode.N)) discreteActions[0] = 1;
    }
    
    public void ObservePhysics(Rigidbody ballRB, Transform wheelRot) {
        var sensor = GetComponent<VectorSensor>();
        sensor.AddObservation(wheelRot.GetComponent<ConstantRotation>().speed / 100f);
        sensor.AddObservation(ballRB.velocity.magnitude / 50f);
    }
    
    public void CheckDailyChallenge(int winStreak) {
        if (winStreak >= 3) {
            AddReward(2.0f);
            Debug.Log("✅ IA Challenge Complete!");
        }
    }
}
