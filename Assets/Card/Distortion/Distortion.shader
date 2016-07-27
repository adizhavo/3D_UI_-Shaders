Shader "GG Shader/Distortion" 
{
	Properties 
	{
		_Distortion ("Distortion", Range(0, 1000)) = 10
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}
	SubShader 
	{
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }

		GrabPass 
		{
			Name "BASE"
		}

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct input 
			{
				float4 pos : POSITION;
				float2 texcoord: TEXCOORD0;
			};

			struct output 
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
			};

			uniform sampler2D _GrabTexture;
			uniform sampler2D _BumpMap;

			uniform float4 _BumpMap_ST;
			uniform float4 _GrabTexture_TexelSize;

			uniform float _Distortion;

			output vert(input v)
			{
				output o;
				o.pos = mul(UNITY_MATRIX_MVP, v.pos);

				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

				o.uv.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
				o.uv.zw = o.pos.zw;

				o.uvbump = TRANSFORM_TEX( v.texcoord, _BumpMap );

				return o;
			}

			half4 frag(output i) : COLOR
			{
				half2 bump = UnpackNormal(tex2D( _BumpMap, i.uvbump )).rg;
				fixed offset = bump * _Distortion * _GrabTexture_TexelSize.xy;
				i.uv.xy = offset * i.uv.z + i.uv.xy;
	
				half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv));
				return col;
			}
			ENDCG
		}
	}

	Fallback "GG Shader/PlaneColor"
}