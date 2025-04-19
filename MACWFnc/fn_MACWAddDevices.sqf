private ["_logic"];

private _module = _this select 0;
private _center = getPos _module;

private _string = "";
//_string = format ["starting adding doors, pos: %1", _center];
//[_string] remoteExec ["systemChat", 0];

private _allDoors = [];
private _allLamps = [];
private _allDrones = [];
private _allDatabases = [];

private _syncedTriggers = synchronizedObjects _module select { _x isKindOf "EmptyDetector" }; 
private _allObjects = createHashMap;
{
    private _trigger = _x;
    private _pos = getPosATL _trigger;
    private _sizeX = triggerArea _trigger select 0;
    private _sizeY = triggerArea _trigger select 1;
    private _angle = triggerArea _trigger select 2;
    private _isRectangle = triggerArea _trigger select 3;

    private _objectsInTrigger = [];
    private _entitiesInTrigger = [];

    if (_isRectangle) then {
        _objectsInTrigger = nearestObjects [_pos, [], (_sizeX max _sizeY)];
        {
            if (_x inArea [_pos, _sizeX, _sizeY, _angle, _isRectangle]) then {
                _allObjects set [str _x, _x];
            };
        } forEach _objectsInTrigger;
        _entitiesInTrigger = _pos nearEntities (_sizeX max _sizeY);
        {
            if (_x inArea [_pos, _sizeX, _sizeY, _angle, _isRectangle]) then {
                _allObjects set [str _x, _x];
            };
        } forEach _entitiesInTrigger;
    } else {
        _objectsInTrigger = nearestObjects [_pos, [], _sizeX];
        { _allObjects set [str _x, _x]; } forEach _objectsInTrigger;

        _entitiesInTrigger = _pos nearEntities (_sizeX max _sizeY);
        { _allObjects set [str _x, _x]; } forEach _entitiesInTrigger;
    };
} forEach _syncedTriggers;
private _uniqueObjects = values _allObjects;

//_string = format ["count _uniqueObjects: %1", count _uniqueObjects];
//[_string] remoteExec ["systemChat", 0];

private _buildings = _uniqueObjects select {_x isKindOf "House" || _x isKindOf "Building"};
private _lamps = _uniqueObjects select {_x isKindOf "Lamps_base_F"};
private _drones = _uniqueObjects select {unitIsUAV _x};


private _listOfSubNets = missionNamespace getVariable [format["MACW-Subnets"], []];
private _id = 0;
while {true} do {
    _id = (round (random 89999)) + 10000;
    private _isNew = true;
    {
        if(_x select 0 == _id) then {
            _isNew = false;
        };
    } forEach _listOfSubNets;

    if(_isNew) then {
        break;
    };
};
_listOfSubNets pushback [_id, _buildings];
missionNamespace setVariable [format["MACW-Subnets"], _listOfSubNets, true];

{
    private _buildingDoors = [];

    private _building = _x;
    private _config = configFile >> "CfgVehicles" >> typeOf _building;

    private _simpleObjects = getArray (_config >> "SimpleObject" >> "animate");
    {
        if(count _x == 2) then {
            private _objectName = _x select 0;
            if(_objectName regexMatch "door_.*") then {
                private _regexFinds = _objectName regexFind ["door_([0-9]+)"];
                private _doorNumber = parseNumber (((_regexFinds select 0) select 1) select 0);

                if(!(_doorNumber in _buildingDoors)) then {
                    if(count _buildingDoors == 0) then {
                        _buildingDoors pushback _doorNumber;
                    };
                    if((_buildingDoors select ((count _buildingDoors) -1)) != _doorNumber) then {
                        _buildingDoors pushback _doorNumber;
                    };
                };
            };
        };
    } forEach _simpleObjects;

    if(count _buildingDoors > 0) then {
        private _buildingNetId = netId _building;

        private _buildingId = 0;
        while {true} do {
            _buildingId = (round (random 8999)) + 1000;
            private _buildingIsNew = true;
            {
                if(_x select 0 == _buildingId) then {
                    _buildingIsNew = false;
                };
            } forEach _allDoors;

            if(_buildingIsNew) then {
                break;
            };
        };

        _allDoors pushback [_buildingId, _buildingNetId, _buildingDoors];
    };

} forEach _buildings;

for "_i" from 0 to ((count _lamps) - 1) do {
    _allLamps pushback [_i + 1, netId (_lamps select _i)];
};

{
    private _droneId = 0;
    while {true} do {
        _droneId = (round (random 8999)) + 1000;
        private _droneIsNew = true;
        {
            if(_x select 0 == _droneId) then {
                _droneIsNew = false;
            };
        } forEach _allDrones;

        if(_droneIsNew) then {
            break;
        };
    };

    _allDrones pushback [_droneId, netId _x];
} forEach _drones;

private _syncedDatabases = synchronizedObjects _module select { _x isKindOf "MACW_ModuleAddDatabase" };
{
    private _databaseId = 0;
    while {true} do {
        _databaseId = (round (random 8999)) + 1000;
        private _databaseIsNew = true;
        {
            if(_x select 0 == _databaseId) then {
                _databaseIsNew = false;
            };
        } forEach _allDatabases;

        if(_databaseIsNew) then {
            break;
        };
    };

    _allDatabases pushback [_databaseId, netId _x];
} forEach _syncedDatabases;


missionNamespace setVariable [format["MACW-Devices-%1", _id], [_allDoors, _allLamps, _allDrones, _allDatabases], true];

private _doorCost = _module getVariable ["MACW_Hack_Door_Cost_Edit", ""];
private _droneSideCost = _module getVariable ["MACW_Hack_Drone_Side_Cost_Edit", ""];
private _droneDestructionCost = _module getVariable ["MACW_Hack_Drone_Disable_Cost_Edit", ""];

missionNamespace setVariable [format["MACW-Costs-%1", _id], [_doorCost, _droneSideCost, _droneDestructionCost], true];

//_string = format ["_allDoors: %1.", _allDoors];
//[_string] remoteExec ["systemChat", 0];
//_string = format ["_allLamps: %1.", _allLamps];
//[_string] remoteExec ["systemChat", 0];
//_string = format ["_allDrones: %1.", _allDrones];
//[_string] remoteExec ["systemChat", 0];

//_string = format ["count _buildings: %1.", count _buildings];
//[_string] remoteExec ["systemChat", 0];
//_string = format ["count _lamps: %1.", count _lamps];
//[_string] remoteExec ["systemChat", 0];
//_string = format ["count _drones: %1.", count _drones];
//[_string] remoteExec ["systemChat", 0];

_syncedObjects = synchronizedObjects _module;

{
    //_string = format ["type of synced object: %1.", typeOf _x];
    //[_string] remoteExec ["systemChat", 0];
    private _syncedNetId = netId _x;

    private _connectedSubnets = _x getVariable ["MACW-Connected-Subnets", []];
    _connectedSubnets pushback _id;
    _x setVariable ["MACW-Connected-Subnets", _connectedSubnets, true];
} forEach _syncedObjects;