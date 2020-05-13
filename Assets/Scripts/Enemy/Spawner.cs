using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour
{
	public GameObject enemy;

	public void Spawn()
	{
		GameObject e = Instantiate(enemy, transform.position, transform.rotation);
		Destroy(e, 5);
	}

}
