params['_owner', '_computer', '_nameOfVariable', '_subNet'];

private _string = "";
//_string = format ['ListDevicesInSubnet called. _subNet: %1.', _subNet];
//[_string] remoteExec ['systemChat', 0];

private _router = _computer getVariable ['AE3_network_parent', objNull];

private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

{
	if(_x == parseNumber _subNet) then {
		private _subNetDevices = missionNamespace getVariable [format["MACW-Devices-%1", _subNet], []];

		private _allDoors = _subNetDevices select 0;
		private _allLights = _subNetDevices select 1;
		private _allDrones = _subNetDevices select 2;
		private _allDatabases = _subNetDevices select 3;

		//_string = format ["_allDoors: %1.", _allDoors];
		//[_string] remoteExec ["systemChat", 0];
		//_string = format ["_allLights: %1.", _allLights];
		//[_string] remoteExec ["systemChat", 0];
		//_string = format ["_allDrones: %1.", _allDrones];
		//[_string] remoteExec ["systemChat", 0];

		{
			private _building = objectFromNetId (_x select 1);
			private _doorsOfBuilding = _x select 2;
			_string = format ["building: %1.", (_x select 0)];
			[_computer, _string] call AE3_armaos_fnc_shell_stdout;
			{
				private _currentState = _building getVariable [format ['bis_disabled_Door_%1', _x], 5];
				private _currentStateString = "";
				private _currentStateStringColor = "#8ce10b";
				if(_currentState == 1) then {
					_currentStateString = "locked ";
					_currentStateStringColor = "#fa4c58";
				} else {
					_currentStateString = "unlocked ";
				};

				//private _phase = _building animationPhase format["Door_%1", _x];

				private _doorAnim = format ["Door_%1_rot", _x];
				private _phase = _building animationPhase _doorAnim;

				private _phaseString = "";
				private _phaseStringColor = "#8ce10b";
				if(_phase > 0.5) then { //TODO test
					_phaseString = "open";
				} else {
					_phaseString = "closed";
					_phaseStringColor = "#fa4c58";
				};

				//_string = format ["    Door: %1 %2 %3", _x, _currentStateString, _phaseString];
				//[_computer, _string] call AE3_armaos_fnc_shell_stdout;
				_string = format ["    Door: %1 ", _x];
				[_computer, [[_string, [_currentStateString, _currentStateStringColor], [_phaseString, _phaseStringColor]]]] call AE3_armaos_fnc_shell_stdout;
			} forEach _doorsOfBuilding;
		} forEach _allDoors;

		_string = format ["Lights:"];
		if(count _allLights == 0) then {
			_string = _string + " none";
		};
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
		{
			private _lightId = _x select 0;
			private _light = objectFromNetId (_x select 1);
			private _currentState = lightIsOn _light;
			private _currentStateStringColor = "#8ce10b";
			if(_currentState isEqualTo "OFF") then {
				_currentStateStringColor = "#fa4c58 ";
			};
			//_string = format ["    Light: %1 %2", _lightId, _currentState];
			//[_computer, _string] call AE3_armaos_fnc_shell_stdout;
			_string = format ["    Light: %1 ", _lightId];
			[_computer, [[_string, [_currentState, _currentStateStringColor]]]] call AE3_armaos_fnc_shell_stdout;
		} forEach _allLights;

		_string = format ["Drones:"];
		if(count _allDrones == 0) then {
			_string = _string + " none";
		};
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
		{
			private _droneId = _x select 0;
			private _drone = objectFromNetId (_x select 1);
			private _droneName = getText (configFile >> "CfgVehicles" >> typeOf (vehicle _drone) >> "displayName");
			private _droneSide = side _drone;
			private _droneSideString = side _drone;
			private _damage = damage (vehicle _drone);
			private _droneSideColor = "#BCBCBC";
			if(_damage == 1) then {
				_droneSideString = "DEAD";
			};
			if(_droneSide == west) then {
				_droneSideColor = "#008DF8";
			};
			if(_droneSide == east) then {
				_droneSideColor = "#FA4C58";
			};
			if(_droneSide == civilian) then {
				_droneSideColor = "#FFD966";
			};
			if(_droneSide == independent) then {
				_droneSideColor = "#8CE10B";
			};
			//_string = format ["    Drone: %1 '%2' %3", _droneId, _droneSide, _droneName];
			//[_computer, _string] call AE3_armaos_fnc_shell_stdout;
			_string = format ["    Drone: %1 ", _droneId];
			[_computer, [[_string, [format["'%1' ", _droneSideString], _droneSideColor], _droneName]]] call AE3_armaos_fnc_shell_stdout;
		} forEach _allDrones;

		_string = format ["Databases:"];
		if(count _allDatabases == 0) then {
			_string = _string + " none";
		};
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
		{
			private _databaseId = _x select 0;
			private _database = objectFromNetId (_x select 1);
			private _databaseName = _database getVariable ["MACW_DatabaseName_Edit", ""];
			private _databaseSize = _database getVariable ["MACW_DatabaseSize_Edit", ""];
			_string = format ["    Database: %1 %2 size: %3GB", _databaseId, _databaseName, _databaseSize];
			[_computer, _string] call AE3_armaos_fnc_shell_stdout;
		} forEach _allDatabases;

		break;
	};
} forEach _connectedSubnets;

missionNamespace setVariable [_nameOfVariable, true, true];