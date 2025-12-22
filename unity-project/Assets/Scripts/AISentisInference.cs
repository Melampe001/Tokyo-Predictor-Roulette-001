using Unity.Sentis;
using UnityEngine;

public class AISentisInference : MonoBehaviour {
    public ModelAsset modelAsset;
    private IWorker worker;
    private Model runtimeModel;
    
    void Start() {
        runtimeModel = ModelLoader.Load(modelAsset);
        worker = WorkerFactory.CreateWorker(BackendType.GPUCompute, runtimeModel);
    }
    
    public int GetAIPrediction(float[] observations) {
        using var input = new TensorFloat(new TensorShape(1, observations.Length), observations);
        worker.Execute(input);
        
        var output = worker.PeekOutput() as TensorFloat;
        output.CompleteOperationsAndDownload();
        
        return GetMaxIndex(output.ToReadOnlyArray());
    }
    
    private int GetMaxIndex(float[] array) {
        int maxIndex = 0;
        for (int i = 1; i < array.Length; i++) {
            if (array[i] > array[maxIndex]) maxIndex = i;
        }
        return maxIndex;
    }
    
    void OnDestroy() {
        worker?.Dispose();
    }
}
