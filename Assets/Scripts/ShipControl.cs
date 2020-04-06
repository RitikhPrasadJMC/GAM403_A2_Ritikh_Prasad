using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipControl : MonoBehaviour
{
    public List<float> sailSpeeds = new List<float>();
    private int sailIndex = 0;
    private float speed;

    private void Start()
    {
        speed = sailSpeeds[sailIndex];
    }
 
    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal") * speed; //Fowards and Backwards
        float vertical = Input.GetAxis("Vertical") * speed * Time.deltaTime; //Turning
        transform.position += transform.forward * vertical;
        transform.Rotate(0, horizontal, 0);

        if (Input.GetKeyDown(KeyCode.E))
        {
            SetSailSpeeds(1);
        }
    }

    private void SetSailSpeeds(int _value)
    {
        sailIndex += _value;

        if(sailIndex < 0)
        {
            sailIndex = sailSpeeds.Count - 1;
        }

        if(sailIndex > sailSpeeds.Count - 1)
        {
            sailIndex = 0;
        }

        speed = sailSpeeds[sailIndex];
        Debug.Log("Current Speed is: " + speed.ToString());
    }
}
