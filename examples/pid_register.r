# Register an iRODS data object or collection
# Step 1: validate that iRODS path lies in iRODS zone
# Step 2: check whether iRODS path is already registered
# Step 3: register iRODS path
# Step 4: create iRODS metadata entry with PID, default metadata key 'IRODS/PID'
# Returns the PID 

register {
    if (errorcode(msiObjStat(*path, *StatusObj)) < 0) {
        failmsg(-1, "*path unknown, no PID created.");
    }
    msiPidLookup(*path, *handle);
    if(*handle=='') {
        writeLine("stdout", "No existing handle, creating handle");
        msiPidCreate(*path, *handle);
    }
    else {
        writeLine("stdout", "Handle already existed: *handle");
    }
    writeLine("stdout", "Creating AVU: *key: *handle");
    createAVU(*key, *handle, *path);
    *handle
}

createAVU(*key, *value, *path) {
   #Creates a key-value pair and attaches it to a data object or collection
   msiAddKeyVal(*Keyval,*key, *value);
   writeKeyValPairs("stdout", *Keyval, " is : ");
   msiGetObjType(*path,*objType);
   msiSetKeyValuePairsToObj(*Keyval, *path, *objType);
}

INPUT *path="/microZone/home/christine/test.txt"
INPUT *key="IRODS/PID"
OUTPUT ruleExecOut

