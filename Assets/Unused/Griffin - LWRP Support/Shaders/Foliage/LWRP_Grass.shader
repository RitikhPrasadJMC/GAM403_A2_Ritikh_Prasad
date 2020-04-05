// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Griffin/LWRP/Foliage/Grass"
{
    Properties
    {
		_NoiseTex("_NoiseTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_Cutoff("Cutoff", Range( 0 , 1)) = 0.5
		_Occlusion("Occlusion", Range( 0 , 1)) = 0.2
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.25
		[HideInInspector]_BendFactor("BendFactor", Float) = 1
		_WaveDistance("WaveDistance", Float) = 0.1
		_Wind("Wind", Vector) = (1,1,4,8)

    }


    SubShader
    {
		LOD 0

		
        Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="Grass" "Queue"="AlphaTest" }

		Cull Off
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
        Pass
        {
        	Tags { "LightMode"="LightweightForward" }

        	Name "Base"
			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
            
        	HLSLPROGRAM
            #pragma multi_compile_fog
            #define ASE_FOG 1
            #define _ALPHATEST_ON 1
            #define ASE_SRP_VERSION 50702

            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            

        	// -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            
        	// -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
        	#pragma fragment frag

        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
		
			

			sampler2D _NoiseTex;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _Wind;
			float _WaveDistance;
			float _BendFactor;
			float4 _Color;
			half4 _MainTex_ST;
			float _Occlusion;
			float _Smoothness;
			float _Cutoff;
			CBUFFER_END


            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
                float4 ase_tangent : TANGENT;
                float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct GraphVertexOutput
            {
                float4 clipPos                : SV_POSITION;
                float4 lightmapUVOrVertexSH	  : TEXCOORD0;
        		half4 fogFactorAndVertexLight : TEXCOORD1; // x: fogFactor, yzw: vertex light
            	float4 shadowCoord            : TEXCOORD2;
				float4 tSpace0					: TEXCOORD3;
				float4 tSpace1					: TEXCOORD4;
				float4 tSpace2					: TEXCOORD5;
				float4 ase_texcoord7 : TEXCOORD7;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            	UNITY_VERTEX_OUTPUT_STEREO
            };

			
            GraphVertexOutput vert (GraphVertexInput v  )
        	{
        		GraphVertexOutput o = (GraphVertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
            	UNITY_TRANSFER_INSTANCE_ID(v, o);
        		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 _VertexPos3_g6 = v.vertex;
				half4 transform15_g6 = mul(GetObjectToWorldMatrix(),_VertexPos3_g6);
				half2 appendResult22_g6 = (half2(transform15_g6.x , transform15_g6.z));
				float2 worldPosXZ21_g6 = appendResult22_g6;
				float _WindDirX11 = _Wind.x;
				float _WindDirX5_g6 = _WindDirX11;
				float _WindDirY12 = _Wind.y;
				float _WindDirY7_g6 = _WindDirY12;
				half2 appendResult19_g6 = (half2(_WindDirX5_g6 , _WindDirY7_g6));
				float _WindSpeed13 = _Wind.z;
				float _WindSpeed9_g6 = _WindSpeed13;
				float _WindSpread14 = _Wind.w;
				float _WindSpread10_g6 = _WindSpread14;
				float2 noisePos32_g6 = ( ( worldPosXZ21_g6 - ( appendResult19_g6 * _WindSpeed9_g6 * _Time.y ) ) / _WindSpread10_g6 );
				half2 uv059_g6 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				half temp_output_35_0_g6 = ( tex2Dlod( _NoiseTex, float4( noisePos32_g6, 0, 0.0) ).r * uv059_g6.y );
				float _WaveDistance9 = _WaveDistance;
				float _WaveDistance12_g6 = _WaveDistance9;
				float _BendFactor71 = _BendFactor;
				float _BendFactor38_g6 = _BendFactor71;
				half4 appendResult42_g6 = (half4(_WindDirX5_g6 , ( temp_output_35_0_g6 * 0.5 ) , _WindDirY7_g6 , 0.0));
				half4 transform47_g6 = mul(GetWorldToObjectMatrix(),( temp_output_35_0_g6 * _WaveDistance12_g6 * _BendFactor38_g6 * appendResult42_g6 ));
				float4 vertexOffset48_g6 = transform47_g6;
				float4 vertexOffset62 = vertexOffset48_g6;
				
				float3 vertexNormal55 = float3(0,1,0);
				
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = v.vertex.xyz;
				#else
				float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = vertexOffset62.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = vertexNormal55;

        		// Vertex shader outputs defined by graph
                float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
                
         		// We either sample GI from lightmap or SH.
        	    // Lightmap UV and vertex SH coefficients use the same interpolator ("float2 lightmapUV" for lightmap or "half3 vertexSH" for SH)
                // see DECLARE_LIGHTMAP_OR_SH macro.
        	    // The following funcions initialize the correct variable with correct data
        	    OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
        	    OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz);

        	    half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
			#ifdef ASE_FOG
        	    half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
			#else
				half fogFactor = 0;
			#endif
        	    o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
        	    o.clipPos = vertexInput.positionCS;

        	#ifdef _MAIN_LIGHT_SHADOWS
        		o.shadowCoord = GetShadowCoord(vertexInput);
        	#endif
        		return o;
        	}

        	half4 frag (GraphVertexOutput IN  ) : SV_Target
            {
            	UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

        		float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldSpaceViewDirection = SafeNormalize( _WorldSpaceCameraPos.xyz  - WorldSpacePosition );
    
				float4 _Color5 = _Color;
				half2 uv0_MainTex = IN.ase_texcoord7.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				half4 temp_output_24_0 = ( _Color5 * tex2D( _MainTex, uv0_MainTex ) );
				float _Occlusion18 = _Occlusion;
				half2 uv026 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				half lerpResult33 = lerp( 0.0 , _Occlusion18 , ( ( 1.0 - uv026.y ) * ( 1.0 - uv026.y ) ));
				float4 albedoColor40 = ( temp_output_24_0 - half4( ( 0.5 * float3(1,1,1) * lerpResult33 ) , 0.0 ) );
				
				float _Smoothness49 = _Smoothness;
				
				float alpha45 = temp_output_24_0.a;
				
				float _Cutoff16 = _Cutoff;
				
				
		        float3 Albedo = albedoColor40.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
				float3 Specular = float3(0.5, 0.5, 0.5);
				float Metallic = 0;
				float Smoothness = _Smoothness49;
				float Occlusion = 1;
				float Alpha = alpha45;
				float AlphaClipThreshold = _Cutoff16;

        		InputData inputData;
        		inputData.positionWS = WorldSpacePosition;

        #ifdef _NORMALMAP
        	    inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal)));
        #else
            #if !SHADER_HINT_NICE_QUALITY
                inputData.normalWS = WorldSpaceNormal;
            #else
        	    inputData.normalWS = normalize(WorldSpaceNormal);
            #endif
        #endif

			#if !SHADER_HINT_NICE_QUALITY
        	    // viewDirection should be normalized here, but we avoid doing it as it's close enough and we save some ALU.
        	    inputData.viewDirectionWS = WorldSpaceViewDirection;
			#else
        	    inputData.viewDirectionWS = normalize(WorldSpaceViewDirection);
			#endif

        	    inputData.shadowCoord = IN.shadowCoord;
			#ifdef ASE_FOG
        	    inputData.fogCoord = IN.fogFactorAndVertexLight.x;
			#endif
        	    inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
        	    inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS);

        		half4 color = LightweightFragmentPBR(
        			inputData, 
        			Albedo, 
        			Metallic, 
        			Specular, 
        			Smoothness, 
        			Occlusion, 
        			Emission, 
        			Alpha);

		#ifdef ASE_FOG
			#ifdef TERRAIN_SPLAT_ADDPASS
				color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
			#else
				color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
			#endif
		#endif

        #ifdef _ALPHATEST_ON
        		clip(Alpha - AlphaClipThreshold);
        #endif
		
		#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition (IN.clipPos.xyz, unity_LODFade.x);
		#endif
        		return color;
            }

        	ENDHLSL
        }

		
        Pass
        {
			
        	Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

            HLSLPROGRAM
            #pragma multi_compile_fog
            #define ASE_FOG 1
            #define _ALPHATEST_ON 1
            #define ASE_SRP_VERSION 50702

            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            

            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

			sampler2D _NoiseTex;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _Wind;
			float _WaveDistance;
			float _BendFactor;
			float4 _Color;
			half4 _MainTex_ST;
			float _Occlusion;
			float _Smoothness;
			float _Cutoff;
			CBUFFER_END


        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord7 : TEXCOORD7;
                UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
        	};

			
            // x: global clip space bias, y: normal world space bias
            float3 _LightDirection;

            VertexOutput ShadowPassVertex(GraphVertexInput v )
        	{
        	    VertexOutput o;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO (o);

				float4 _VertexPos3_g6 = v.vertex;
				half4 transform15_g6 = mul(GetObjectToWorldMatrix(),_VertexPos3_g6);
				half2 appendResult22_g6 = (half2(transform15_g6.x , transform15_g6.z));
				float2 worldPosXZ21_g6 = appendResult22_g6;
				float _WindDirX11 = _Wind.x;
				float _WindDirX5_g6 = _WindDirX11;
				float _WindDirY12 = _Wind.y;
				float _WindDirY7_g6 = _WindDirY12;
				half2 appendResult19_g6 = (half2(_WindDirX5_g6 , _WindDirY7_g6));
				float _WindSpeed13 = _Wind.z;
				float _WindSpeed9_g6 = _WindSpeed13;
				float _WindSpread14 = _Wind.w;
				float _WindSpread10_g6 = _WindSpread14;
				float2 noisePos32_g6 = ( ( worldPosXZ21_g6 - ( appendResult19_g6 * _WindSpeed9_g6 * _Time.y ) ) / _WindSpread10_g6 );
				half2 uv059_g6 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				half temp_output_35_0_g6 = ( tex2Dlod( _NoiseTex, float4( noisePos32_g6, 0, 0.0) ).r * uv059_g6.y );
				float _WaveDistance9 = _WaveDistance;
				float _WaveDistance12_g6 = _WaveDistance9;
				float _BendFactor71 = _BendFactor;
				float _BendFactor38_g6 = _BendFactor71;
				half4 appendResult42_g6 = (half4(_WindDirX5_g6 , ( temp_output_35_0_g6 * 0.5 ) , _WindDirY7_g6 , 0.0));
				half4 transform47_g6 = mul(GetWorldToObjectMatrix(),( temp_output_35_0_g6 * _WaveDistance12_g6 * _BendFactor38_g6 * appendResult42_g6 ));
				float4 vertexOffset48_g6 = transform47_g6;
				float4 vertexOffset62 = vertexOffset48_g6;
				
				float3 vertexNormal55 = float3(0,1,0);
				
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = v.vertex.xyz;
				#else
				float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = vertexOffset62.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = vertexNormal55;

        	    float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

                float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
                float scale = invNdotL * _ShadowBias.y;

                // normal bias is negative since we want to apply an inset normal offset
                positionWS = _LightDirection * _ShadowBias.xxx + positionWS;
				positionWS = normalWS * scale.xxx + positionWS;
                float4 clipPos = TransformWorldToHClip(positionWS);

                // _ShadowBias.x sign depens on if platform has reversed z buffer
                //clipPos.z += _ShadowBias.x;

        	#if UNITY_REVERSED_Z
        	    clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
        	#else
        	    clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
        	#endif
                o.clipPos = clipPos;

        	    return o;
        	}

            half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

               float4 _Color5 = _Color;
               half2 uv0_MainTex = IN.ase_texcoord7.xy * _MainTex_ST.xy + _MainTex_ST.zw;
               half4 temp_output_24_0 = ( _Color5 * tex2D( _MainTex, uv0_MainTex ) );
               float alpha45 = temp_output_24_0.a;
               
               float _Cutoff16 = _Cutoff;
               

				float Alpha = alpha45;
				float AlphaClipThreshold = _Cutoff16;

        #ifdef _ALPHATEST_ON
        		clip(Alpha - AlphaClipThreshold);
        #endif

		#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition (IN.clipPos.xyz, unity_LODFade.x);
		#endif
				return 0;
            }

            ENDHLSL
        }

		
        Pass
        {
			
        	Name "DepthOnly"
            Tags { "LightMode"="DepthOnly" }

            ZWrite On
			ColorMask 0

            HLSLPROGRAM
            #pragma multi_compile_fog
            #define ASE_FOG 1
            #define _ALPHATEST_ON 1
            #define ASE_SRP_VERSION 50702

            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            

			sampler2D _NoiseTex;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _Wind;
			float _WaveDistance;
			float _BendFactor;
			float4 _Color;
			half4 _MainTex_ST;
			float _Occlusion;
			float _Smoothness;
			float _Cutoff;
			CBUFFER_END


            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

			           

            VertexOutput vert(GraphVertexInput v  )
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 _VertexPos3_g6 = v.vertex;
				half4 transform15_g6 = mul(GetObjectToWorldMatrix(),_VertexPos3_g6);
				half2 appendResult22_g6 = (half2(transform15_g6.x , transform15_g6.z));
				float2 worldPosXZ21_g6 = appendResult22_g6;
				float _WindDirX11 = _Wind.x;
				float _WindDirX5_g6 = _WindDirX11;
				float _WindDirY12 = _Wind.y;
				float _WindDirY7_g6 = _WindDirY12;
				half2 appendResult19_g6 = (half2(_WindDirX5_g6 , _WindDirY7_g6));
				float _WindSpeed13 = _Wind.z;
				float _WindSpeed9_g6 = _WindSpeed13;
				float _WindSpread14 = _Wind.w;
				float _WindSpread10_g6 = _WindSpread14;
				float2 noisePos32_g6 = ( ( worldPosXZ21_g6 - ( appendResult19_g6 * _WindSpeed9_g6 * _Time.y ) ) / _WindSpread10_g6 );
				half2 uv059_g6 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				half temp_output_35_0_g6 = ( tex2Dlod( _NoiseTex, float4( noisePos32_g6, 0, 0.0) ).r * uv059_g6.y );
				float _WaveDistance9 = _WaveDistance;
				float _WaveDistance12_g6 = _WaveDistance9;
				float _BendFactor71 = _BendFactor;
				float _BendFactor38_g6 = _BendFactor71;
				half4 appendResult42_g6 = (half4(_WindDirX5_g6 , ( temp_output_35_0_g6 * 0.5 ) , _WindDirY7_g6 , 0.0));
				half4 transform47_g6 = mul(GetWorldToObjectMatrix(),( temp_output_35_0_g6 * _WaveDistance12_g6 * _BendFactor38_g6 * appendResult42_g6 ));
				float4 vertexOffset48_g6 = transform47_g6;
				float4 vertexOffset62 = vertexOffset48_g6;
				
				float3 vertexNormal55 = float3(0,1,0);
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = v.vertex.xyz;
				#else
				float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = vertexOffset62.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = vertexNormal55;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag(VertexOutput IN  ) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

				float4 _Color5 = _Color;
				half2 uv0_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				half4 temp_output_24_0 = ( _Color5 * tex2D( _MainTex, uv0_MainTex ) );
				float alpha45 = temp_output_24_0.a;
				
				float _Cutoff16 = _Cutoff;
				

				float Alpha = alpha45;
				float AlphaClipThreshold = _Cutoff16;

        #ifdef _ALPHATEST_ON
        		clip(Alpha - AlphaClipThreshold);
        #endif
		#ifdef LOD_FADE_CROSSFADE
				LODDitheringTransition (IN.clipPos.xyz, unity_LODFade.x);
		#endif
				return 0;
            }
            ENDHLSL
        }

        // This pass it not used during regular rendering, only for lightmap baking.
		
        Pass
        {
			
        	Name "Meta"
            Tags { "LightMode"="Meta" }

            Cull Off

            HLSLPROGRAM
            #pragma multi_compile_fog
            #define ASE_FOG 1
            #define _ALPHATEST_ON 1
            #define ASE_SRP_VERSION 50702

            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            #pragma vertex vert
            #pragma fragment frag

			
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            

			sampler2D _NoiseTex;
			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _Wind;
			float _WaveDistance;
			float _BendFactor;
			float4 _Color;
			half4 _MainTex_ST;
			float _Occlusion;
			float _Smoothness;
			float _Cutoff;
			CBUFFER_END


            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            
            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

			
            VertexOutput vert(GraphVertexInput v  )
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float4 _VertexPos3_g6 = v.vertex;
				half4 transform15_g6 = mul(GetObjectToWorldMatrix(),_VertexPos3_g6);
				half2 appendResult22_g6 = (half2(transform15_g6.x , transform15_g6.z));
				float2 worldPosXZ21_g6 = appendResult22_g6;
				float _WindDirX11 = _Wind.x;
				float _WindDirX5_g6 = _WindDirX11;
				float _WindDirY12 = _Wind.y;
				float _WindDirY7_g6 = _WindDirY12;
				half2 appendResult19_g6 = (half2(_WindDirX5_g6 , _WindDirY7_g6));
				float _WindSpeed13 = _Wind.z;
				float _WindSpeed9_g6 = _WindSpeed13;
				float _WindSpread14 = _Wind.w;
				float _WindSpread10_g6 = _WindSpread14;
				float2 noisePos32_g6 = ( ( worldPosXZ21_g6 - ( appendResult19_g6 * _WindSpeed9_g6 * _Time.y ) ) / _WindSpread10_g6 );
				half2 uv059_g6 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				half temp_output_35_0_g6 = ( tex2Dlod( _NoiseTex, float4( noisePos32_g6, 0, 0.0) ).r * uv059_g6.y );
				float _WaveDistance9 = _WaveDistance;
				float _WaveDistance12_g6 = _WaveDistance9;
				float _BendFactor71 = _BendFactor;
				float _BendFactor38_g6 = _BendFactor71;
				half4 appendResult42_g6 = (half4(_WindDirX5_g6 , ( temp_output_35_0_g6 * 0.5 ) , _WindDirY7_g6 , 0.0));
				half4 transform47_g6 = mul(GetWorldToObjectMatrix(),( temp_output_35_0_g6 * _WaveDistance12_g6 * _BendFactor38_g6 * appendResult42_g6 ));
				float4 vertexOffset48_g6 = transform47_g6;
				float4 vertexOffset62 = vertexOffset48_g6;
				
				float3 vertexNormal55 = float3(0,1,0);
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				float3 defaultVertexValue = v.vertex.xyz;
				#else
				float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = vertexOffset62.xyz;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = vertexNormal55;
#if !defined( ASE_SRP_VERSION ) || ASE_SRP_VERSION  > 51300				
                o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST);
#else
				o.clipPos = MetaVertexPosition (v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST);
#endif
        	    return o;
            }

            half4 frag(VertexOutput IN  ) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

           		float4 _Color5 = _Color;
           		half2 uv0_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
           		half4 temp_output_24_0 = ( _Color5 * tex2D( _MainTex, uv0_MainTex ) );
           		float _Occlusion18 = _Occlusion;
           		half2 uv026 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
           		half lerpResult33 = lerp( 0.0 , _Occlusion18 , ( ( 1.0 - uv026.y ) * ( 1.0 - uv026.y ) ));
           		float4 albedoColor40 = ( temp_output_24_0 - half4( ( 0.5 * float3(1,1,1) * lerpResult33 ) , 0.0 ) );
           		
           		float alpha45 = temp_output_24_0.a;
           		
           		float _Cutoff16 = _Cutoff;
           		
				
		        float3 Albedo = albedoColor40.rgb;
				float3 Emission = 0;
				float Alpha = alpha45;
				float AlphaClipThreshold = _Cutoff16;

        #ifdef _ALPHATEST_ON
        		clip(Alpha - AlphaClipThreshold);
        #endif

                MetaInput metaInput = (MetaInput)0;
                metaInput.Albedo = Albedo;
                metaInput.Emission = Emission;
                
                return MetaFragment(metaInput);
            }
            ENDHLSL
        }
		
    }
    Fallback "Hidden/InternalErrorShader"
	
	
}
/*ASEBEGIN
Version=17700
7;19;1906;1000;3957.473;-865.5482;1.622685;True;False
Node;AmplifyShaderEditor.CommentaryNode;41;-3517.229,-256.6267;Inherit;False;1899.109;1469.351;;6;40;39;37;38;44;45;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-2325.277,-1703.304;Inherit;False;692.3564;1341.44;;19;14;13;8;10;12;9;11;16;15;5;18;4;17;7;6;48;49;70;71;Properties;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-3415.318,290.2566;Inherit;False;1270.362;876.2831;;7;35;34;33;30;32;31;36;Occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-2197.921,-1466.304;Float;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;None;None;False;white;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;36;-3395.857,845.9573;Inherit;False;711;293;;4;26;27;28;29;Occlusion factor;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3345.857,910.957;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1891.92,-1465.304;Float;False;_MainTex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;38;-3109.156,-135.5909;Inherit;False;957;392;;5;21;22;23;25;24;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2275.277,-689.3755;Float;False;Property;_Occlusion;Occlusion;5;0;Create;True;0;0;False;0;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-3060.857,895.9569;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-3011.407,8.565916;Inherit;False;7;_MainTex;1;0;OBJECT;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1897.552,-686.8655;Float;False;_Occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-3065.857,1028.956;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-2181.921,-1652.304;Float;False;Property;_Color;Color;2;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2853.856,953.9564;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-1892.92,-1653.304;Float;False;_Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2179.921,-1244.304;Float;False;Property;_WaveDistance;WaveDistance;8;0;Create;True;0;0;False;0;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;10;-2180.921,-1143.305;Float;False;Property;_Wind;Wind;9;0;Create;True;0;0;False;0;1,1,4,8;1,1,7,7;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;35;-2931.117,686.2404;Inherit;False;18;_Occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2847.918,578.3406;Float;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-3059.156,100.409;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-2169.119,-483.6877;Float;False;Property;_BendFactor;BendFactor;7;1;[HideInInspector];Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-2645.116,634.2404;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-2675.559,1405.766;Inherit;False;1054.499;767.7213;;10;68;66;64;65;72;63;74;54;55;62;Vertex Animation, Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2634.255,340.2565;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2705.05,8.684111;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;32;-2659.255,452.257;Float;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2606.156,-85.59092;Inherit;False;5;_Color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1893.92,-1136.305;Float;False;_WindDirX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1893.92,-979.3051;Float;False;_WindSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1893.92,-1061.305;Float;False;_WindDirY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1896.119,-481.6877;Float;False;_BendFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1895.92,-898.3049;Float;False;_WindSpread;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1892.92,-1243.304;Float;False;_WaveDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-2612.559,1788.493;Inherit;False;13;_WindSpeed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-2608.774,2058.487;Inherit;False;71;_BendFactor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2606.159,1629.02;Inherit;False;11;_WindDirX;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2602.559,1709.493;Inherit;False;12;_WindDirY;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2616.559,1883.493;Inherit;False;14;_WindSpread;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2625.559,1969.493;Inherit;False;9;_WaveDistance;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2321.157,-8.590945;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2289.256,500.2567;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;44;-2110.054,-11.27011;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;54;-2084.435,1456.463;Float;False;Constant;_Up;Up;7;0;Create;True;0;0;False;0;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;15;-2275.277,-792.2769;Float;False;Property;_Cutoff;Cutoff;4;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;74;-2221.365,1666.717;Inherit;True;GrassWindAnimation;0;;6;8d39a13fc2a7a164fa1708057ff071d3;0;7;1;FLOAT4;0,0,0,0;False;51;FLOAT;1;False;52;FLOAT;1;False;53;FLOAT;7;False;54;FLOAT;7;False;55;FLOAT;0.2;False;56;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-2025.438,246.9899;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-1864.062,1455.766;Float;False;vertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1844.054,53.72989;Float;False;alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1896.298,-791.022;Float;False;_Cutoff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-1847.459,246.99;Float;False;albedoColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1870.16,1655.02;Float;False;vertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2273.713,-590.1987;Float;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0.25;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-1897.713,-588.1987;Float;False;_Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-371.1169,354.3228;Inherit;False;62;vertexOffset;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-377.9375,93.27258;Inherit;False;49;_Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-373.3654,450.1091;Inherit;False;55;vertexNormal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-342.0536,261.7299;Inherit;False;16;_Cutoff;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-342.2595,180.5466;Inherit;False;45;alpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-367.3995,-0.407074;Inherit;False;40;albedoColor;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;True;Meta;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Half;False;True;-1;2;;0;2;Griffin/LWRP/Foliage/Grass;1976390536c6c564abb90fe41f6ee334;True;Base;0;0;Base;11;False;False;False;True;2;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Grass=RenderType;Queue=AlphaTest=Queue=0;True;2;0;True;0;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;Hidden/InternalErrorShader;0;0;Standard;10;Workflow;1;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;LOD CrossFade;0;Built-in Fog;1;Meta Pass;1;Vertex Position,InvertActionOnDeselection;1;0;4;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;2;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;7;0;6;0
WireConnection;27;0;26;2
WireConnection;18;0;17;0
WireConnection;28;0;26;2
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;5;0;4;0
WireConnection;23;2;22;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;33;2;29;0
WireConnection;21;0;22;0
WireConnection;21;1;23;0
WireConnection;11;0;10;1
WireConnection;13;0;10;3
WireConnection;12;0;10;2
WireConnection;71;0;70;0
WireConnection;14;0;10;4
WireConnection;9;0;8;0
WireConnection;24;0;25;0
WireConnection;24;1;21;0
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;30;2;33;0
WireConnection;44;0;24;0
WireConnection;74;51;63;0
WireConnection;74;52;64;0
WireConnection;74;53;65;0
WireConnection;74;54;66;0
WireConnection;74;55;68;0
WireConnection;74;56;72;0
WireConnection;39;0;24;0
WireConnection;39;1;30;0
WireConnection;55;0;54;0
WireConnection;45;0;44;3
WireConnection;16;0;15;0
WireConnection;40;0;39;0
WireConnection;62;0;74;0
WireConnection;49;0;48;0
WireConnection;0;0;42;0
WireConnection;0;4;50;0
WireConnection;0;6;46;0
WireConnection;0;7;43;0
WireConnection;0;8;73;0
WireConnection;0;10;59;0
ASEEND*/
//CHKSM=93124D9FD0868759413597F29B5EF8590B8B946E