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

    -- Setup Dice Strings
    local dice_simple = "5d10";
    local dice_wMod = "5d10+7";
    local dice_wWords = "5d10+7 Hey Mate";
    local dice_complex = "5d10+4d6+8 Tough";

    -- Test output
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

    -- Using a more traditional dice string.
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



-- *** Nodes ***
    -- How to Traverse through Nodes
    Debug.console(" ");
    Debug.console(" ");
    Debug.console("*** DB Node Test ***");
    Debug.console(" ");
    --Define who you are
    local nodeActorCharacterSheet = DB.findNode(rActor.sCreatureNode);
    local nodeActorCombatTracker = DB.findNode(rActor.sCTNode);
    -- take a look at the child nodes
    Debug.console("*** Character Sheet ***");
    Debug.console("nodeActorCharacterSheet.getChildren(): ",nodeActorCharacterSheet.getChildren());
    Debug.console(" ");
    Debug.console("*** Combat Tracker ***");
    Debug.console("nodeActorCombatTracker.getChildren(): ",nodeActorCombatTracker.getChildren());
    Debug.console(" ");

    -- pull a value
    Debug.console(" ");
    Debug.console("*** getValue()  ***");
    local nCharHealth = nodeActorCombatTracker.getChild("health").getValue();
    Debug.console("getValue()  --  nCharHealth: ",nCharHealth);

    -- set a value
    Debug.console(" ");
    Debug.console("*** setValue() ***");
    nCharHealth = nCharHealth + 5;
    nodeActorCombatTracker.getChild("health").setValue(nCharHealth);
    Debug.console("setValue()  --  Go look at Character Tracker - nCharHealth: ",nCharHealth);

    -- pull all effects on Actor
    Debug.console(" ");
    Debug.console("*** Effects ***");
    local aActorEffects = {};
    local nCount = 0;
    for _,nodeActorEffects in pairs(nodeActorCombatTracker.getChild("effects").getChildren()) do
        Debug.console("nodeActorEffects: ",nodeActorEffects);
        Debug.console("nodeActorEffects.getChildren():", nodeActorEffects.getChildren())
        aActorEffects["label_"..nCount] = nodeActorEffects.getChild("label").getValue();
        aActorEffects["duration_"..nCount] = nodeActorEffects.getChild("duration").getValue();
        nCount = nCount + 1;
    end
    Debug.console("aActorEffects: ",aActorEffects);

    -- pull Actor's Targets
    Debug.console(" ");
    Debug.console("*** Actors Targets ***");
    local aActorTargets = {};
    local nCount = 0;
    for _,nodeActorTarget in pairs(nodeActorCombatTracker.getChild("targets").getChildren()) do
        Debug.console("nodeActorTarget: ",nodeActorTarget);
        Debug.console("nodeActorTarget.getChildren():", nodeActorTarget.getChildren())
        aActorTargets["targetID"..nCount] = nodeActorTarget.getChild("noderef").getValue();
        nCount = nCount + 1;
    end
    Debug.console("aActorTargets: ",aActorTargets);

    -- pull Target's Health and EffectNode
    Debug.console(" ");
    Debug.console("*** Target's Health and EffectNode ***");
    local aTargetsStats = {};
    local nCount = 0;
    for _,sTargetID in pairs(aActorTargets) do
        Debug.console("sTargetID: ",sTargetID);
        aTargetsStats["targetID_"..nCount] = sTargetID;
        local nodeTarget = DB.findNode(sTargetID);
        aTargetsStats["Target_"..nCount.. "_health"] = nodeTarget.getChild("health").getValue();
        local nCount2 = 0;
        for _,nodeTargetEffects in pairs(nodeTarget.getChild("effects").getChildren()) do
            Debug.console("nodeTargetEffects: ",nodeTargetEffects);
            aTargetsStats["Target_"..nCount.."_label_"..nCount2] = nodeTargetEffects.getChild("label").getValue();
            aTargetsStats["Target_"..nCount.."_duration_"..nCount2] = nodeTargetEffects.getChild("duration").getValue();
            nCount2 = nCount2 + 1;
        end
        nCount = nCount + 1;
    end
    Debug.console("aTargetsStats: ",aTargetsStats);

end