using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Threading;
using UnityEngine;

public class Cannon : MonoBehaviour
{
    public GameObject cannonBall;
    public Transform barrel;
    public int ammo;
    public float ballSpeed;
    public GameObject player;
    public float rotSpeed;

    void Start()
    {
        player = GameObject.Find("Crystal Voyager");
    }
    void Update()
    {
        GetInput();
    }

    void GetInput()
    {
        //if (Input.GetKey(KeyCode.Space))
        if (Input.GetKeyDown(KeyCode.Space) && ammo > 0)
        {
            Shoot();
            ammo -= 1;
        }
        else if (Input.GetKeyDown(KeyCode.Space) && ammo <= 0)
        {
            print("We're out of ammo, reload champ!");
        }
        if (Input.GetKeyDown(KeyCode.R) && ammo <= 0)
        {
            ammo = 10;
            print("Ammo reloaded, shoot to kill Cap'n! ;)");
        }
        else if (cannonBall == null)
        {
            print("Boss the cannons are jammed!");
        }
    }
    void Shoot()
    {
        GameObject cb = Instantiate(cannonBall, barrel.position, barrel.rotation);
        CannonBall cbScript = cb.GetComponent<CannonBall>();
        cbScript.speed = ballSpeed;
        cbScript.GoFast();
    }
}