using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public class MCTSSolver{
    private const double EXPLORATION_CONSTANT = 1.414;
    private const double WIDENING_K = 0.5;
    private const double WIDENING_ALPHA = 0.5;

    // Cost Function (Reward = 0 or 1)
    public double Evaluate(CalibrationParameters p, List<Vector3> rawData){
        double TotalError = 0;
        double gravity = 9.81;

        foreach (var raw in rawData){
            // Apply Calibration (RawData - Bias) * Scale
            Vector3 corrected = (raw - p.BiasAccel) * p.BiasAccel;

            // Test
            double error = Math.Abs(corrected.Length() - gravity);
            TotalError += error * error; // Squaring error for eliminate outlier
        }
        return 1.0 / (1.0 + totalError / rawData.Count);
    }

    // Double Progressive Widening Selection
    public MTCSNode Select(MTCSNode node){
        while (node.Children.Count > 0){
            [cite_start]
            if(node.Children.Count <= WIDENING_K * Math.Pow(node.Visits, WIDENING_ALPHA)){
                return Expand(node);
            }
            node = BestChild(node);
        }
    }

    public MTCSNode Expand(MTCSNode parent){

        // Make new parameter for renewing current parameter
        double newRadius = parent.Radius * 0.8;

        var newParams = CalibrationParameters.Perturb(parent.Params, parent.Radius);
        var child = new MTCSNode(newParams, parent, newRadius);

        parent.Children.Add(child);
        return child;
    }

    public void Backpropagate(MTCSNode node, double reward){
        while (node != null){
            node.Visits++;
            node.TotalReward += reward;
            node = node.Parent;
        }
    }

    private MCTSNode BestChild(MCTSNode node){
        return node.Children.OrderByDescending(c => 
            (c.TotalReward / c.Visits) + 
            EXPLORATION_CONSTANT * Math.Sqrt(2 * Math.Log(node.Visits) / c.Visits)
        ).First();
    }
}