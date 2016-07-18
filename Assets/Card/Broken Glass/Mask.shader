﻿Shader "GG Shader/Broken Magma" 
{
	Properties
	{
		_ColorTex ("Color texture", 2D) = "white" {}
		_HeightMap ("Height map", 2D) = "white" {}
		_UVXPos ("Movement control", Range(-2.1, 1.1)) = 0
		_MaskSlope ("Mask slope", Range(0.5, 1.5)) = 0
		_Thickness("Thickness", Range(0, 1)) = 0.2
		_AlphaControl("Alpha control", Range(1, 5)) = 1
	}
	SubShader 
	{
    	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
    	Blend SrcAlpha OneMinusSrcAlpha

		Pass
	    {
	        CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag

	        #include "UnityCG.cginc"

	        uniform sampler2D _MainTex;

	        struct input 
	        {
	            float4 pos : POSITION;
	            float2 uv : TEXCOORD0;
	        };

	        struct output 
	        {
	            float4 pos : SV_POSITION;
	            float2 uv : TEXCOORD0;
	        };
	        
	        output vert (input v) 
	        {
	            output o;
	            o.uv = v.uv;
	            o.pos = mul(UNITY_MATRIX_MVP, v.pos);
	            return o;
	        }
	        
	        float4 frag( output i ) : COLOR 
	        {
	        	float4 mainTex = float4(tex2D(_MainTex, i.uv));
	        	return mainTex;
	        }
	        ENDCG
	    }

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
	        uniform float _AlphaControl;

	        struct input {
	            float4 pos : POSITION;
	            float2 uv : TEXCOORD0;
	        };

	        struct output {
	            float4 pos : SV_POSITION;
	            float2 uv : TEXCOORD0;
	        };
	        
	        output vert (input v) {
	            output o;
	            o.uv = v.uv;
	            o.pos = mul(UNITY_MATRIX_MVP, v.pos);
	            return o;
	        }

	        float4 maskTexture(float dist, float2 uv)
	        {
	        	if (dist < _Thickness)
	        	{
	        		float4 maskTex = float4(tex2D(_HeightMap, uv));
	        		float4 reflectedTex = float4(tex2D(_ColorTex, uv));

	        		float difference = abs(dist - _Thickness) / abs(_UVXPos - _Thickness);
	        		difference = pow(difference, _AlphaControl);

	        		return float4(reflectedTex.rgb, difference * maskTex.a);
	        	}

	        	return 0;
	        }
	        
	        float4 frag( output i ) : COLOR 
	        {
	        	float convertedXPos = _UVXPos + i.uv.y / _MaskSlope;
	        	float dist = distance(i.uv.x, convertedXPos);
	        	float4 maskTex = maskTexture(dist, i.uv);
	        	return maskTex;
	        }
	        ENDCG
	    }
	}
}