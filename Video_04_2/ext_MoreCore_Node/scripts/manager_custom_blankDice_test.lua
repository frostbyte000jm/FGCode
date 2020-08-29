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

    local dice_simple = "5d10";
    local dice_wMod = "5d10+7";
    local dice_wWords = "5d10+7 Hey Mate";
    local dice_complex = "5d10+4d6+8 Tough";

    Debug.console("*** dice_simple ***");
    Debug.console("%d+",string.match(dice_simple, "%d+"));
    Debug.console("(%d+)d(%d+)",string.match(dice_simple, "(%d+)d(%d+)"));
    Debug.console("(%d+)d(%d+)%s*(%d+)",string.match(dice_simple, "(%d+)d(%d+)%s*(%d+)"));
    Debug.console("(%d+)d(%d+)%s*([+-]?%d+)",string.match(dice_simple, "(%d+)d(%d+)%s*([+-]?%d+)"));
    Debug.console("(%d+)d(%d+)%s*([+-]?%d+)%s(.*)",string.match(dice_simple, "(%d+)d(%d+)%s*([+-]?%d+)%s(.*)"));
    Debug.console("(%d+)e(%d+)",string.match(dice_simple, "(%d+)e(%d+)"));
    Debug.console("(%d+).(%d+)",string.match(dice_simple, "(%d+).(%d+)"));
    Debug.console("%w+",string.match(dice_simple, "%w+"));
    Debug.console("(%w+)%s(%w+)",string.match(dice_simple, "(%w+)%s(%w+)"));
    Debug.console(" ");
    Debug.console(" ");
    Debug.console("*** dice_wMod ***");
    Debug.console("%d+",string.match(dice_wMod, "%d+"));
    Debug.console("(%d+)d(%d+)",string.match(dice_wMod, "(%d+)d(%d+)"));
    Debug.console("(%d+)d(%d+)%s*(%d+)",string.match(dice_wMod, "(%d+)d(%d+)%s*(%d+)"));
    Debug.console("(%d+)d(%d+)%s*([+-]?%d+)",string.match(dice_wMod, "(%d+)d(%d+)%s*([+-]?%d+)"));
    Debug.console("(%d+)d(%d+)%s*([+-]?%d+)%s(.*)",string.match(dice_wMod, "(%d+)d(%d+)%s*([+-]?%d+)%s(.*)"));
    Debug.console("(%d+)e(%d+)",string.match(dice_wMod, "(%d+)e(%d+)"));
    Debug.console("(%d+).(%d+)",string.match(dice_wMod, "(%d+).(%d+)"));
    Debug.console("%w+",string.match(dice_wMod, "%w+"));
    Debug.console("(%w+)%s(%w+)",string.match(dice_wMod, "(%w+)%s(%w+)"));
    Debug.console(" ");
    Debug.console(" ");
    Debug.console("*** dice_wWords ***");
    Debug.console("%d+",string.match(dice_wWords, "%d+"));
    Debug.console("(%d+)d(%d+)",string.match(dice_wWords, "(%d+)d(%d+)"));
    Debug.console("(%d+)d(%d+)%s*(%d+)",string.match(dice_wWords, "(%d+)d(%d+)%s*(%d+)"));
    Debug.console("(%d+)d(%d+)%s*([+-]?%d+)",string.match(dice_wWords, "(%d+)d(%d+)%s*([+-]?%d+)"));
    Debug.console("(%d+)d(%d+)%s*([+-]?%d+)%s(.*)",string.match(dice_wWords, "(%d+)d(%d+)%s*([+-]?%d+)%s(.*)"));
    Debug.console("(%d+)e(%d+)",string.match(dice_wWords, "(%d+)e(%d+)"));
    Debug.console("(%d+).(%d+)",string.match(dice_wWords, "(%d+).(%d+)"));
    Debug.console("%w+",string.match(dice_wWords, "%w+"));
    Debug.console("(%w+)%s(%w+)",string.match(dice_wWords, "(%w+)%s(%w+)"));

    Debug.console(" ");
    Debug.console(" ");
    Debug.console("*** dice_wWords using %s*(%S+)%s*(.*) ***");
    local sDiceCode, sDescCode = string.match(dice_wWords, "%s*(%S+)%s*(.*)");
    Debug.console("sDiceCode: ",sDiceCode,"| sDescCode: ",sDescCode);
    local aDiceCode, nModCode = StringManager.convertStringToDice(sDiceCode);
    Debug.console("aDiceCode: ",aDiceCode,"| nModCode: ",nModCode);
    Debug.console(" ");
    Debug.console(" ");
    Debug.console("*** dice_wWords using %s*(%S+)%s*(.*) ***");
    local sDiceCode, sDescCode = string.match(dice_complex, "%s*(%S+)%s*(.*)");
    Debug.console("sDiceCode: ",sDiceCode,"| sDescCode: ",sDescCode);
    local aDiceCode, nModCode = StringManager.convertStringToDice(sDiceCode);
    Debug.console("aDiceCode: ",aDiceCode,"| nModCode: ",nModCode);

end