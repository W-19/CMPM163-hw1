using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class KeyboardScript : MonoBehaviour
{
    Renderer render;
    int BASE_INPUT_COOLDOWN = 1;
    int inputCooldown = 1;

    // Start is called before the first frame update
    void Start()
    {
        render = GetComponent<Renderer>();

        render.material.shader = Shader.Find("Custom/Outline");
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        /*
        // increase contrast by 1 if the up arrow key is down, decrease by 1 if the down arrow key is down
        render.material.SetInt("modifyContrast",(int)Math.Ceiling(Input.GetAxis("Vertical")));
        if((int)Math.Ceiling(Input.GetAxis("Vertical")) != 0){
            print((int)Math.Ceiling(Input.GetAxis("Vertical")));
        }
        */
        if(inputCooldown > 0){
            inputCooldown--;
        }

        if(inputCooldown == 0 && Input.GetKeyDown(KeyCode.UpArrow)){
            int currentContrast = render.material.GetInt("_Contrast");
            render.material.SetInt("_Contrast", currentContrast + 1);
            inputCooldown = BASE_INPUT_COOLDOWN;
        }
        if(inputCooldown == 0 && Input.GetKeyDown(KeyCode.DownArrow)){
            int currentContrast = render.material.GetInt("_Contrast");
            render.material.SetInt("_Contrast", currentContrast - 1);
            inputCooldown = BASE_INPUT_COOLDOWN;
        }
        
    }
}
