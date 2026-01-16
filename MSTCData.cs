using Godot;
using System.Collections.Generic;

// Optimizer
public struct CalibrationParameters{
    public Vector3 BiasAccel;
    public Vector3 ScaleAccel;

    public static CalibrationParameters Perturb(CalibrationParameters parent, double radius){
        var rng = new RandomNumberGenerator();
        rng.Randomize();

        return new CalibrationParameters{
            BiasAccel = parent.BiasAccel + new Vector3(
                (float)rng.Randfn(0, radius),
                (float)rng.Randfn(0, radius),
                (float)rng.Randfn(0, radius)
            ),
            ScaleAccel = parent.ScaleAccel  // Locking Scale to 1
        };
    }
}

public class MCTSNode
{
    public CalibrationParameters Params;
    public double TotalReward;
    public int Visits;
    public List<MCTSNode> Children;
    public MCTSNode Parent;

    public double radius;

    public MCTSNode(CalibrationParameters p, MCTSNode parent, double radius){
        Params = p;
        Parent = parent;
        radius = radius;
        Children = new List<MCTSNode>();
        Visits = 1; // Set to be 1 to avoid divided by 0
        TotalReward = 0;  

    }
}