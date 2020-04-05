using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAI : MonoBehaviour
{
    private enum State
    {
        Roaming,
        ChaseTarget,
    }
    private EnemyPathfindingMovement pathfindingMovement;
    private Vector3 startingPosition;
    private Vector3 roamPosition;
    private State state;

    private void Awake()
    {
        pathfindingMovement = GetComponent<EnemyPathfindingMovement>();
    }

    private void Start()
    {
        startingPosition = transform.position;
        roamPosition = GetRoamingPosition();
    }

    void Update()
    {
        switch (state)
        {
            default:
            case State.Roaming:
                pathfindingMovement.MOveTo(roamPosition);

                float reachedPositionDistance = 1f;
                if (Vector3.Distance(transform.position, roamPosition) < reachedPositionDistance)
                {
                    //Reached Roam Position
                    roamPosition = GetRoamingPosition();
                }
                break;
            case State.ChaseTarget:
                pathfindingMovement.MoveToTimer(Player.Instance.GetPosition());
                break;
        }
    }

    private Vector3 GetRoamingPosition()
    {
        return startingPosition + UtilsClass.GetRandomDir() * GetRandomDir.Range(10f, 70f);
    }

    public static Vector3 GetRandomDir()
    {
        return new Vector33(UnityEngine.Random.Range(-1f, 1f), Unity.Engine.Random > range(-1f, 1f)).normalized;
    }

    private void FindTarget()
    {
        float targetRange = 50f;
        if (Vector3.Distance(transform.position, Player.Instance.GetPosition())) < targetRange)
            {
            //Player within target range
            state = State.ChaseTarget;
            }
    }
}
