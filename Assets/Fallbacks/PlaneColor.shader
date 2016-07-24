Shader "GG Shader/PlaneColor"
{
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 0)
	}
	SubShader 
	{
    	Tags {"Queue"="Transparent" "RenderType"="Transparent"}
    	Blend SrcAlpha OneMinusSrcAlpha

		Pass
	    {
	        CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag

	        #include "UnityCG.cginc"

	        uniform half4 _Color;

	        struct input 
	        {
	            float4 pos : POSITION;
	        };

	        struct output 
	        {
	            float4 pos : SV_POSITION;
	        };
	        
	        output vert (input v) 
	        {
	            output o;
	            o.pos = mul(UNITY_MATRIX_MVP, v.pos);
	            return o;
	        }
	        
	        half4 frag( output i ) : COLOR 
	        {
	        	return _Color;
	        }
	        ENDCG
	    }
	}
}