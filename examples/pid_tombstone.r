# Delete an iRODS data object or collection.
# If collection or data object carry a PID redirect the URL to PID?noredirect and introduce PID entry PID/STATUS = deleted
# Remove all other PID entries related to the iRODS path. 
# Step 1: Get PID
# Step 2  Check whether PID already has entry "IRODS/STATUS == deleted".
# Step 3: Create tombstone in PID entry, redirect URL and remove PID entries related to the iRODS path 
# Step 4: Remove all data objects
# NOTE:Will not remove collections.
# Returns the PID

tombstone {
    msiGetObjType(*path, *objType);
    msiPidGet(*path, *key, *result);
    *error = errorcode(msiPidGet(*path, *key, *result));
    if(*error == 0 && *result == "deleted"){
        failmsg(-1, "Tombstone for *path already created.");
    }    
    

    if(*objType=='-d'){
        *handle = tombstone_for_obj(*path);
        writeLine("stdout", "Deleted *path and updated Handle: *handle");     
    }
    else{
        # remove all data objects
        writeLine("stdout", "TOMBSTONE WARNING: Deleting Objects -------");
        foreach(*row in SELECT COLL_NAME, DATA_NAME WHERE COLL_NAME = '*path' || like '*path/%'){
             *coll = *row.COLL_NAME;
             *data = *row.DATA_NAME;
             msiPidLookup("*coll/*data", *handle);
             tombstone_for_obj("*coll/*data");
             writeLine("stdout", "*handle");
        }
        writeLine("stdout", "TOMBSTONE WARNING: Updating Collections -------");
        #remove all collections
        foreach(*row in SELECT COLL_NAME WHERE COLL_NAME = '*path' || like '*path/%'){
            *coll = *row.COLL_NAME;
            msiPidLookup(*coll, *handle);
            set_tombstone(*coll, *handle);
            writeLine("stdout", "*handle");
        }
        writeLine("stdout", "TOMBSTONE REQUIRED ACTION: 'irm -r *path'");
    }
}

tombstone_for_obj(*path){
    msiPidLookup(*path, *handle); 
    if(*handle!='') {
        set_tombstone(*path, *handle);
    }
    msiDataObjUnlink("*path",*status);        
    *handle
}

set_tombstone(*path, *handle){
    *error = errorcode(msiPidGet(*path, *key, *result));
    if(*error == 0 && *result == "deleted"){
        writeLine("stdout", "TOMBSTONE INFO Tombstone for *path already created.");
    }
    else{
        writeLine("stdout", "Creating tombstone for *path");
        msiPidSet(*path, *key, "deleted", *result);
        msiPidSet(*path, "URL", "http://hdl.handle.net/*handle?noredirect", *result);
        msiPidUnset(*path, "IRODS_WEBDAV_URL", *result);
        msiPidUnset(*path, "IRODS_WEBDAV_PORT", *result);
       writeLine("stdout", "Created tombstone for *result");
    }
}

INPUT *path="/microZone/home/christine/registered/regColl", *key="IRODS/STATUS"
OUTPUT ruleExecOut
