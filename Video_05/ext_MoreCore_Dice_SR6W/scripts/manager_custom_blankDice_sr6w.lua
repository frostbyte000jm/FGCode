---
--- Template by Frostbyte
--- Created by Darris.Martin.
--- DateTime (Original Template): 8/20/2020 11:08 AM
--- This template will change the Total Number
--- https://fantasygroundsunity.atlassian.net/wiki/spaces/FGU/pages/4096100/Developer+Guide
--- <script name="manager_custom_blankDice" file="Copy_Path_From_Current_Root" />
---

-- Global Declarations
local sCmd = "sr6w";  -- Search ALL for 'dice_mod_update' to find where all to revise to add new dice.
local aContainer = {};
local aPriorRoll = {}; -- This is needed for Exploding Dice

function onInit()    --- *** Choose how you want your dice to display (only one can be toggled ON) ***
--- Toggle ON: If you do NOT want to change the Dice Total.
--    CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
    --- Toggle ON: If you WANT to change the Dice Total.
    CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal);
end

function createHelpMessage()
    local rMessage = ChatManager.createBaseMessage(nil, nil);
    rMessage.text = rMessage.text ..
            "The "..sCmd.." command is create for ShadowRun6W \n".. --- revise "gameSystem" to be the name of the game.
            "It is expecting a parameter of:\n"..
            "(p1)h(p2) \n"..
            "Example: 2h3 \n"..
            "Parameter Definitions: \n"..
            "(p1): Additional Dice \n"..
            "(p2): Auto Hits \n\n"..

            "*** Special Functionality *** \n"..
            "Mod Stack Keywords:\n"..
            "'CapHits' - Will add a notification that the equipment has a Damage Cap \n\n"..

            "Effect Keywords:\n"..
            "'explode:n' - n and higher on dice will explode\n"..
            "'glitch:n' - n and lower on dice will count towards glitch\n\n"..

            "*** Additional Notes ***\n"..
            "This dice system uses the ModStack to count number of dice.\n"..
            "Add Attributes, Skills, and other Mods as '/mod (p1)', then create a roll of '/sr6w (p1)h(p2)"..
            "this will be the final click to roll dice.";
    Comm.deliverChatMessage(rMessage);
end



--Collect Data and Roll Dice
function performAction(draginfo, rActor, sParams)
    Debug.console("*** performAction() ***");
    Debug.console("draginfo: ",draginfo, " rActor: ", rActor, " sParams:", sParams);

    -- Error Check / Help Message
    if(sParams == "" or sParams == "help") then
        Debug.console("Error Check: ", sParams);
        createHelpMessage();
        return;
    end

    -- This is to fix a bug where someone spams the die rolling.
    if aContainer.bRollin then
        return;
    end

    -- performAction() Declarations
    aContainer = {};                --This container is to pass data back and forth across the methods. I unused, remove.
    aContainer.bRollin = true;      -- This is to fix a bug where someone spams the die rolling.
    aContainer.nDiceTotalValue = 0;
    aContainer.nCapHits = nil;
    aContainer.nExplodeValue = 0;
    aContainer.nGlitchValue = 1;
    aContainer.bCritGlitch = false;
    aContainer.bGlitch = false;
    aContainer.bAddGlitchEffectFailed = false;
        -- For Exploding Dice
    aPriorRoll = {};                    -- Clear prior rolls
    aPriorRoll.aDice = {};              -- Clear and initiate aDice.

    Debug.console("onInit() aContainer: ",aContainer);

    -- aRoll Setup
    local aRoll = {};                   -- table (array/dictionary) to collect information about the roll.
    aRoll.aDice = {};                   -- table of dice
    aRoll.sDiceSides = "d6";            -- dice sides
    aRoll.sType = sCmd;                 -- Dice Names
    aRoll.sDesc = "";                   -- roll Description
    aRoll.nMod = 0;                     -- Modifier (from dice string and Mod Stack)
    --- NOTE: the only array/table that can exist in aRoll is aDice.
    --- All other data must be string, boolean, or number



    --- Choose a Dice parser from Tool Box
    local sDiceNum, sAutoHits = string.match(sParams, "(%d+)h(%d+)");
    aContainer.nDiceTotalValue = tonumber(sAutoHits);
    local nDiceNum = tonumber(sDiceNum);
    Debug.console("nDiceNum: ",nDiceNum);
    for i = 1, nDiceNum do
        table.insert(aRoll.aDice,aRoll.sDiceSides);
    end

    --- Modifier Stack (This will need the splitMod() function below)
    local sStackDesc, nStackMod = ModifierStack.getStack(true);
    local aModStackDescriptions = splitMod(sStackDesc);
    Debug.console("aModStackDescriptions: ",aModStackDescriptions," nStackMod: ",nStackMod);

    local nCount = 0;
    local bonusDice = 0;
    for sMod_Desc, nMod_Value in pairs(aModStackDescriptions) do
        Debug.console("sMod_Desc: ",sMod_Desc,"nMod_Value: ",nMod_Value);
        if string.match(sMod_Desc, "CapHits") then  --- Update Keyword here
            if aContainer.nCapHits == nil then
                aContainer.nCapHits = nMod_Value;
            else
                aContainer.nCapHits = math.min(aContainer.nCapHits,nMod_Value);
            end
        else
            bonusDice = bonusDice + nMod_Value;
            --- This wasn't in the video, but thought it was needed. 
            local _,sMod_DescRevised = string.match(sMod_Desc,"(%d+)[_](.*)")
            Debug.console("sMod_DescRevised: ",sMod_DescRevised);
            if(nCount == 0) then
                aRoll.sDesc = aRoll.sDesc .. sMod_DescRevised;
            else
                aRoll.sDesc = aRoll.sDesc .. " + " ..sMod_DescRevised;
            end
            nCount = nCount + 1;
        end
    end
    -- Build Dice Pool
    for i = 1, bonusDice do
        table.insert(aRoll.aDice, aRoll.sDiceSides);
    end

    -- Pull data from Effects
    local nodeActorCombatTracker = DB.findNode(rActor.sCTNode);         -- Combat Tracker Actor Node
    local nCount = 0;
    for _,nodeActorEffects in pairs(nodeActorCombatTracker.getChild("effects").getChildren()) do
        Debug.console("nodeActorEffects: ",nodeActorEffects.getChildren());
        local sLabel = nodeActorEffects.getChild("label").getValue();
        if string.match(sLabel,"explode:") then                     --- Update KeyWord
            local _,sValue = string.match(sLabel,"[:](%s*)(%d+)");
            Debug.console("sLabel: ",sLabel,"nValue: ",sValue);
            aContainer.nExplodeValue = tonumber(sValue);
            DB.deleteNode(nodeActorEffects);
        elseif string.match(sLabel,"glitch:") then
            local _,sValue = string.match(sLabel,"[:](%s*)(%d+)");
            Debug.console("sLabel: ",sLabel,"nValue: ",sValue);
            aContainer.nGlitchValue = tonumber(sValue);
            DB.deleteNode(nodeActorEffects);
        end
        nCount = nCount + 1;
    end



    -- Verify the data is correct
    Debug.console("End performAction() aRoll: ", aRoll);
    Debug.console("End performAction() aContainer: ", aContainer);
    ActionsManager.performAction(draginfo, rActor, aRoll);
end

function onLanded(rSource, rTarget, rRoll)
    Debug.console("*** onLanded(rSource, rTarget, rRoll) ***");
    Debug.console("rSource: ",rSource);
    Debug.console("rTarget: ",rTarget);
    Debug.console("rRoll: ",rRoll);
    Debug.console("aContainer: ",aContainer);
    --- Any special functionality (like Explode) goes here.
    --- This happens before dice results are counted.

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
            Debug.console("Error from FG: nResult: ",nResult, " aContainer.nExplodeValue: ",aContainer.nExplodeValue);
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

    -- verify and revise results. (If you just want sum of all dice leave this alone).
    rRoll = getDiceResults(rRoll);
    Debug.console("after getDiceResults() rRoll: ",rRoll);

    if aContainer.bGlitch or aContainer.bCritGlitch then  --- Set Condition to add effect
    local nodeActorCombatTracker = DB.findNode(rSource.sCTNode);         -- Combat Tracker Actor Node
        local nodeActorEffect = nodeActorCombatTracker.getChild("effects").createChild();
        Debug.console("nodeActorEffect: ",nodeActorEffect.getChildren());
        if nodeActorEffect.getChild("label") then
            if aContainer.bGlitch then
                nodeActorEffect.getChild("label").setValue("Glitch Alert!!!");
            elseif aContainer.bCritGlitch then
                nodeActorEffect.getChild("label").setValue("Crit Glitch Alert!!!");
            end
        else
            DB.deleteNode(nodeActorEffect);
            aContainer.bAddGlitchEffectFailed = true;
        end
    end

    -- generate chat window message. (If you want default, leave this alone).
    local aMessage = createChatMessage(rSource, rRoll);

    -- Deliver message to FG.
    Comm.deliverChatMessage(aMessage);
    aContainer.bRollin = false;
end

function getDiceResults(rRoll)
    Debug.console("*** getDiceResults(rRoll) ***");
    Debug.console("rRoll: ",rRoll);
    --- This will display the sum of all the dice.
    --- To Change the Results,
    --- Toggle the onInit()
    --- Add logic here.

    local nCrits = 0;
    local nDiceCount = 0;


    for _,aDice in ipairs(rRoll.aDice) do
        Debug.console("aDice: ",aDice);
        local nResult = tonumber(aDice["result"]);
        local sType = aDice["type"];
        Debug.console("nResult: ",nResult,"sType: ",sType);

        if nResult >=5 then
            aContainer.nDiceTotalValue = aContainer.nDiceTotalValue + 1;
        elseif nResult <= aContainer.nGlitchValue then
            nCrits = nCrits + 1;
        end

        nDiceCount = nDiceCount + 1;

        Debug.console("aContainer.nMyTotal: ",aContainer.nDiceTotalValue);
    end

    Debug.console("Where is the problem: nCrits: ",nCrits,"nDiceCount: ",nDiceCount);
    if nCrits > nDiceCount/2 then
        if aContainer.nDiceTotalValue == 0 then
            aContainer.bCritGlitch = true;
        else
            aContainer.bGlitch = true;
        end
    end

    Debug.console("End getDiceResults() aContainer: ",aContainer);
    return rRoll;
end

function onDiceTotal()
    return true, aContainer.nDiceTotalValue;
end

function createChatMessage(rSource, rRoll)
    local aMessage = ActionsManager.createActionMessage(rSource, rRoll);
    Debug.console("*** createChatMessage(rSource, rRoll) ***");
    Debug.console("aMessage: ",aMessage);
    --- This will display, who rolled, rRoll.sDesc, and the graphic of dice.
    --- to change this untoggle "aMessage.text" below and enter Revised Message.

    local sCapText = "";
    local sGlitchText = "";
    if aContainer.nCapHits then
        sCapText = "Damage Cap: "..aContainer.nCapHits.."\n";
    end

    Debug.console("Create Crit Message: ", aContainer);
    if aContainer.bCritGlitch then
        sGlitchText = "Critical Glitch Alert!!!";
    elseif aContainer.bGlitch then
        sGlitchText = "Glitch Alert!!!";
    end

    if aContainer.bAddGlitchEffectFailed then
        sGlitchText = sGlitchText.."\nEffect not added to Combat Tracker.\n"..
        "Please open Combat Tacker and add Effect.";
    end

    aMessage.text = aMessage.text.."\n\n "..
    sCapText..
    sGlitchText;


    --- To change the total display untoggle "aMessage.dicedisplay"
    --- Valid dicedisplay values are 0 = none, 1 = total, 2 = negative, 3 = double, and 4 = half.
    --aMessage.dicedisplay = 1;

    return aMessage;
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
