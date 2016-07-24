Shader "GG Shader/ImageRender"
{
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
	        
	        half4 frag( output i ) : COLOR 
	        {
	        	half4 mainTex = half4(tex2D(_MainTex, i.uv));
	        	return mainTex;
	        }
	        ENDCG
	    }
	}
}
