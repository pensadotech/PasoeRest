// Example Java Script logic to consume a PASOE REST webService 
// to returive Global Variables

// URL 
let configVarGrpsUrl = `http://localhost:8810/rest/LithosAppService/configvars/Groups`
let configVarsUrl = `http://localhost:8810/rest/LithosAppService/configvars`
let configVarUrl = `http://localhost:8810/rest/LithosAppService/configvar`

// Variables 
let filterGrp = ''
let selectedGroup = 'ALL GROUPS'
let updateMode = false
let updatedId = 0
let configVarsInMemory = ''

// Initialization ............................................
GetConfigVariables()

// Functions .......................................................
function GetConfigVariables() {
    
    // Get all groups
    GetAllVarGroups(configVarGrpsUrl)
    
    // Get all records
    GetAllVariables(configVarsUrl)
}

function GetAllVarGroups(url) {
   
    console.log('GetAllVarGroups')
    console.log('url:', url)

    fetch(url, {
        method: 'GET', // implicit 
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        }
    })
    .then(function (response) {
        // Parse response 
        return response.json();
    })
    .then(function (data) {
        console.log(data)
        // Get the array coming in the response
        let configVars = data.response.coreConfigTable.coreConfigTable
        // Send the array to the selector in the screen
        RenderSelector(configVars)
    })
}

function GetAllVariables(url) {

    console.log('GetAllVariables')
    console.log('url:', url)

    // url example: http://localhost:8810/rest/LithosAppService/configvars

    fetch(url, {
        method: 'GET', // implicit 
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        }
    })
        .then(function (response) {
            // Parse response 
            return response.json();
        })
        .then(function (data) {
            console.group(data)
            // Get the array coming in the response
            let configVars = data.response.coreConfigTable.coreConfigTable
            // Store resuls in memory
            configVarsInMemory = configVars
            // Send the array for display
            ChangeDropSelection(selectedGroup)
        })

}

function GetAllVariablesByGroup(url,filterOpt) {

    // This is an exaple getting a group of global variables not used in this example
    console.log('GetAllVariablesByGroup')
    console.log('Filter:', filterOpt)

    // Build URL
    // Example: http://localhost:8810/rest/LithosAppService/configvars?cfgGrp=TSTGRP01
    url += '?cfgGrp=' + filterOpt

    console.log('url:', url)

    fetch(url, {
        method: 'GET', // implicit 
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        }
    })
        .then(function (response) {
            // Parse response 
            return response.json();
        })
        .then(function (data) {
            // Get the array coming in the response
            let globalVars = data.response.coreConfigTable.coreConfigTable
            // Send the array for display
            RenderTable(globalVars)
        })
}

function DeleteVariableyById(url, uniqueid) {

    console.log('DeleteVariableyById')
    console.log('uniqueid:', uniqueid)

    // Build URL
    // example: http://localhost:8810/rest/LithosAppService/configvar/117
    url += '/' + uniqueid

    console.log('url:', url)

    fetch(url, {
        method: 'DELETE',
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        }
    })
        .then(function (response) {
            // Parse response 
            return response.json();
        })
        .then(function (data) {
            
            console.group(data)
            console.group('Delete sucess:', data.response.sucess)
            
            if (data.response.sucess) {
               GetConfigVariables()
            }
            else {
                alert("Unable to delete the variable!");
            }
        })
}

function GetOneVariable(url, uniqueid) {

    // This is an example how to get a single config variable by ID not used this example
    console.log('GetOneVariable')
    console.log('uniqueid:', uniqueid)

    // Build URL
    // example: hhttp://localhost:8810/rest/CrsAppService/globalvar/175106/175366
    url += '/' + uniqueid

    fetch(url, {
        method: 'GET', // implicit 
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        }
    })
        .then(function (response) {
            // Parse response 
            return response.json();
        })
        .then(function (data) {

            console.log(data)

            // todo
        })
}

function CreateOneVariable(url, cfgGrp, cfgSgrp, keyName, keyValue,keynotes) {

    var newConfVarObj = {
        "request": {
            "cfgGrp": cfgGrp,
            "cfgSgrp": cfgSgrp,
            "keyName": keyName,
            "keyValue": keyValue,
            "keyNotes": keynotes
        }
    }

    console.log('CreateOneVariable')
    console.log('url:', url)
    console.log('Obj:', newConfVarObj)
    console.log('strfy:', JSON.stringify(newConfVarObj))

    // Example Url: http://localhost:8810/rest/LithosAppService/configvar

    fetch(url, {
        method: 'POST',
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(newConfVarObj)
    })
        .then(function (response) {
            // Parse response 
            return response.json();
        })
        .then(function (data) {

            console.group(data)
            console.group('Create sucess:', data.response.sucess)

            if (data.response.sucess) {
               GetConfigVariables()
            }
            else {
                alert("Unable to Create the variable!");
            }
        })
}

function UpdateOneVariable(url, uniqueid, CfgGrp, CfgSgrp, KeyName, KeyValue,keynotes) {
    
    console.log('UpdateOneVariable')
    console.log('uniqueid',uniqueid)

    var cfgvarSetObj = {
        "request": {
            "coreConfigSet": {
                "updtCoreConfigTable": [
                    {
                        "CfgGrp": CfgGrp,
                        "CfgSgrp":CfgSgrp,
                        "KeyName": KeyName,
                        "KeyValue": KeyValue,
                        "Notes": keynotes
                    }
                ]
            }
        }
    }

    // Build URL 
    // Example: http://localhost:8810/rest/LithosAppService/configvar/117
    url += '/' + uniqueid

    console.log('UpdateOneVariable')
    console.log('url:', url)
    console.log('Obj:', cfgvarSetObj)
    console.log('strfy:', JSON.stringify(cfgvarSetObj))

    fetch(url, {
        method: 'PUT',
        headers: {
            'application': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(cfgvarSetObj)
    })
        .then(function (response) {
            // Parse response 
            return response.json();
        })
        .then(function (data) {

            console.group(data)
            console.group('update sucess:', data.response.sucess)

            if (data.response.sucess) {
                GetConfigVariables()
            }
            else {
                alert("Unable to Create the variable!");
            }
        })
}

// Render the group selector at screen 
function RenderSelector(configVars) {

    console.log('RenderSelector')
    console.log(configVars.length)
    //console.log(configVars)

    // Clear previous selection entries
    document.getElementById('dropdownselector').innerHTML = ''

    // Capture length of teh array
    let arrayCount = configVars.length
    // Initialize dropdown
    let dropHtml = `<a class="dropdown-item" href="#" onclick="ChangeDropSelection('ALL GROUPS')">AllGroups</a>`
    
    // Add each collected record into the selector 
    // Note: each entry has a unique group, as that is the response from API
    for (let i = 0; i < arrayCount; i++) {
         // get entry 
        let cfgvar = configVars[i]
        let confGrp = cfgvar.CfgGrp.toUpperCase()
        //Create a new dropdown entry option
        dropHtml += `<a class="dropdown-item" href="#" onclick="ChangeDropSelection('${confGrp}')">${confGrp}</a>`
    }

    // add all options to dropdown
    document.getElementById('dropdownselector').innerHTML = dropHtml
}

// Render table in teh screen 
function RenderTable(configVars) {

    console.log('RenderTable')
    console.log(configVars.length)

    // Clear previous entries
    document.getElementById('dynamic-tbl-data').innerHTML = '';
    // Capture length of teh array
    let arrayCount = configVars.length

    // Loop every element in the array
    for (let i = 0; i < arrayCount; i++) {
        // get entry 
        let cfgvar = configVars[i]
      
        // create a new table row
        let tblRow = document.createElement('tr');

        // Delete Button
        let tblCellDelBtn = tblRow.appendChild(document.createElement('td'));
        tblCellDelBtn.innerHTML = `
        <button class="btn btn-primary rowBtn" data-toggle="tooltip" title="Delete" 
           onclick="DeleteVariable('${cfgvar.uniqueId}')">
         <i class="fas fa-calendar-times"></i>
       </button>
       `
        // update button
        let tblCellUpdBtn = tblRow.appendChild(document.createElement('td'));
        tblCellUpdBtn.innerHTML = `
         <button class="btn btn-primary rowBtn" data-toggle="tooltip" title="Edit" 
          onclick="UpdateVariable('${cfgvar.uniqueId}')">
          <i class="fas fa-edit"></i>
          </button>
        `
        //Group
        let tblCellGrp = tblRow.appendChild(document.createElement('td'));
        tblCellGrp.innerHTML = cfgvar.CfgGrp;
        //Subgroup
        let tblCellSgrp = tblRow.appendChild(document.createElement('td'));
        tblCellSgrp.innerHTML = cfgvar.CfgSgrp;
        //Key Name
        let tblCellKeyName = tblRow.appendChild(document.createElement('td'));
        tblCellKeyName.innerHTML = cfgvar.KeyName;
        //Key Value
        let tblCellKeyValue = tblRow.appendChild(document.createElement('td'));
        tblCellKeyValue.innerHTML = cfgvar.KeyValue;

        // Append card to div
        document.getElementById('dynamic-tbl-data').appendChild(tblRow);
    }
}

// Events .....................................................
function ChangeDropSelection(selection){
    
    // chnage dropdown selector base on incoming selection
    document.getElementById("dropdownMenuLink").innerHTML = selection   
    // Remmeber selected group 
    selectedGroup = selection
    let targetCfgVars = ''

    // Base on screen selection, render after filter is applied
    if (selection === 'ALL GROUPS') {
       targetCfgVars = configVarsInMemory
    }
    else
    {
        targetCfgVars = FindRecordsByGrpInMemory(selection)
    }

    // Send target array to the display
    RenderTable(targetCfgVars)
}

function CancleSumbitVariable () {

    // Control default behavior for "submit" button
    event.preventDefault();

    // reset collapsible panel
    ClearCollapsePanel()

    // Collpase the panel 
    var collapseButton = document.getElementById("addButton")
    collapseButton.click()

}

function SubmitVariable() {

    // Control default behavior for "submit" button
    event.preventDefault();

    console.log('SubmitVariable')
    console.log('updateMode', updateMode)
    console.log('updatedId',updatedId)

    // reset possible errors
    document.getElementById("grpErr").innerHTML = ''
    document.getElementById("sgrpErr").innerHTML = ''
    document.getElementById("keynameErr").innerHTML = ''
    document.getElementById("keyvalErr").innerHTML = ''

    // Retreive data from screen
    let cfgGrp = document.getElementById("tgrp").value.trim()
    let cfgSgrp = document.getElementById("tsgrp").value.trim()
    let keyName = document.getElementById("tkeyname").value.trim()
    let keyValue = document.getElementById("tkeyvalue").value.trim()
    let keyNotes = document.getElementById("tnotes").value.trim()

    if (!updateMode) {
        document.getElementById("tgrp").disabled = false
        document.getElementById("tsgrp").disabled = false
        document.getElementById("tkeyname").disabled = false
    }
    else {
        document.getElementById("tgrp").disabled = true
        document.getElementById("tsgrp").disabled = true
        document.getElementById("tkeyname").disabled = true
    }

    let errFound = false;

    if (cfgGrp === '') {
        document.getElementById("grpErr").innerHTML = ' - Missing data';
        errFound = true;
    }

    if (cfgSgrp === '') {
        document.getElementById("sgrpErr").innerHTML = ' - Missing data';
        errFound = true;
    }

    if (keyName === '') {
        document.getElementById("keynameErr").innerHTML = ' - Missing data';
        errFound = true;
    }

    if (keyValue === '') {
        document.getElementById("keyvalErr").innerHTML = ' - Missing data';
        errFound = true;
    }

    if (!errFound) {

        if (!updateMode) {
            // create new variable
            CreateOneVariable(configVarUrl, cfgGrp, cfgSgrp, keyName, keyValue, keyNotes)
        }
        else {
            // Update teh record
            UpdateOneVariable(configVarUrl, updatedId, cfgGrp,  cfgSgrp, keyName, keyValue, keyNotes)
        }

        // Indicate that is an update
        updateMode = false

       // Collpase the panel 
       var collapseButton = document.getElementById("addButton")
       collapseButton.click()
    }

}

function DeleteVariable(uiqueid) {

    console.log('DeleteVariable')
    console.log('uiqueid:', uiqueid)

    let res = confirm("Delete Variable?");

    if (res == true) {
        DeleteVariableyById(configVarUrl, uiqueid)
    }

}

function UpdateVariable(uniqueId) {

    console.log('UpdateVariable')
    console.log('uiqueid:', uniqueId)

    // Open panel
    var addButton = document.getElementById("addButton");
    addButton.click();

     // remember unique id for the record
     updatedId = uniqueId
     console.log('uiqueid:', updatedId)

    // Indicate that is an update
    updateMode = true

    // Find variable in memory 
    let cfgvar = FindOneRecordInMemory(updatedId)
    console.log('cfgvar:', cfgvar)

    // Populate data
    document.getElementById("tgrp").value = cfgvar.CfgGrp
    document.getElementById("tsgrp").value = cfgvar.CfgcSgrp
    document.getElementById("tkeyname").value = cfgvar.KeyName
    document.getElementById("tkeyvalue").value = cfgvar.KeyValue
    document.getElementById("tnotes").value = cfgvar.Notes

    // Disable key elements, leaving only teh variable value editable
    document.getElementById("tgrp").disabled = true
    document.getElementById("tsgrp").disabled = true
    document.getElementById("tkeyname").disabled = true
}

function ClearCollapsePanel() {

    console.log('ClearCollapsePanel')

     // reset  errors
     document.getElementById("grpErr").innerHTML = '';
     document.getElementById("sgrpErr").innerHTML = '';
     document.getElementById("keynameErr").innerHTML = '';
     document.getElementById("keyvalErr").innerHTML = '';

     if (selectedGroup === 'ALL GROUPS') {
        document.getElementById("tgrp").value = ''
     } else {
        document.getElementById("tgrp").value = selectedGroup
     }

    // Clears all of the values
    document.getElementById("tsgrp").value = ''
    document.getElementById("tkeyname").value = ''
    document.getElementById("tkeyvalue").value = ''
    document.getElementById("tnotes").value = ''
    
    // enable every field
    document.getElementById("tgrp").disabled = false
    document.getElementById("tsgrp").disabled = false
    document.getElementById("tkeyname").disabled = false
    document.getElementById("tkeyvalue").disabled = false
    document.getElementById("tnotes").disbaled = false

    // resete update mode condition
    updateMode = false
}

function FindOneRecordInMemory(uniqueId) {

    let rcdFound = ''
    
    configVarsInMemory.forEach(cfgvar => {
        if (cfgvar.uniqueId == uniqueId) {
            rcdFound =  cfgvar
        }
    })
    
    return rcdFound
}

function FindRecordsByGrpInMemory(tgtGroup){

    let grpArr = []

    configVarsInMemory.forEach(cfgvar => {
       if(cfgvar.CfgGrp == tgtGroup) {
         grpArr.push(cfgvar) 
       }
     })

     return grpArr
}