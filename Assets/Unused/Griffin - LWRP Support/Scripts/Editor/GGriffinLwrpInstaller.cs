#if GRIFFIN
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Pinwheel.Griffin;
using UnityEditor;

namespace Pinwheel.Griffin.LWRP
{
    public static class GGriffinLwrpInstaller
    {
        public static void Install()
        {
            GGriffinLwrpResources resources = GGriffinLwrpResources.Instance;
            if (resources == null)
            {
                Debug.Log("Unable to load Griffin LWRP Resources.");
            }

            List<GWizardMaterialTemplate> terrainMaterialTemplates = new List<GWizardMaterialTemplate>();
            terrainMaterialTemplates.Add(new GWizardMaterialTemplate()
            {
                Pipeline = GRenderPipelineType.Lightweight,
                LightingModel = GLightingModel.PBR,
                TexturingModel = GTexturingModel.Splat,
                SplatsModel = GSplatsModel.Splats4,
                Material = resources.Terrain4SplatsMaterial
            });

            terrainMaterialTemplates.Add(new GWizardMaterialTemplate()
            {
                Pipeline = GRenderPipelineType.Lightweight,
                LightingModel = GLightingModel.PBR,
                TexturingModel = GTexturingModel.Splat,
                SplatsModel = GSplatsModel.Splats4Normals4,
                Material = resources.Terrain4Splats4NormalsMaterial
            });

            terrainMaterialTemplates.Add(new GWizardMaterialTemplate()
            {
                Pipeline = GRenderPipelineType.Lightweight,
                LightingModel = GLightingModel.PBR,
                TexturingModel = GTexturingModel.Splat,
                SplatsModel = GSplatsModel.Splats8,
                Material = resources.Terrain8SplatsMaterial
            });

            terrainMaterialTemplates.Add(new GWizardMaterialTemplate()
            {
                Pipeline = GRenderPipelineType.Lightweight,
                LightingModel = GLightingModel.PBR,
                TexturingModel = GTexturingModel.GradientLookup,
                Material = resources.TerrainGradientLookupMaterial
            });

            terrainMaterialTemplates.Add(new GWizardMaterialTemplate()
            {
                Pipeline = GRenderPipelineType.Lightweight,
                LightingModel = GLightingModel.PBR,
                TexturingModel = GTexturingModel.VertexColor,
                Material = resources.TerrainVertexColorMaterial
            });

            terrainMaterialTemplates.Add(new GWizardMaterialTemplate()
            {
                Pipeline = GRenderPipelineType.Lightweight,
                LightingModel = GLightingModel.PBR,
                TexturingModel = GTexturingModel.ColorMap,
                Material = resources.TerrainColorMapMaterial
            });

            GCreateTerrainWizardSettings wizardSetting = GGriffinSettings.Instance.WizardSettings;
            wizardSetting.LightweightRPMaterials = terrainMaterialTemplates;
            GGriffinSettings.Instance.WizardSettings = wizardSetting;

            GTerrainDataDefault terrainDataDefault = GGriffinSettings.Instance.TerrainDataDefault;
            GFoliageDefault foliageDefault = terrainDataDefault.Foliage;
            foliageDefault.GrassMaterialLWRP = resources.GrassMaterial;
            foliageDefault.GrassInteractiveMaterialLWRP = resources.GrassInteractiveMaterial;
            foliageDefault.TreeBillboardMaterialLWRP = resources.TreeBillboardMaterial;
            terrainDataDefault.Foliage = foliageDefault;
            GGriffinSettings.Instance.TerrainDataDefault = terrainDataDefault;

            string[] pathToDelete = new string[]
            {
                "Assets/Griffin - PolarisV2/Internal/Materials/TerrainMaterials/LightweightRP",
                "Assets/Griffin - PolarisV2/Internal/Materials/GrassMaterialLWRP.mat",
                "Assets/Griffin - PolarisV2/Internal/Materials/GrassInteractiveMaterialLWRP.mat",
                "Assets/Griffin - PolarisV2/Internal/Materials/TreeBillboardDefaultMaterialLWRP.mat",
                "Assets/Griffin - PolarisV2/Shaders/LightweightRP"
            };

            for (int i = 0; i < pathToDelete.Length; ++i)
            {
                FileUtil.DeleteFileOrDirectory(pathToDelete[i]);
            }

            EditorUtility.SetDirty(GGriffinSettings.Instance);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            EditorUtility.DisplayDialog("Completed", "Successfully installed Polaris V2 Lightweight Render Pipeline support.", "OK");
        }
    }
}
#endif
