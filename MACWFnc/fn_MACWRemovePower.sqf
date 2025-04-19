params['_computer', '_battery', '_changeWh'];

private _batteryLevel = _battery getVariable "AE3_power_batteryLevel";

private _string = "";
//_string = format ['_currentLevel: %1', _batteryLevel];
//[_string] remoteExec ['systemChat', 0];

private _newLevel = _batteryLevel - (_changeWh/1000);

_battery setVariable ["AE3_power_batteryLevel", _newLevel];

_string = format ['power cost: %1Wh', _changeWh];
[_computer, _string] call AE3_armaos_fnc_shell_stdout;

_string = format ['new power level: %1Wh', _newLevel*1000];
[_computer, _string] call AE3_armaos_fnc_shell_stdout;