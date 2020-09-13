---
--- Template by Frostbyte
--- Created by James Martin.
--- DateTime: 8/29/2020 5:42 PM
---

--- Declarations (These are for Toolbox Setup)
local aRoll = {};
local rRoll = {};
local aContainer = {};
local sParams = "";

function onInit() --- Just housing everything in onInit(). Do not use this file.

--- *** Dice String Parsing ***

    --- Dice Setup 1: When your dice looks traditional
    --- 3d6+2  \  4d8+9  \  5d4  \  3d8+2d12+7
    ---
    local sDiceString, sDescription = string.match(sParams, "%s*(%S+)%s*(.*)");
    aRoll.sDesc = sDescription;
    aRoll.aDice, aRoll.nMod = StringManager.convertStringToDice(sDiceString);

    --- Dice Setup 2: When your dice string looks different
    --- 3s4f5  \  2d6x7  \  4d8f1s2p3+7
    --- Names Needed:
    ---     sDiceNum:   | This is how many dice will roll.
    ---     sDiceSides: | d4, d6, d8 ...
    ---     These can be defined in the string.match() or in another location.
    --- Patterns:
    ---     ([+-]?%d+)  | needs potential + and - numbers
    ---     (%d+)       | digit
    ---     (%s)        | Space
    ---     (%s*)       | No Space
    ---     (%w+)       | word
    ---     .           | Any Character
    ---     (.*)        | Any Character or No Characters
    ---
    local sValue1, sDiceNum, sDiceSides, sDescription = string.match(sParams, "(%d+)x(%d+)y(%d+)%s(.*)");
    aRoll.sDiceSides = "d"..sDiceSides;
    local nDiceNum = tonumber(sDiceNum);
    for i = 1, nDiceNum do
        table.insert(aRoll.aDice,aRoll.sDiceSides);
    end

--- *** ModifierStack ***

    --- Modifier Stack (This will need the splitMod() function below)
    local sStackDesc, nStackMod = ModifierStack.getStack(true);
    local aModStackDescriptions = splitMod(sStackDesc);
    Debug.console("aModStackDescriptions: ",aModStackDescriptions," nStackMod: ",nStackMod);

    --- to Use Mod Stack to add to dice pool
    local bonusDice = 0;
    for sMod_Desc, nMod_Value in pairs(aModStackDescriptions) do
        Debug.console("sMod_Desc: ",sMod_Desc,"nMod_Value: ",nMod_Value);
        bonusDice = bonusDice + nMod_Value;
    end
        -- Build Dice Pool
    for i = 1, bonusDice do
        table.insert(aRoll.aDice, aRoll.sDiceSides);
    end

    --- to Use Mod Stack to add to dice pool, BUT also grab keyword values from Stack.
    local bonusDice = 0;
    for sMod_Desc, nMod_Value in pairs(aModStackDescriptions) do
        Debug.console("sMod_Desc: ",sMod_Desc,"nMod_Value: ",nMod_Value);
        if string.match(sMod_Desc, "keyWord") then  --- Update Keyword here
            aContainer.nKeyWord = nMod_Value                --- Store Keyword here.
        else
            bonusDice = bonusDice + nMod_Value;
        end
    end
        -- Build Dice Pool
    for i = 1, bonusDice do
        table.insert(aRoll.aDice, aRoll.sDiceSides);
    end

--- ***  Nodes needed to pull data from Character Sheet or Combat Tracker ***
    --- *** Choose one of these Nodes ***
    local nodeActorCharacterSheet = DB.findNode(rActor.sCreatureNode);  -- Character Sheet Node
    local nodeActorCombatTracker = DB.findNode(rActor.sCTNode);         -- Combat Tracker Actor Node
    -- replace rActor with rSource if using in onLanded

    --- Pull Data from Effects
    --- I like to use keyWord:n where n is a number. Searching for "keyword:" makes an easy way to search through
    ---   the effect list.
    -- *********************  Place Node Here  *********************
    local nCount = 0;
    for _,nodeActorEffects in pairs(nodeActorCombatTracker.getChild("effects").getChildren()) do
        Debug.console("nodeActorEffects: ",nodeActorEffects.getChildren());
        local sLabel = nodeActorEffects.getChild("label").getValue();
        if string.match(sLabel,"KeyWord:") then                     --- Update KeyWord
            local _,sValue = string.match(sLabel,"[:](%s*)(%d+)");
            Debug.console("sLabel: ",sLabel,"nValue: ",sValue);
            aContainer.nKeyWord = tonumber(sValue);                         --- Revise nKeyWord
            DB.deleteNode(nodeActorEffects); --- Should the Effect be removed once used? Remove if No.
        end
        nCount = nCount + 1;
    end

    --- Delete a Node from Effects
    -- *********************  Place Node Here  *********************
    for _,nodeActorEffects in pairs(nodeActorCombatTracker.getChild("effects").getChildren()) do
        Debug.console("nodeActorEffects: ",nodeActorEffects..getChildren());
        if false then                       --- Add condition to delete
            DB.deleteNode(nodeActorEffects);
        end
    end

    --- Add a Node to Effects
    if false then  --- Set Condition to add effect
        -- *********************  Place Node Here  *********************
        local nodeActorEffect = nodeActorCombatTracker.getChild("effects").createChild();
        Debug.console("nodeActorEffect: ",nodeActorEffect.getChildren());
        if nodeActorEffect.getChild("label") then
            nodeActorEffect.getChild("label").setValue("New Label");   --- Add label
        else
            DB.deleteNode(nodeActorEffect);
        end
    end

--- *** Exploding Dice ***
    --- Add to Global Declarations
    local aPriorRoll = {}; -- This is needed for Exploding Dice

    --- Add to function performAction() Declarations
    aPriorRoll = {};                    -- Clear prior rolls
    aPriorRoll.aDice = {};              -- Clear and initiate aDice.
    aContainer.nExplodeValue = 0;       --- Value when dice explode. If <2 Dice will not explode.

    --- Exploding functionality add to onLanded()
    if aContainer.nExplodeValue > 1 then -- >1 because if 1 it will be continuous
        local bDoReRoll = false;
        -- establish aRoll (this is where the new roll will be stored)
        local aRoll = {};                           -- table (array/dictionary) to collect information about the roll.
        aRoll.aDice = {};                           -- table of dice
        aRoll.sType = rRoll.sType;                  -- Dice Names
        aRoll.sDesc = rRoll.sDesc;                  -- roll Description
        aRoll.nMod = tonumber(rRoll.nMod);          -- Modifier (from dice string and Mod Stack)
        -- Do not add to aRoll

        -- Load current roll into Prior roll and if any explode add dice to aRoll.
        for _, aDice in pairs(rRoll.aDice) do
            local nResult = aDice.result;
            if nResult == nil then
                break;
            end

            -- load last roll into aPriorRoll
            table.insert(aPriorRoll.aDice, aDice);

            -- If condition met, add red dice to aRoll.
            if nResult >= aContainer.nExplodeValue then
                bDoReRoll = true;
                table.insert(aRoll.aDice, "d1006"); --- Set proper explode dice here.
            end
        end

        -- If explode happens, do new roll.
        if(bDoReRoll) then
            ActionsManager.performAction(nil, nil, aRoll);
            return; --- This kills any future action. Removing this will show ALL rolls on the chat window.
        end

        -- Clear current roll aDice
        rRoll.aDice = {};
        -- load current rRoll with all prior rolls.
        for _, aDice in ipairs(aPriorRoll.aDice) do
            table.insert(rRoll.aDice, aDice);
        end

        -- Verify final output.
        Debug.console("Final rRoll: ", rRoll);
    end
    --- End Explode

--- *** Revise Dice Total ***
--- Add to performAction() Declarations
    aContainer.nResultTotal = 0;

    -- add to getDiceResults(rRoll)
    for _,aDice in ipairs(rRoll.aDice) do
        Debug.console("aDice: ",aDice);
        local nResult = tonumber(aDice["result"]);
        local sType = aDice["type"];
        Debug.console("nResult: ",nResult,"sType: ",sType);

        aContainer.nResultTotal = aContainer.nResultTotal + nResult;    --- Add Logic here

        Debug.console("aContainer.nMyTotal: ",aContainer.nResultTotal);
    end
    --- must include Function onDiceTotal()

end

--- *****  Additional Functions  *****

--- For Revising Total Field (Add to Bottom)
function onDiceTotal()
    return true, aContainer.nResultTotal;
end

--- splitMod method will return array of each ModifierStack input.
function splitMod(sStackDesc)
    --declarations
    local objProp = {};
    local nCount = 0;
    local labelSave = "";

    --Split string
    Debug.console("sStackDesc: ",sStackDesc);
    for value in string.gmatch(sStackDesc, "[+-]?%w+") do --[+-]?%w+
        Debug.console("value: ",value);
        local sNumTest = string.match(value,"([+-]?%d+)");
        if sNumTest == nil then
            if labelSave == "" then
                labelSave = value;
            else
                labelSave = labelSave .. " " .. value;
            end
        else
            if labelSave == "" then
                labelSave = "NoLabel";
            end
            objProp[nCount.."_"..labelSave] = tonumber(value);
            labelSave = "";
            nCount = nCount + 1;
        end
    end
    Debug.console("objProp: ",objProp);
    return objProp;
end
