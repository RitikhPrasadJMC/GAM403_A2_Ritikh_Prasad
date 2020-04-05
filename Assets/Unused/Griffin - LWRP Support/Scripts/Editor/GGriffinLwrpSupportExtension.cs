#if GRIFFIN && UNITY_EDITOR
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using Pinwheel.Griffin;
using Pinwheel.Griffin.LWRP;

namespace Pinwheel.Griffin.LWRP.GriffinExtension
{
    public static class GriffinLwrpSupport
    {
        public static string GetExtensionName()
        {
            return "Polaris V2 - Lightweight Render Pipeline Support";
        }
        
        public static string GetPublisherName()
        {
            return "Pinwheel Studio";
        }
        
        public static string GetDescription()
        {
            return "Adding support for LWRP.\n" +
                "Requires Unity 2019.1 or above.";
        }
        
        public static string GetVersion()
        {
            return "1.0.3";
        }
        
        public static void OpenSupportLink()
        {
            GEditorCommon.OpenEmailEditor(
                GCommon.SUPPORT_EMAIL,
                "[Polaris V2] LWRP Support",
                "YOUR_MESSAGE_HERE");
        }
        
        public static void OnGUI()
        {
#if UNITY_2019
            GUI.enabled = true;
#else
            GUI.enabled = false;
#endif
            if (GUILayout.Button("Install"))
            {
                GGriffinLwrpInstaller.Install();
            }

            GUI.enabled = true;
        }
    }
}
#endif
