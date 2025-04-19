class MACW_ModuleAddHackingTools: Module_F
{
	scope = 2;
	displayName = "MACW Add Hacking Tools";
	category = "MACW_Modules";
	function = "MACW_fnc_MACWAddHackingTools";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 4;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			"MACW Add Hacking Tools. synchronize to laptop or USB stick."
		};
	};
};