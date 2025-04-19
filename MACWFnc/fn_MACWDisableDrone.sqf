params['_owner', '_computer', '_nameOfVariable', '_subNet', '_droneId'];

private _string = "";

//_string = "DisableDrone called.";
//[_string] remoteExec ["systemChat", 0];

private _droneIdNum = parseNumber _droneId;
private _subNetNum = parseNumber _subNet;
private _battery = uiNamespace getVariable 'AE3_Battery';
private _batteryLevel = _battery getVariable "AE3_power_batteryLevel";

if((_droneIdNum != 0 || _droneId isEqualTo "a") && _subNetNum != 0) then {
	private _router = _computer getVariable ['AE3_network_parent', objNull];

	private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

	private _hasSubnetBeenFound = false;
	{
		if(_x == _subNetNum) then {
			private _subNetDevices = missionNamespace getVariable [format["MACW-Devices-%1", _subNetNum], []];

			private _subNetCosts = missionNamespace getVariable [format["MACW-Costs-%1", _subNetNum], []];

			private _powerCostPerDrone = _subNetCosts select 2;

			private _allDrones = _subNetDevices select 2;

			_hasSubnetBeenFound = true;

			if(_droneId isEqualTo "a") then {
				private _countOfChangingDrones = 0;
				{
					private _drone = objectFromNetId (_x select 1);
					private _currentState = side _drone;
					_countOfChangingDrones = _countOfChangingDrones + 1; //TODO filter out already disabled
				} forEach _allDrones;

				_string = format ['affected drones: %1. power cost: %2Wh.', _countOfChangingDrones, (_countOfChangingDrones * _powerCostPerDrone)];
				[_computer, _string] call AE3_armaos_fnc_shell_stdout;
				if(_batteryLevel < ((_countOfChangingDrones * _powerCostPerDrone)/1000)) then {
					_string = format ['insufficient power.'];
					[_computer, _string] call AE3_armaos_fnc_shell_stdout;
					missionNamespace setVariable [_nameOfVariable, true, true];
					breakTo "exit";
				};
				_string = format ['are you sure? (y/n)'];
				[_computer, _string] call AE3_armaos_fnc_shell_stdout;
				while{true} do {
					private _areYouSure = [_computer] call AE3_armaos_fnc_shell_stdin;
					if(_areYouSure isEqualTo "y") then {
						break;
					};
					if(_areYouSure isEqualTo "n") then {
						missionNamespace setVariable [_nameOfVariable, true, true];
						breakTo "exit";
					};
				};

				[_computer, _battery, (_powerCostPerDrone * _countOfChangingDrones)] call compile preprocessFileLineNumbers "MACW\MACWFnc\fn_MACWRemovePower.sqf";
				{
					private _drone = objectFromNetId (_x select 1);
					//[_drone, true, true] call BIN_fnc_empVehicle;
					(vehicle _drone) setDamage 1;
				} forEach _allDrones;
			} else {
				{
					private _idOfDrone = _x select 0;
					if(_idOfDrone == _droneIdNum) then {
						private _drone = objectFromNetId (_x select 1);
						private _currentState = side _drone;
						_string = format ['power cost: %1Wh.', _powerCostPerDrone];
						[_computer, _string] call AE3_armaos_fnc_shell_stdout;
						if(_batteryLevel < (_powerCostPerDrone/1000)) then {
							_string = format ['insufficient power.'];
							[_computer, _string] call AE3_armaos_fnc_shell_stdout;
							missionNamespace setVariable [_nameOfVariable, true, true];
							breakTo "exit";
						};
						_string = format ['are you sure? (y/n)'];
						[_computer, _string] call AE3_armaos_fnc_shell_stdout;
						while{true} do {
							private _areYouSure = [_computer] call AE3_armaos_fnc_shell_stdin;
							if(_areYouSure isEqualTo "y") then {
								break;
							};
							if(_areYouSure isEqualTo "n") then {
								missionNamespace setVariable [_nameOfVariable, true, true];
								breakTo "exit";
							};
						};
						//[_drone, true, true] call BIN_fnc_empVehicle;
						(vehicle _drone) setDamage 1;
						_string = format ["Drone disabled."];
						[_computer, _string] call AE3_armaos_fnc_shell_stdout;
						[_computer, _battery, _powerCostPerDrone] call compile preprocessFileLineNumbers "MACW\MACWFnc\fn_MACWRemovePower.sqf";
					};
				} forEach _allDrones;
			};
			break;
		};
	} forEach _connectedSubnets;
	if(!_hasSubnetBeenFound) then {
		_string = format ['Subnet could not be found: %1.', _subNet];
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
	};
};
if(!(_droneIdNum != 0 || _droneId isEqualTo "a")) then {
	_string = format ["Invalid input droneId: %1.", _droneId];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};
if(_subNetNum == 0) then {
	_string = format ["Invalid input subNet: %1.", _subNet];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};

scopeName "exit";

missionNamespace setVariable [_nameOfVariable, true, true];