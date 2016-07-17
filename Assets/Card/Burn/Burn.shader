Shader "GG Shader/Burn"
{
	Properties 
	{
		_HeightMap ("Burn height map", 2D) = "white" {}
		_BurnedTex ("Burned texture", 2D) = "white" {}
		_BlendBurned ("Blend Burned", int) = 0

		_BurnColor ("Burn color", Color) = (1, 1, 1, 1)
		_AshColor ("Ash color", Color) = (0, 0, 0, 0)
		_BurnThickness ("Burn thickness", Range(0, 0.5) ) = 0.5

		// Control Value
		_BurnControl ("BurnControl", Range(-0.5, 1.5)) = 0
	}
	SubShader
	{
		Tags {"Queue" = "Transparent" "RenderType" = "Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _HeightMap;
			uniform sampler2D _BurnedTex;

			uniform float4 _BurnColor;
			uniform float4 _AshColor;
			uniform float _BurnThickness;
			uniform float _BurnControl;
			uniform bool _BlendBurned;

			struct appData
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appData input)
			{
				v2f output;

				output.pos = mul(UNITY_MATRIX_MVP, input.pos);
				output.uv = input.uv;

				return output;
			}

			float grayscale (float r, float g, float b)
			{
				return (r + g + b) / 3;
			}

			float4 frag(v2f input) : COLOR
			{
				float4 textColor = float4( tex2D(_MainTex, input.uv));

				float4 heightColor = float4( tex2D(_HeightMap, input.uv));

				float4 burnedTexture = float4( tex2D(_BurnedTex, input.uv));

				float heightGrayscale = 1 - grayscale(heightColor.r, heightColor.b, heightColor.g) - _BurnThickness;

				if (heightGrayscale < _BurnControl - _BurnThickness) // already burned
				{
					textColor = _BlendBurned == 1 ? textColor * _BurnColor * burnedTexture : burnedTexture * float4(1, 1, 1, textColor.a);
				}
				else if (heightGrayscale < _BurnControl + _BurnThickness) // is burning
				{
					textColor = textColor * _AshColor;
				}

				return textColor;
			}

			ENDCG
		}
	}
}