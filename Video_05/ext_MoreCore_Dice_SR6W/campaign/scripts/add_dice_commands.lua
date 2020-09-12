---
--- Template by Frostbyte
--- Created by james.
--- DateTime: 8/22/2020 5:58 PM
--- <script name="add_dice_commands" file="Copy_Path_From_Current_Root" />
---

function onLoseFocus()
    local nameWindowDBNode = window.getDatabaseNode();
    local nodeWin = nameWindowDBNode;
    local sName = nodeWin.getChild("name").getValue();
    local sCommand = nodeWin.getChild("clichatcommand").getValue();
    local sRollstype = nodeWin.getChild("rollstype").getValue();

    local nStart,nEnd,sCommand,sParams = string.find(sCommand, '^/([^%s]+)%s*(.*)');
    if sCommand == "rollon" then
        nodeWin.getChild("rollstype").setValue("table");
    elseif sCommand == "dice_test" then
        nodeWin.getChild("rollstype").setValue("dice_test");
    -- 'dice_mod_update' Copy the below two lines to the next line. Update "dice_mod" to the new command on both lines.
    elseif sCommand == "dice_mod" then
        nodeWin.getChild("rollstype").setValue("dice_mod");
    elseif sCommand == "sr6w" then
        nodeWin.getChild("rollstype").setValue("sr6w");
    elseif sCommand == "heal" then
        nodeWin.getChild("rollstype").setValue("heal");
    elseif sCommand == nil then
        nodeWin.getChild("rollstype").setValue("chat");
    else nodeWin.getChild("rollstype").setValue("rolls");
    end

    Debug.console("*** campaign/scripts/add_dice_commands.lua ***");
    Debug.console("nameWindowDBNode: ",nameWindowDBNode,"nodeWin: ","sName: ",sName,"sCommand: ",sCommand,
    "sRollstype: ",sRollstype,"nStart: ",nStart,"nEnd: ",nEnd,"sParams: ",sParams);
    Debug.console(" ");
    Debug.console(" ");
end
