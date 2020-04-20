using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    public SpawnControl sc;
    void Start()
    {
        sc = GameObject.Find("SpawnPoints").GetComponent<SpawnControl>();
    }

    // Update is called once per frame
    private void OnDestroy()
    {
        sc.unitCount--;
    }
}
