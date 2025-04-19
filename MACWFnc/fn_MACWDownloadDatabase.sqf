params['_owner', '_computer', '_nameOfVariable', '_subNet', '_databaseId'];

private _string = "";

//_string = "DownloadDatabase called.";
//[_string] remoteExec ["systemChat", 0];

private _databaseIdNum = parseNumber _databaseId;
private _subNetNum = parseNumber _subNet;

if(_databaseIdNum != 0 && _subNetNum != 0) then {
	private _router = _computer getVariable ['AE3_network_parent', objNull];
	private _pointer = _computer getVariable "AE3_filepointer";

	//_string = format ['_pointer: %1.', _pointer];
	//[_string] remoteExec ["systemChat", 0];

	private _connectedSubnets = _router getVariable ["MACW-Connected-Subnets", []];

	private _hasSubnetBeenFound = false;
	{
		if(_x == _subNetNum) then {

			_hasSubnetBeenFound = true;

			private _subNetDevices = missionNamespace getVariable [format["MACW-Devices-%1", _subNetNum], []];
			private _allDatabases = _subNetDevices select 3;
			{
				private _idOfDatabase = _x select 0;
				private _DatabaseNetId = _x select 1;

				if(_databaseIdNum == _idOfDatabase) then {
					private _database = objectFromNetId _DatabaseNetId;
					private _databaseName = _database getVariable ["MACW_DatabaseName_Edit", ""];
					private _databaseSize = _database getVariable ["MACW_DatabaseSize_Edit", ""];
					private _databaseContent = _database getVariable ["MACW_DatabaseData_Edit", ""];

					private _paddingZeroes = "0000000000";
					private _formatTotalLength = 3;

					private _loadingBar1 = "#"; // "█" "█"
					private _loadingBar2 = "."; // "░"
					private _loadingBarLength = 25;

					for "_i" from 1 to _databaseSize do {
						private _percentage = ceil((100/ _databaseSize) * _i);

						private _formattedStringOfPercentage =  (_paddingZeroes select [0, (_formatTotalLength - (count (str _percentage)))]) + (str _percentage);

						private _filledCount = round (_loadingBarLength/100*_percentage);
						private _emptyCount = _loadingBarLength - _filledCount;

						private _filledPart = "";
						private _emptyPart = "";
						for "_i" from 1 to _filledCount do {
							_filledPart = _filledPart + _loadingBar1;
						};
						for "_i" from 1 to _emptyCount do {
							_emptyPart = _emptyPart + _loadingBar2;
						};

						private _loadingBar = _filledPart + _emptyPart;

						_string = format ['Downloading Database: %1%%. [%2]', _formattedStringOfPercentage, _loadingBar]; //TODO maybe clear console so you dont see 14 babillion loading bards at the end
						[_computer, _string] call AE3_armaos_fnc_shell_stdout;

						private _currentRouter = _computer getVariable ['AE3_network_parent', objNull];
						if(_currentRouter != _router) then {
							_string = 'Download canceled. Connection lost.';
							[_computer, _string] call AE3_armaos_fnc_shell_stdout;
							missionNamespace setVariable [_nameOfVariable, true, true];
							breakTo "exit";
						};

						sleep 1;
					};
					private _fileName = (_databaseName splitString " ") joinString "_";

					private _newDirectory = (_pointer joinString "/") + format["/Downloads/%1-%2.txt", _databaseId, _fileName];

					_string = format ["Saving data to: '%1'.", _newDirectory];
					[_computer, _string] call AE3_armaos_fnc_shell_stdout;

					[_computer, _newDirectory, _databaseContent, false, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;
				};
			} forEach _allDatabases;
			break;
		};
	} forEach _connectedSubnets;
	if(!_hasSubnetBeenFound) then {
		_string = format ['Subnet could not be found: %1.', _subNet];
		[_computer, _string] call AE3_armaos_fnc_shell_stdout;
	};
};
if(_databaseIdNum == 0) then {
	_string = format ['Invalid input databaseId: %1.', _databaseId];
	[_computer, _string] call AE3_armaos_fnc_shell_stdout;
};

scopeName "exit";

missionNamespace setVariable [_nameOfVariable, true, true];