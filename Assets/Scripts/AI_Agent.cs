using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AI_Agent : MonoBehaviour
{
    private NavMeshAgent agent;
    private GameObject player;
    public float minDist, maxDist;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        player = GameObject.Find("Crystal Voyager");
    }

    // Update is called once per frame
    void Update()
    {
        float distance = Vector3.Distance(transform.position, player.transform.position);
        if (distance >= minDist && distance <= maxDist)
        {
            agent.destination = player.transform.position;
        }
        else
        {
            agent.ResetPath();
        }
    }
}