using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnControl : MonoBehaviour
{
    public float spawnRate, spawnDelay;
    public Spawner[] spawns;
    public int unitCount, minUnits, maxUnits;

    void Start()
    {
        spawns = GameObject.FindObjectsOfType<Spawner>();
        //spawns = GameObjects.FindGameObjectsWithTag("SpawnPoints").GetComponent;
        //InvokeRepeating("SelectSpawn", spawnDelay, spawnRate);
        Invoke("SelectSpawn", spawnDelay);
        //StartCoroutine("SpawnRoutine");
    }

    void SelectSpawn()
    {
        float currentRate = spawnRate;
        if(unitCount < maxUnits)
        {
            int random = Random.Range(0, spawns.Length);
            //print(random);
            spawns[random].Spawn();
            unitCount++;
        }
        if(unitCount < minUnits)
        {
            currentRate = currentRate / 2;
        }
        Invoke("SelectSpawn", spawnRate);
    }

    IEnumerator SpawnRoutine()
    {
        int random = Random.Range(0, spawns.Length);
        print(random);
        spawns[random].Spawn();
        yield return new WaitForSeconds(spawnRate);
        StartCoroutine("SpawnRoutine");
    }
}
