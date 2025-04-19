params['_owner', '_computer', '_nameOfVariable'];

private _string = "";
//_string = format ['ListSubnets called.'];
//[_string] remoteExec ['systemChat', 0];

private _router = _computer getVariable ['AE3_network_parent', objNull];

private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

{
	//_string = format ['connected Device: %1.', _x];
	//[_string] remoteExec ['systemChat', 0];

	_string = str _x;
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
} forEach _connectedSubnets;

if(count _connectedSubnets == 0) then {
	_string = "none";
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};

missionNamespace setVariable [_nameOfVariable, true, true];