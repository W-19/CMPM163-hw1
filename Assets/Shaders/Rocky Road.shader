// Based on the provided code for Twist. It's weird.

Shader "Custom/Rocky Road"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1) // The object's color
        _Speed ("Speed", Float) = 1.0
        _SomeInput ("Some Input", Float) = 5
        _Rockiness ("Rockiness", Float) = 1.0
    }
    SubShader
    {
     
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            struct Input
            {
                float2 uv_MainTex;
            };

            uniform float _Speed;
            uniform float _SomeInput;
            uniform float _Rockiness;
            uniform float _Color;

            // Add insåtancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;  
                float3 normal : NORMAL;
                
            };
            
            
         
            v2f vert (appdata v)
            {
                v2f o;
                
                const float PI = 3.14159;
                
                float rad = sin(_Time.y * _Speed);
                
                float increment = 1.0; // is this really an increment?
                float someValue = 1.0; // no idea what this does
                
                if (_Rockiness >= someValue) {
                    increment = 0.01;
                } else if (_Rockiness <= 0.0) {
                   increment = someValue;    
                } else {
                    increment = someValue - _Rockiness;
                }
                
                float ct = cos(v.vertex.y/increment);
               
                float newx = v.vertex.x + (v.normal.x * ct * rad)/_SomeInput;
                float newy = v.vertex.y + (v.normal.y * ct * rad)/_SomeInput; 
                float newz = v.vertex.z + (v.normal.x * ct * rad)/_SomeInput;
                
                float4 xyz = float4(newx, newy, newz, 1.0);
                
                o.vertex = UnityObjectToClipPos(xyz);
                o.normal = v.normal;
                
                return o;
            }

            float4 normalToColor (float3 n) {
                return float4( (normalize(n) + 1.0) / 2.0, 1.0) ;
            }
           

            fixed4 frag (v2f i) : SV_Target
            {
                return normalToColor(i.normal);
            }
       
            ENDCG
        }
    }
}
