Shader "Showreel/Universe" {
Properties{
	_MainTex ("Main Texture", 2D) = "white" {}
	_BlendTexture ("Secondary Texture", 2D) = "white" {}
	_AlphaCutout ("Alpha Cutout", Range (0,10)) = 0.5
	_CutoutStrength ("Alpha Cutout Strength", Range (0,10)) = 5
	_BaseAmplitudeOfWave("Base Amplitude of Wave", Range(3, 7)) = 5
}
SubShader {
    	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    	Blend SrcAlpha OneMinusSrcAlpha
Pass
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        uniform sampler2D _BlendTexture;
        // used to take the blended texture offset
        uniform float4 _BlendTexture_ST;

        struct appdata {
            float4 pos : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
        };
        
        v2f vert (appdata v) {
            v2f o;
            o.uv = TRANSFORM_TEX( v.uv, _BlendTexture );
            o.pos = mul( UNITY_MATRIX_MVP, v.pos );
            return o;
        }
        
        fixed4 frag( v2f i ) : COLOR {
        	return fixed4 ( tex2D(_BlendTexture, i.uv) );
        }
        ENDCG
    }
    Pass {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        uniform sampler2D _MainTex;
        uniform float _AlphaCutout;
        uniform float _CutoutStrength;
        // Used to take texture offset
        uniform float4 _MainTex_ST;

        struct appdata {
            float4 pos : POSITION;
            float3 norm : NORMAL;
            float2 uv : TEXCOORD0;
        };

        struct v2f {
            float4 pos : SV_POSITION;
            float4 col : COLOR;
            float2 uv : TEXCOORD0;
        };

        v2f vert (appdata v) {
            v2f o;
            o.uv = TRANSFORM_TEX( v.uv, _MainTex );
            o.pos = mul( UNITY_MATRIX_MVP, v.pos );

            // Get normals on objects position
            float3 normalDirection =  normalize ( mul ( float4 (v.norm, 0.0), _World2Object ).xyz );
            float3 cameraDirection = normalize(_WorldSpaceCameraPos.xyz);
            float alpha = _AlphaCutout - dot(normalDirection, cameraDirection * _CutoutStrength);
            o.col = float4(1, 1, 1, alpha);
            return o;
        }
        
        fixed4 frag( v2f i ) : COLOR {
        	return fixed4 ( tex2D(_MainTex, i.uv).rgb, i.col.a );
        }
        ENDCG
    }
}
}