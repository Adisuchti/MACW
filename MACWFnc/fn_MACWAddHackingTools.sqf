private ["_logic"];

waitUntil {time > 0};

private _string = "";

//_string = format ["adding porgramms..."];
//[_string] remoteExec ["systemChat", 0];

private _module = _this select 0;
_syncedObjects = synchronizedObjects _module;

{
    //_string = format ["synced object: %1", typeOf _x];
    //[_string] remoteExec ["systemChat", 0];

    if(typeOf _x in ["Land_Laptop_03_olive_F_AE3", "Land_Laptop_03_sand_F_AE3", "Land_Laptop_03_black_F_AE3", "Land_USB_Dongle_01_F_AE3"]) then {
        //_string = format ["adding hacking tools to laptop..."];
        //[_string] remoteExec ["systemChat", 0];

        private _computerNetIdString = str (netId _x);

        // [_object, _path, _content, _isCode, _owner, _permissions, _isEncrypted, _encryptionAlgorithm, _encryptionKey] call AE3_filesystem_fnc_device_addFile;
        // https://github.com/y0014984/Advanced-Equipment/blob/master/addons/filesystem/functions/fnc_module_addFile.sqf

        _content = "Table of content:
-List-Subnets : List all subnets to which the router the computer is connected to has access.
-List-Devices 'subnet' : Lists all Devices connected to a subnet.
-Door 'subnet' 'Door Id (Id or 'a' for all) ' 'locked/unlocked' : locks and unlocks doors. this can also lock doors open.
-Light 'subnet' 'Light Id (Id or 'a' for all)' 'off/on' : turns lights off or on.
-Change-Drone 'subnet' 'Drone Id (Id or 'a' for all)' 'side (west/east/guer/civ)' : switches side of a drone or turret.
-Disable-Drone 'subnet' 'Drone Id (Id or 'a' for all)': Disables drones or turrets.
-Download-Database 'subnet' 'Database Id' : Downloads the Database into the folder 'HAckingTools/Downloads'.";
        [_x, "/HackingTools/Guide", _content, false, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        private _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false],
                    ['path', 'subnet', true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _subNet = (_ae3OptsThings select 0);

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-List-Devices-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable, _subNet] remoteExec ['MACW_fnc_MACWListDevicesInSubnet', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/List-Devices", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;
    

        _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false],
                    ['path', 'subnet', true, false],
                    ['path', 'buildingId', true, false],
                    ['path', 'doorId', true, false],
                    ['path', 'state', true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _subNet = (_ae3OptsThings select 0);
            private _buildingId = (_ae3OptsThings select 1);
            private _doorId = (_ae3OptsThings select 2);
            private _desiredState = (_ae3OptsThings select 3);

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-Door-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable, _subNet, _buildingId, _doorId, _desiredState] remoteExec ['MACW_fnc_MACWChangeDoorState', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/Door", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false],
                    ['path', 'subnet', true, false],
                    ['path', 'lightId', true, false],
                    ['path', 'state', true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _subNet = (_ae3OptsThings select 0);
            private _lightId = (_ae3OptsThings select 1);
            private _desiredState = (_ae3OptsThings select 2);

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-Light-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable, _subNet, _lightId, _desiredState] remoteExec ['MACW_fnc_MACWChangeLightState', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/Light", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-List-Subnets-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable] remoteExec ['MACW_fnc_MACWListSubnets', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/List-Subnets", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false],
                    ['path', 'subnet', true, false],
                    ['path', 'droneId', true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _subNet = (_ae3OptsThings select 0);
            private _droneId = (_ae3OptsThings select 1);

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-Disable-Drone>-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable, _subNet, _droneId] remoteExec ['MACW_fnc_MACWDisableDrone', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/Disable-Drone", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false],
                    ['path', 'subnet', true, false],
                    ['path', 'droneId', true, false],
                    ['path', 'faction', true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _subNet = (_ae3OptsThings select 0);
            private _droneId = (_ae3OptsThings select 1);
            private _desiredState = (_ae3OptsThings select 2);

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-Change-Drone-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable, _subNet, _droneId, _desiredState] remoteExec ['MACW_fnc_MACWChangeDroneFaction', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/Change-Drone", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        _content = "
            params['_computer', '_options', '_commandName'];

            private _commandOpts = [];
            private _commandSyntax =
            [
                [
                    ['command', _commandName, true, false],
                    ['path', 'subnet', true, false],
                    ['path', 'databaseId', true, false]
                ]
            ];
            private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

            [] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

            if (!_ae3OptsSuccess) exitWith {};

            private _subNet = (_ae3OptsThings select 0);
            private _databaseId = (_ae3OptsThings select 1);

            private _owner = clientOwner;

            private _nameOfVariable = 'MACW-Download-Database-' + "+ _computerNetIdString +";

            missionNamespace setVariable [_nameOfVariable, false, true];
            [_owner, _computer, _nameOfVariable, _subNet, _databaseId] remoteExec ['MACW_fnc_MACWDownloadDatabase', 2];
            waitUntil { missionNamespace getVariable [_nameOfVariable, false] };
        ";
        [_x, "/HackingTools/Download-Database", _content, true, "root", [[true, true, true], [true, true, true]], false, "caesar", "1"] call AE3_filesystem_fnc_device_addFile;


        //_x setVariable [format ['bis_disabled_Door_' + _doorId], 1, true]
    };
} forEach _syncedObjects;