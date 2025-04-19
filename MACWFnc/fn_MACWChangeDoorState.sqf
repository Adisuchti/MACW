params['_owner', '_computer', '_nameOfVariable', '_subNet', '_buildingId', '_doorId', "_doorDesiredState"];

private _string = "";
private _powerCostPerDoor = 2;

//_string = "ChangeDoorState called.";
//[_string] remoteExec ["systemChat", 0];

private _buildingIdNum = parseNumber _buildingId;
private _doorIdNum = parseNumber _doorId;
private _subNetNum = parseNumber _subNet;
private _battery = uiNamespace getVariable 'AE3_Battery';
private _batteryLevel = _battery getVariable "AE3_power_batteryLevel";

_doorDesiredState = toLower _doorDesiredState;

if(_buildingIdNum != 0 && (_doorIdNum != 0 || _doorId isEqualTo "a") && _subNetNum != 0 && (_doorDesiredState isEqualTo "lock" || _doorDesiredState isEqualTo "unlock")) then {
	private _router = _computer getVariable ['AE3_network_parent', objNull];

	private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

	private _hasSubnetBeenFound = false;
	{
		if(_x == _subNetNum) then {
			private _subNetDevices = missionNamespace getVariable [format["MACW-Devices-%1", _subNetNum], []];

			private _subNetCosts = missionNamespace getVariable [format["MACW-Costs-%1", _subNetNum], []];

			private _powerCostPerDoor = _subNetCosts select 0;

			private _allDoors = _subNetDevices select 0;

			_hasSubnetBeenFound = true;

			if(_doorId isEqualTo "a") then {
				private _countOfChangingDoors = 0;
				{
					private _idOfBuilding = _x select 0;
					if(_idOfBuilding == _buildingIdNum) then {
						private _building = objectFromNetId (_x select 1);
						private _doorsOfBuilding = (_x select 2);
						{ 
							private _currentState = _building getVariable [format ['bis_disabled_Door_%1', _x], 5];
							if(_doorDesiredState isEqualTo "lock" && _currentState != 1) then {
								_countOfChangingDoors = _countOfChangingDoors + 1;
							};
							if(_doorDesiredState isEqualTo "unlocklock" && _currentState != 0) then {
								_countOfChangingDoors = _countOfChangingDoors + 1;
							};
						} foreach _doorsOfBuilding;
					};
				} forEach _allDoors;

				_string = format ['affected doors: %1. power cost: %2W.', _countOfChangingDoors, (_countOfChangingDoors * _powerCostPerDoor)];
				[_computer, _string] call AE3_armaos_fnc_shell_stdout;
				if(_batteryLevel < ((_countOfChangingDoors * _powerCostPerDoor)/1000)) then {
					_string = format ['insufficient power.'];
					[_computer, _string] call AE3_armaos_fnc_shell_stdout;
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

				[_computer, _battery, (_powerCostPerDoor * _countOfChangingDoors)] call compile preprocessFileLineNumbers "MACW\MACWFnc\fn_MACWRemovePower.sqf";
				{
					private _idOfBuilding = _x select 0;
					if(_idOfBuilding == _buildingIdNum) then {
						private _building = objectFromNetId (_x select 1);
						private _doorsOfBuilding = (_x select 2);
						{
							if(_doorDesiredState isEqualTo "lock") then {
								_building setVariable [format ["bis_disabled_Door_%1", _x], 1, true];
							};
							if(_doorDesiredState isEqualTo "unlock") then {
								_building setVariable [format ["bis_disabled_Door_%1", _x], 0, true];
							};
						} foreach _doorsOfBuilding;
					};
				} forEach _allDoors;
			} else {
				{
					private _idOfBuilding = _x select 0;
					if(_idOfBuilding == _buildingIdNum) then {
						private _building = objectFromNetId (_x select 1);
						private _doorsOfBuilding = (_x select 2);
						if(_doorIdNum in _doorsOfBuilding) then {
							private _currentState = _building getVariable [format ['bis_disabled_Door_%1', _doorIdNum], 5];
							if(_doorDesiredState isEqualTo "lock" && _currentState != 1) then {
								_string = format ['power cost: %1Wh.', _powerCostPerDoor];
								[_computer, _string] call AE3_armaos_fnc_shell_stdout;
								if(_batteryLevel < (_powerCostPerDoor/1000)) then {
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
								_building setVariable [format ["bis_disabled_Door_%1", _doorIdNum], 1, true];
								_string = format ["Door locked."];
								[_computer, _string] call AE3_armaos_fnc_shell_stdout;
								[_computer, _battery, _powerCostPerDoor] call compile preprocessFileLineNumbers "MACW\MACWFnc\fn_MACWRemovePower.sqf";
							} else {
								if(_doorDesiredState isEqualTo "lock" && _currentState == 1) then {
									_string = format ["Door already locked."];
									[_computer, _string] call AE3_armaos_fnc_shell_stdout;
								} else {
									if(_doorDesiredState isEqualTo "unlock" && _currentState != 0) then {
										_string = format ['power cost: %1Wh.', _powerCostPerDoor];
										[_computer, _string] call AE3_armaos_fnc_shell_stdout;
										if(_batteryLevel < (_powerCostPerDoor/1000)) then {
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
										_building setVariable [format ["bis_disabled_Door_%1", _doorIdNum], 0, true];
										_string = format ["Door unlocked."];
										[_computer, _string] call AE3_armaos_fnc_shell_stdout;
										[_computer, _battery, _powerCostPerDoor] call compile preprocessFileLineNumbers "MACW\MACWFnc\fn_MACWRemovePower.sqf";
									} else {
										if(_doorDesiredState isEqualTo "unlock" && _currentState == 0) then {
											_string = format ["Door already unlocked."];
											[_computer, _string] call AE3_armaos_fnc_shell_stdout;
										} else {
											_string = format ['Invalid input: %1.', _doorDesiredState];
											[_computer, _string] call AE3_armaos_fnc_shell_stdout;
										};
									};
								};
							};
						} else {
							_string = format ["no such door. building %1, door %2.", _buildingIdNum, _doorIdNum];
							[_computer, _string] call AE3_armaos_fnc_shell_stdout;
						};
					};
				} forEach _allDoors;
			};
			break;
		};
	} forEach _connectedSubnets;
	if(!_hasSubnetBeenFound) then {
		_string = format ['Subnet could not be found: %1.', _subNet];
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
	};
};
if(_buildingIdNum == 0) then {
	_string = format ["Invalid input buildingId: %1.", _buildingId];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};
if(!(_doorIdNum != 0 || _doorId isEqualTo "a")) then {
	_string = format ["Invalid input doorId: %1.", _doorId];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};
if(_subNetNum == 0) then {
	_string = format ["Invalid input subNet: %1.", _subNet];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};
if(!(_doorDesiredState isEqualTo "lock" || _doorDesiredState isEqualTo "unlock")) then {
	_string = format ["Invalid input desiredState: %1.", _doorDesiredState];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};

scopeName "exit";
missionNamespace setVariable [_nameOfVariable, true, true];