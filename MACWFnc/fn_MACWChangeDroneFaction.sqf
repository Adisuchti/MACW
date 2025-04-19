params['_owner', '_computer', '_nameOfVariable', '_subNet', '_droneId', "_droneFaction"];

private _string = "";

//_string = "ChangeDroneFaction called.";
//[_string] remoteExec ["systemChat", 0];

private _droneIdNum = parseNumber _droneId;
private _subNetNum = parseNumber _subNet;
private _battery = uiNamespace getVariable 'AE3_Battery';
private _batteryLevel = _battery getVariable "AE3_power_batteryLevel";

_droneFaction = toLower _droneFaction;

if((_droneIdNum != 0 || _droneId isEqualTo "a") && _subNetNum != 0 && (_droneFaction isEqualTo "west" || _droneFaction isEqualTo "east" || _droneFaction isEqualTo "guer" || _droneFaction isEqualTo "civ")) then {
	private _router = _computer getVariable ['AE3_network_parent', objNull];

	private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

	private _hasSubnetBeenFound = false;

	private _side = west;

	if(_droneFaction isEqualTo "west") then {
		_side = west;
	};
	if(_droneFaction isEqualTo "east") then {
		_side = east;
	};
	if(_droneFaction isEqualTo "guer") then {
		_side = independent;
	};
	if(_droneFaction isEqualTo "civ") then {
		_side = civilian;
	};
	{
		if(_x == _subNetNum) then {
			private _subNetDevices = missionNamespace getVariable [format["MACW-Devices-%1", _subNetNum], []];

			private _subNetCosts = missionNamespace getVariable [format["MACW-Costs-%1", _subNetNum], []];

			private _powerCostPerDrone = _subNetCosts select 1;

			private _allDrones = _subNetDevices select 2;

			_hasSubnetBeenFound = true;

			if(_droneId isEqualTo "a") then {
				private _countOfChangingDrones = 0;
				{
					private _drone = objectFromNetId (_x select 1);
					private _currentState = side _drone;
					if(!(_side isEqualTo _currentState)) then {
						_countOfChangingDrones = _countOfChangingDrones + 1;
					};
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
					private _drone = _x select 0;
					private _newGroup = createGroup _side; //TODO why this not work aaaaa
					[_drone] joinSilent _newGroup;
				} forEach _allDrones;
			} else {
				{
					private _idOfDrone = _x select 0;
					if(_idOfDrone == _droneIdNum) then {
						private _drone = objectFromNetId (_x select 1);
						private _currentState = side _drone;
						if(!(_side isEqualTo _currentState)) then {
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
							private _newGroup = createGroup _side;
							[_drone] joinSilent _newGroup;
							_string = format ["Drone side changed."];
							[_computer, _string] call AE3_armaos_fnc_shell_stdout;
							[_computer, _battery, _powerCostPerDrone] call compile preprocessFileLineNumbers "MACW\MACWFnc\fn_MACWRemovePower.sqf";
						} else {
							_string = format ["Drone already of side %1.", _droneFaction];
							[_computer, _string] call AE3_armaos_fnc_shell_stdout;
						};
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
if(!((_droneFaction isEqualTo "west" || _droneFaction isEqualTo "east" || _droneFaction isEqualTo "guer" || _droneFaction isEqualTo "civ"))) then {
	_string = format ["Invalid input droneFaction: %1.", _droneFaction];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};

scopeName "exit";

missionNamespace setVariable [_nameOfVariable, true, true];