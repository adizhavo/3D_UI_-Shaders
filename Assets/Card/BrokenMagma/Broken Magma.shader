Shader "GG Shader/Broken Magma" {
Properties{
	_ColorTex ("Color Texture", 2D) = "white" {}
	_HeightMap ("Height Map", 2D) = "white" {}
	_UVXPos ("UV X Position", Range(-1.5, 1.5)) = 0
	_MaskSlope ("Mask Slope", Range(0.5, 1.5)) = 0
	_Thickness("Thickness", Range(0, 1)) = 0.2
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

	        uniform sampler2D _MainTex;
	        uniform sampler2D _ColorTex;
	        uniform sampler2D _HeightMap;

	        uniform fixed _Thickness;
	        uniform fixed _UVXPos;
	        uniform fixed _MaskSlope;

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
	            o.uv = v.uv;
	            o.pos = mul( UNITY_MATRIX_MVP, v.pos);
	            return o;
	        }
	        
	        float4 frag( v2f i ) : COLOR {

	        	float4 mainTex = float4( tex2D(_MainTex, i.uv) );

	        	float convertedXPos = _UVXPos + i.uv.y / _MaskSlope;

	        	float dist = distance(i.uv.x, convertedXPos);

	        	if (dist < _Thickness)
	        	{
	        		float4 maskTex = float4( tex2D(_HeightMap, i.uv) );
	        		float4 colorTex = float4( tex2D(_ColorTex, i.uv) );

	        		float4 blended = float4(colorTex.rgb, maskTex.a * colorTex.a);

	        		if (blended.a > 0.01)
	        			mainTex = blended;
	        	}

	        	return mainTex;
	        }
	        ENDCG
	    }
	}
}