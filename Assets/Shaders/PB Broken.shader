// This doesn't work because apparently you can't have a sufrace shader and vertex/fragment shaders in the same file.
Shader "Custom/PB Broken"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1) // The object's color
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5 // Same as shininess?
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
        _Speed ("Speed", Float) = 1.0 // Bounce speed
        _Height ("Height", Float) = 3.0
    }
    SubShader
    {
        Tags {
            "RenderType"="Opaque"
            //"LightMode" = "ForwardAdd" //Important! In Unity, point lights are calculated in the the ForwardAdd pass
        }
        LOD 200
        Pass
        {
            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma surface surf Standard fullforwardshadows
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0
            sampler2D _MainTex;

            struct Input
            {
                float2 uv_MainTex;
            };

            uniform half _Glossiness;
            uniform half _Metallic;
            uniform fixed4 _Color;
            uniform float _Speed;
            uniform float _Height;

            // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
            // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
            // #pragma instancing_options assumeuniformscaling
            UNITY_INSTANCING_BUFFER_START(Props)
                // put more per-instance properties here
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf (Input IN, inout SurfaceOutputStandard o)
            {
                // Albedo comes from a texture tinted by color
                fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                o.Alpha = c.a;
            }

            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float3 vertexInWorldCoords : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;         
                float4 xyz = float4(
                        v.vertex.x,
                        v.vertex.y + _Height * abs(sin(_Time*_Speed)),
                        v.vertex.z,
                        1.0
                );
                o.vertex = UnityObjectToClipPos(xyz);
                o.uv = v.uv; //TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                
                float3 P = i.vertexInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 H = normalize(L + V);
                
                float3 Kd = _Color.rgb; //Color of object
                float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                //float3 Ka = float3(0,0,0); //UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                float3 Ks = _SpecColor.rgb; //Color of specular highlighting
                float3 Kl = _LightColor0.rgb; //Color of light
                
                
                //AMBIENT LIGHT 
                float3 ambient = Ka;
                
               
                //DIFFUSE LIGHT
                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;
                
                
                //SPECULAR LIGHT
                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                
                if (diffuseVal <= 0) {
                    specularVal = 0;
                }
                
                float3 specular = Ks * Kl * specularVal;
                
                //FINAL COLOR OF FRAGMENT
                return float4(ambient + diffuse + specular, 1.0);
                //return float4(ambient, 1.0);

            }

            ENDCG  
        }
        
    }
    FallBack "Diffuse"
}
