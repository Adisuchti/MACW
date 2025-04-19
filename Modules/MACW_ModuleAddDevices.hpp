class MACW_ModuleAddDevices: Module_F
{
	scope = 2;
	displayName = "MACW Add Devices";
	category = "MACW_Modules";
	function = "MACW_fnc_MACWAddDevices";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 4;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		class MACW_Hack_Door_Cost_Edit: Edit
		{
			property = "MACW_Hack_Door_Cost_Edit";
			displayName = "Door hacking cost";
			tooltip = "power cost in Wh to hack a door";
			typeName = "NUMBER";
			defaultValue = 2;
		};
		
		class MACW_Hack_Drone_Side_Cost_Edit: Edit
		{
			property = "MACW_Hack_Drone_Side_Cost_Edit";
			displayName = "Drone side hacking cost";
			tooltip = "power cost in Wh to hack a drone and switch its side";
			typeName = "NUMBER";
			defaultValue = 20;
		};

		class MACW_Hack_Drone_Disable_Cost_Edit: Edit
		{
			property = "MACW_Hack_Drone_Disable_Cost_Edit";
			displayName = "Drone disable hacking cost";
			tooltip = "power cost in Wh to hack a drone and disable it";
			typeName = "NUMBER";
			defaultValue = 10;
		};
		class ModuleDescription: ModuleDescription{};
	};
	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			"MACW Add Devices. Synchronize to routers you wish it to be accessible from and to Triggers containing the devices to add."
		};
	};
};