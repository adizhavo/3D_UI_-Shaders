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

			uniform fixed4 _BurnColor;
			uniform fixed4 _AshColor;
			uniform fixed _BurnThickness;
			uniform fixed _BurnControl;
			uniform bool _BlendBurned;

			uniform float4 _HeightMap_ST;

			struct appData
			{
				fixed4 pos : POSITION;
				fixed2 uv : TEXCOORD0;
			};

			struct v2f
			{
				fixed4 pos : SV_POSITION;
				fixed2 uv : TEXCOORD0;
			};

			v2f vert(appData input)
			{
				v2f output;

				output.pos = mul(UNITY_MATRIX_MVP, input.pos);
				output.uv = input.uv;

				return output;
			}

			fixed grayscale (fixed r, fixed g, fixed b)
			{
				return (r + g + b) / 3;
			}

			fixed4 frag(v2f input) : COLOR
			{
				fixed4 textColor = fixed4( tex2D(_MainTex, input.uv));

				fixed4 heightColor = fixed4( tex2D(_HeightMap, TRANSFORM_TEX(input.uv, _HeightMap)));

				fixed4 burnedTexture = fixed4( tex2D(_BurnedTex, input.uv));

				fixed heightGrayscale = 1 - grayscale(heightColor.r, heightColor.b, heightColor.g) - _BurnThickness;

				if (heightGrayscale < _BurnControl - _BurnThickness) // already burned
				{
					textColor = _AshColor * burnedTexture * fixed4(1, 1, 1, textColor.a);
				}
				else if (heightGrayscale < _BurnControl + _BurnThickness) // is burning
				{
					textColor = textColor * _BurnColor;
				}

				return textColor;
			}

			ENDCG
		}
	}
}