params['_owner', '_computer', '_nameOfVariable', '_subNet', '_lightId', "_lightState"];

private _string = "";

//_string = "ChangeLightState called.";
//[_string] remoteExec ["systemChat", 0];

private _lightIdNum = parseNumber _lightId;
private _subNetNum = parseNumber _subNet;

_lightState = toLower _lightState;

if((_lightIdNum != 0 || _lightId isEqualTo "a") && _subNetNum != 0 && (_lightState isEqualTo "on" || _lightState isEqualTo "off")) then {
	private _router = _computer getVariable ['AE3_network_parent', objNull];

	private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

	private _hasSubnetBeenFound = false;
	{
		if(_x == _subNetNum) then {

			_hasSubnetBeenFound = true;

			private _subNetDevices = missionNamespace getVariable [format["MACW-Devices-%1", _subNetNum], []];
			private _allLights = _subNetDevices select 1;

			if(_lightId isEqualTo "a") then {
				{
					private _idOfLight = _x select 0;
					private _lightNetId = _x select 1;
					private _light = objectFromNetId _lightNetId;
					if(_lightState isEqualTo "on") then {
						_light switchLight "ON";
					};
					if(_lightState isEqualTo "off") then {
						_light switchLight "OFF";
					};
				} forEach _allLights;
			} else {
				{
					private _idOfLight = _x select 0;
					private _lightNetId = _x select 1;
					private _light = objectFromNetId _lightNetId;
					if(_lightIdNum == _idOfLight) then {
						private _battery = uiNamespace getVariable 'AE3_Battery';
						private _currentState = lightIsOn _light;
						if(_lightState isEqualTo "on" && _currentState != "ON") then {
							_light switchLight "ON";
							_string = format ["Light turned on."];
							[_computer, _string] call AE3_armaos_fnc_shell_stdout;
						} else {
							if(_lightState isEqualTo "on" && _currentState == "ON") then {
								_string = format ["Light already on."];
								[_computer, _string] call AE3_armaos_fnc_shell_stdout;
							} else {
								if(_lightState isEqualTo "off" && _currentState != "OFF") then {
									_light switchLight "OFF";
									_string = format ["Light turned off."];
									[_computer, _string] call AE3_armaos_fnc_shell_stdout;
								} else {
									if(_lightState isEqualTo "off" && _currentState == "OFF") then {
										_string = format ["Light already off."];
										[_computer, _string] call AE3_armaos_fnc_shell_stdout;
									} else {
										_string = format ['Invalid input: %1.', _lightState];
										[_computer, _string] call AE3_armaos_fnc_shell_stdout;
									};
								};
							};
						};
					};
				} forEach _allLights;
			};
			break;
		};
	} forEach _connectedSubnets;
	if(!_hasSubnetBeenFound) then {
		_string = format ['Subnet could not be found: %1.', _subNet];
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
	};
};
if(!(_lightIdNum != 0 || _lightId isEqualTo "a")) then {
	_string = format ['Invalid input lightId: %1.', _lightId];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};
if(!(_lightState isEqualTo "on" || _lightState isEqualTo "off")) then {
	_string = format ['Invalid input lightState: %1.', _lightState];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};
if(!(_lightState isEqualTo "on" || _lightState isEqualTo "off")) then {
	_string = format ['Invalid input lightState: %1.', _lightState];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};

missionNamespace setVariable [_nameOfVariable, true, true];