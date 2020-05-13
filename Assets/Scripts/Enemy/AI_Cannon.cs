using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Threading;
using UnityEngine;

public class AI_Cannon : MonoBehaviour
{
    public float rotSpeed, maxDist, fireRate;
    public GameObject player, barrel;
    private float dist;

    void Update()
    {
        dist = Vector3.Distance(transform.position, player.transform.position);
        Aim();
    }

    void Aim()
    {
        transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.LookRotation(player.transform.position - transform.position), rotSpeed * Time.deltaTime);
        if(dist <= maxDist)
        {
            Ray ray = new Ray(barrel.transform.position, barrel.transform.forward);
            RaycastHit hit;
            if(Physics.Raycast(ray, out hit, maxDist))
            {
                if (hit.collider.tag == "Player")
                {
                    print("fire");
                }
            }
        }
    }
}
