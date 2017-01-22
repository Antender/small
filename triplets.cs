using System;
using System.Linq;
using System.Collections.Generic;

public class Triplets
{
    private static void Main()
    {
        var maximum = countTriplets(Console.ReadLine().Split(','));
        Console.WriteLine("triplet: " + maximum.Key + " repetitions:" + maximum.Value);
    }
    
    private static KeyValuePair<string,int> countTriplets(string[] input) 
    {
        var triplets = new Dictionary<string,int>();
        foreach (var word in input)
        {
            if (word.Length < 3) { }
            else { 
                foreach (var triplet in
                word.Substring(0, word.Length)
                    .Zip(word.Substring(1, (word.Length - 1)), (ch1, ch2) => String.Concat(ch1, ch2))
                    .Zip(word.Substring(2, word.Length - 2), (ch1, ch2) => String.Concat(ch1, ch2)))
                {
                    if (triplets.ContainsKey(triplet))
                    {
                        triplets[triplet] = triplets[triplet] + 1;
                    }
                    else
                    {
                        triplets[triplet] = 1;
                    }
                }
            }
        }
        var max = triplets.First();
        foreach (var pair in triplets)
        {
            if (max.Value < pair.Value)
            {
                max = pair;
            }
        }
        return max;
    }
}