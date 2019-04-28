// I basically fudged with the blur code to try and make it show outlines instead.
// It doesn't work quite as well as I'd hoped, but whatever.
Shader "Custom/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Contrast ("Contrast", Float) = 6
    }
    SubShader
    {
        // No culling or depth
        // Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform float4 _MainTex_TexelSize; //special value
            uniform float _Contrast;
            uniform int _modifyContrast;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // Should hopefully make the outlines more visible
            float3 accentuate (float3 input){
                return pow(input+0.5, _Contrast)-0.5;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {

                float2 texel = float2(
                    _MainTex_TexelSize.x, // texel width
                    _MainTex_TexelSize.y // texel height
                );

                float3 value = 0.0; // will be the sum of the differences between this texel and its neighbors
        
                int xOffset, yOffset;
        
                for ( xOffset = -1; xOffset <=1 ; xOffset++) {
                    for (yOffset = -1; yOffset <= 1; yOffset++) {
                        if(xOffset != 0 && yOffset != 0){ // don't count the texel itself. we're only interested in how different its neighbors are
                            value += 1 - (tex2D(_MainTex, i.uv) - tex2D( _MainTex, i.uv + texel * float2(xOffset, yOffset))).rgb;
                            //value += 1 - tex2D(_MainTex, float2(i.uv.x+(xOffset*texel.x), i.uv.y+(yOffset*texel.y))).rgb;
                        }             
                    }
                }

                //return float4(value/8, 1.0);
                return float4(accentuate(value/8), 1.0);

                /*
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                col.rgb = 1 - col.rgb;
                return col;
                */
            }

            
            ENDCG
        }
    }
}
