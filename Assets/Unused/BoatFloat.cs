using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoatFloat : MonoBehaviour
{
    private Transform seaPlane;
    private Cloth planeCloth;
    private int closestVertexIndex = -1;

    // Start is called before the first frame update
    void Start()
    {
        seaPlane = GameObject.Find("Ocean").transform;
        planeCloth = seaPlane.GetComponent<Cloth>();
    }

    // Update is called once per frame
    void Update()
    {
        GetClosestVertex();
    }

    void GetClosestVertex()
    {
        for(int i =0; i < planeCloth.vertices.Length; i++)
        {
            if(closestVertexIndex == -1)
            {
                closestVertexIndex = i;
            }
            float distance = Vector3.Distance(planeCloth.vertices[i], transform.position);
            float closestDistance = Vector3.Distance(planeCloth.vertices[closestVertexIndex], transform.position);

            if(distance < closestVertexIndex)
            {
                closestVertexIndex = i;
            }
        }

        transform.position = new Vector3(
            transform.position.x,
            planeCloth.vertices[closestVertexIndex].y/50,
            transform.position.z
            );
    }
}
