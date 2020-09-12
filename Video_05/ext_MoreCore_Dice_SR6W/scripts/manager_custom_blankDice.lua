---
--- Template by Frostbyte
--- Created by Darris.Martin.
--- DateTime (Original Template): 8/20/2020 11:08 AM
--- This template will change the Total Number
--- https://fantasygroundsunity.atlassian.net/wiki/spaces/FGU/pages/4096100/Developer+Guide
--- <script name="manager_custom_blankDice" file="Copy_Path_From_Current_Root" />
---

-- Global Declarations
local sCmd = "dice_mod";  -- Search ALL for 'dice_mod_update' to find where all to revise to add new dice.
local aContainer = {};

function onInit()    --- *** Choose how you want your dice to display (only one can be toggled ON) ***
--- Toggle ON: If you do NOT want to change the Dice Total.
    CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
    --- Toggle ON: If you WANT to change the Dice Total.
    --CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal);
end

function createHelpMessage()
    local rMessage = ChatManager.createBaseMessage(nil, nil);
    rMessage.text = rMessage.text ..
            "The "..sCmd.." command is create for gameSystem \n".. --- revise "gameSystem" to be the name of the game.
            "It is expecting a parameter of:\n"..
            "(p1)d(p2)x(p3)+/-(n) 'description words' \n"..
            "Example: 5d6x7-3 fire bomb \n"..
            "Parameter Definitions: \n"..
            "(p1): blah \n"..
            "(p2): blah \n"..
            "(p3): blah \n"..
            "(n): bonus modifier\n\n"..

            "*** Special Functionality *** \n"..
            "Mod Stack Keywords:\n"..
            "'keyword:1' - will do action \n\n"..

            "Effect Keywords:\n"..
            "'keyword:1' - will do action\n\n"..

            "*** Additional Notes ***\n"..
            "additionalNotes";
    Comm.deliverChatMessage(rMessage);
end



--Collect Data and Roll Dice
function performAction(draginfo, rActor, sParams)
    Debug.console("*** performAction() ***");
    Debug.console("draginfo: ",draginfo, " rActor: ", rActor, " sParams:", sParams);

    -- performAction() Declarations
    aContainer = {};                --This container is to pass data back and forth across the methods. I unused, remove.

    Debug.console("onInit() aContainer: ",aContainer);

    -- aRoll Setup
    local aRoll = {};                   -- table (array/dictionary) to collect information about the roll.
    aRoll.aDice = {};                   -- table of dice
    aRoll.sType = sCmd;                 -- Dice Names
    aRoll.sDesc = "";                   -- roll Description
    aRoll.nMod = 0;                     -- Modifier (from dice string and Mod Stack)
    --- NOTE: the only array/table that can exist in aRoll is aDice.
    --- All other data must be string, boolean, or number

    --- Choose a Dice parser from Tool Box


    -- Error Check / Help Message
    if(sParams == "" or sParams == "help") then
        createHelpMessage();
    end
    -- Verify the data is correct
    Debug.console("End performAction() aRoll: ", aRoll);
    ActionsManager.performAction(draginfo, rActor, aRoll);
end

function onLanded(rSource, rTarget, rRoll)
    Debug.console("*** onLanded(rSource, rTarget, rRoll) ***");
    Debug.console("rSource: ",rSource);
    Debug.console("rTarget: ",rTarget);
    Debug.console("rRoll: ",rRoll);
    --- Any special functionality (like Explode) goes here.
    --- This happens before dice results are counted.

    -- verify and revise results. (If you just want sum of all dice leave this alone).
    rRoll = getDiceResults(rRoll);
    Debug.console("after getDiceResults() rRoll: ",rRoll);

    -- generate chat window message. (If you want default, leave this alone).
    local aMessage = createChatMessage(rSource, rRoll);

    -- Deliver message to FG.
    Comm.deliverChatMessage(aMessage);
end

function getDiceResults(rRoll)
    Debug.console("*** getDiceResults(rRoll) ***");
    Debug.console("rRoll: ",rRoll);
    --- This will display the sum of all the dice.
    --- To Change the Results,
    --- Toggle the onInit()
    --- Add logic here.
    return rRoll;
end

function createChatMessage(rSource, rRoll)
    local aMessage = ActionsManager.createActionMessage(rSource, rRoll);
    Debug.console("*** createChatMessage(rSource, rRoll) ***");
    Debug.console("aMessage: ",aMessage);
    --- This will display, who rolled, rRoll.sDesc, and the graphic of dice.
    --- to change this untoggle "aMessage.text" below and enter Revised Message.

    --aMessage.text = aMessage.text.."\n\nNew Text Goes Here.";

    --- To change the total display untoggle "aMessage.dicedisplay"
    --- Valid dicedisplay values are 0 = none, 1 = total, 2 = negative, 3 = double, and 4 = half.
    --aMessage.dicedisplay = 1;

    return aMessage;
end


