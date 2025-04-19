class MACW_ModuleAddDatabase: Module_F
{
	scope = 2;
	displayName = "MACW Add Database";
	category = "MACW_Modules";
	icon = "\a3\ui_f\data\igui\cfg\actions\gear_ca.paa";
	functionPriority = 4;
	isGlobal = 0;
	isTriggerActivated = 0;
	isDisposable = 1;

	class Attributes: AttributesBase
	{
		class MACW_DatabaseName_Edit: Edit
		{
			property = "MACW_DatabaseName_Edit";
			displayName = "Database Name";
			tooltip = "Name of the Database";
			typeName = "STRING";
			defaultValue = """Very important Database""";
		};
		
		class MACW_DatabaseSize_Edit: Edit
		{
			property = "MACW_DatabaseSize_Edit";
			displayName = "Database size";
			tooltip = "Seconds to hack and download";
			typeName = "NUMBER";
			defaultValue = 60;
		};

		class MACW_DatabaseData_Edit: Edit
		{
			property = "MACW_DatabaseData_Edit";
			control = "EditCodeMulti5";
			displayName = "Database data";
			tooltip = "Data of the database";
			typeName = "STRING";
			defaultValue = """... Database Hash 5rze4f5w3gbsetw35g ...""";
		};
		class ModuleDescription: ModuleDescription{};
	};

	class ModuleDescription: ModuleDescription
	{
		description[] =
		{
			"MACW Add Database. Synchronize to 'AddDevices'."
		};
	};
};