using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Armour : MonoBehaviour
{
    private int HP = 100;
    void Start()
    {

    }

    public void TakeDamage(int damage)
    {
        if ((HP - damage) > 0)
        {
            HP -= damage;
        }
        else if ((HP - damage) <= 0)
        {
            Destroy(gameObject);
            print("Shes down captain!");
        }
    }
}
