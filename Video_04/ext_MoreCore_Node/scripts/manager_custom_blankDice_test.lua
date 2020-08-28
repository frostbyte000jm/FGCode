---
--- Template by Frostbyte
--- Created by Darris.Martin.
--- DateTime (Original Template): 8/24/2020 5:03 PM
---
--- This template is to test string.match() commands
---

local sCmd = "dice_test";

function onInit()
    CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal);
end

--Collect Data and Roll Dice
function performAction(draginfo, rActor, sParams)

    Debug.console("Yep! I loaded correctly!!!")

--[[
Read input
Patterns:
    ([+-]?%d+)  | needs potential + and - numbers
    (%d+)       | digit
    %s          | Space
    %s*         | No Space
    (%w+)       | word
    .           | Any Character
    (.*)        | Any Character or No Characters
    [a-z]       | that character. "(%d+)f(%d+)" will grab the number before and after "f"

What does your dice String look like?
    3d6+2  \  4d8+9  \  5d4  \  3d8+2d12+7
    Use:
    local sDiceString, sDescription = string.match(sParams, "%s*(%S+)%s*(.*)");
    local aDice, nMod = StringManager.convertStringToDice(sDiceString);
    Debug.console("aDice: ",aDice,"| nMod: ",nMod, "| sDescription: ",sDescription);

]]
end