using UnityEngine;
using System.Collections;

public class UniverseShaderAnim : MonoBehaviour {

    public float MainRotationSpeed;
    public float InternRotationSpeed;
    public float FrequencyOfWave;
    public float AmplitudeOfWave;
    public float BaseAmplitudeOfWave;

    private Renderer render;

    float offset = 0f;

    private void Start()
    {
        render =  GetComponent<Renderer>();
    }

    // Unoptimized animation because the texture is not seamless and resetting the offset results in ugly effect
	private void Update ()
    {
        offset += Time.deltaTime;

        render.material.SetTextureOffset("_MainTex", Vector2.one * offset * MainRotationSpeed);
        render.material.SetTextureOffset("_BlendTexture", new Vector2(offset * InternRotationSpeed, 0f));

        float alphaCutout = BaseAmplitudeOfWave + AmplitudeOfWave * Mathf.Sin(FrequencyOfWave * offset);

        render.material.SetFloat("_AlphaCutout", alphaCutout);
	}
}
