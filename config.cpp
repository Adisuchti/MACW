#include "BIS_AddonInfo.hpp"
#include "\a3\3DEN\UI\macros.inc"
#include "\a3\3DEN\UI\macroexecs.inc"

#define GUI_GRID_X    (0)
#define GUI_GRID_Y    (0)
#define GUI_GRID_W    (0.025)
#define GUI_GRID_H    (0.04)

#define GUI_GRID_CENTER_X  (0)
#define GUI_GRID_CENTER_Y  (0)
#define GUI_GRID_CENTER_W  (0.025)
#define GUI_GRID_CENTER_H  (0.04)
#define RECOMPILE_FUNCTIONS 0
class RscText;
class RscFrame;
class RscButton;
class RscListbox;
class RscStructuredText;
class RscEdit;
class RscShortcutButton;
class RscPicture;
class RscHTML;
class RscDisplayAttributes;

class CfgPatches
{
	class MACW_patches
	{
		units[]={
            "MACW_ModuleAddHackingTools",
            "MACW_ModuleAddDevices",
            "MACW_ModuleAddDatabase"
			};
        requiredVersion = 1.00;
		requiredAddons[] =
        {
			"A3_Modules_F",
			"3DEN"
        };
        author = "Adrian Misterov";
        name = "Mister Adrians Cyber Warfare";
        version = "1.0";
	};
};
class CfgFactionClasses
{
    class MACW_modules
    {
        displayname = "Mr. A. Cyber Warfare";
        priority = 1;
        side = 7;
    };
};

class CfgFunctions
{
    class MACW
    {
        class MACWFnc
        {
            tag = "MACW";
            file = "\MACW\MACWFnc";
            class MACWAddDevices {
				recompile = RECOMPILE_FUNCTIONS;
			};
            class MACWAddHackingTools {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWListDevicesInSubnet {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWListSubnets {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWChangeDoorState {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWRemovePower {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWChangeLightState {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWChangeDroneFaction {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWDisableDrone {
                recompile = RECOMPILE_FUNCTIONS;
            };
            class MACWDownloadDatabase {
                recompile = RECOMPILE_FUNCTIONS;
            };
        };
	};
};

class CfgVehicles
{
    class Logic;
    class Item_Base_F;
    class Module_F: Logic
    {
        class AttributesBase
        {
            class Default;
            class Edit; // Default edit box (i.e., text input field)
            class Combo; // Default combo box (i.e., drop-down menu)
            class CheckBox; // Tickbox, returns true/false
            class CheckBoxNumber; // Tickbox, returns 1/0
            class ModuleDescription; // Module description
        };
        class ModuleDescription
        {
            class Anything;
        };
    };

    #include "Modules\MACW_ModuleAddDevices.hpp"
    #include "Modules\MACW_ModuleAddHackingTools.hpp"
    #include "Modules\MACW_ModuleAddDatabase.hpp"
};