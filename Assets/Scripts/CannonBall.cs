using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CannonBall : MonoBehaviour
{
    public float speed;
    public float killTime;
    public Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        GoFast();
    }

    public void GoFast()
    {
        rb.AddForce(transform.forward * speed, ForceMode.VelocityChange);
        Destroy(gameObject, killTime);
    }

    void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.tag == "Armour")
        {
            col.gameObject.GetComponent<Armour>().TakeDamage(25);
            print("Damn Captain, she's tough huh? Let's give her another spoonfull!");
            Destroy(gameObject);
        }
    }
}