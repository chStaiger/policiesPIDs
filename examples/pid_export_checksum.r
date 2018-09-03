# Export iRODS checksum to Handle system, recalculate checksum in iRODS if 'update' is set to 'true'
# Step 1: Check if path corresponds to object
# Step 2: Fetch PID
# Step 3: Fetch checksum
# Step 4: If checksum is empty or 'update' is 'true', calculate one
# Step 5: create iRODS metadata entry with PID, default metadata key 'IRODS/CHECKSUM'

export_checksum {
    
    msiGetObjType(*path,*objType);
    if(*objType=='-c'){
        failmsg(-1, "Provided path leads to collection: *path; Expected data object.")
    }
    writeLine("stdout", "*objType");
    msiPidLookup(*path, *handle);
    if(*handle==''){
        failmsg(-1, "Data is not registered: *path")
    }
    # get collname and dataname from *path
    msiSplitPath(*path, *coll, *data)
    foreach(*row in SELECT DATA_CHECKSUM WHERE DATA_NAME like '*data' and COLL_NAME like '*coll'){
        *chksum = *row.DATA_CHECKSUM;
                
        if(*chksum=='' || *update=='true'){
             writeLine("stdout", "Calculate checksum.")
             msiDataObjChksum(*path,"forceChksum=",*chksum);
        }
        msiPidSet(*path, *key, *chksum, *result);
        writeLine("stdout", "Updated handle: *result");
    }  
}

INPUT *path="/microZone/home/christine/test.txt", *key="IRODS/CHECKSUM", *update="true"
OUTPUT ruleExecOut
