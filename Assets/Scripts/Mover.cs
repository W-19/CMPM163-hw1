using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class Mover : MonoBehaviour
{
    public float speed = 1;

    private float offset;

    // Update is called once per frame
    void Update()
    {
        transform.position = new Vector3(4f*(float)Math.Sin(Time.time*speed), 10, 4f*(float)Math.Sin(Time.time*speed));
    }
}
