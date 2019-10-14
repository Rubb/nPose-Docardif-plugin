/*
The nPose scripts are licensed under the GPLv2 (http://www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in Second Life and/or other virtual world platforms derived from Second Life (such as OpenSim).  If the platform should allow more fine-grained permissions, then "full perms" will mean the most permissive possible set of permissions allowed by the platform.
*/

list UserDefinedPermissionsList;
string USER_DEFINED_PERMISSION_TYPE_BOOL = "bool";
list MacroNames;
list MacroValues;
integer UDPBOOL = -804;
integer MACRO = -807;
integer DOCARDIF = -3500;
integer SEAT_UPDATE = 35353;
list Slots;

integer isAllowed(integer mode, string permissions) {
    // OPERATORS (listed in order of their precedence)
    // ! means a logical NOT
    // & means a logical AND
    // ~ means a logical OR
    // Operators may be surrounded by spaces
    permissions=llStringTrim(permissions, STRING_TRIM);
    if(permissions=="") {
        return TRUE;
    }
    else {
        list permItemsOr=llParseString2List(llToLower(permissions), ["~"], []);
        integer indexOr=~llGetListLength(permItemsOr);
        integer result;
        while(++indexOr && !result) {
            list permItemsAnd=llParseString2List(llList2String(permItemsOr, indexOr), ["&"], []);
            integer indexAnd=~llGetListLength(permItemsAnd);
            result=TRUE;
            while(++indexAnd && result) {
                integer invert;
                string item=llStringTrim(llList2String(permItemsAnd, indexAnd), STRING_TRIM);
                if(llGetSubString(item, 0, 0)=="!") {
                    invert=TRUE;
                    item=llStringTrim(llDeleteSubString(item, 0, 0), STRING_TRIM);
                }
                if(llGetSubString(item, 0, 0)=="@") {
                    integer macroIndex=llListFindList(MacroNames, [llDeleteSubString(item, 0, 0)]);
                    if(~macroIndex) {
                        result=logicalXor(invert, isAllowed(mode, llList2String(MacroValues, macroIndex)));
                    }
                    else {
                        //unknown Macro: assume that it is set to ""
                        result=invert;
                    }
                }
                else {
                    //maybe a user defined permission
                    integer udpIndex=llListFindList(UserDefinedPermissionsList, [item]);
                    if(~udpIndex) {
                        //plugin permission
                        string pluginPermissionType=llList2String(UserDefinedPermissionsList, udpIndex+1);
                        if(pluginPermissionType==USER_DEFINED_PERMISSION_TYPE_BOOL) {
                            result=logicalXor(invert, (integer)llList2String(UserDefinedPermissionsList, udpIndex+2));
                        }
                        else {
                            //error unknown plugin permission type
                            result=invert;
                        }
                    }
                    else {
                        //maybe the plugin has not registered itself right now. So assume a blank list or a 0 as value
                        result=invert;
                    }
/*
The nPose scripts are licensed under the GPLv2 (http://www.gnu.org/licenses/gpl-2.0.txt), with the following addendum:

The nPose scripts are free to be copied, modified, and redistributed, subject to the following conditions:
    - If you distribute the nPose scripts, you must leave them full perms.
    - If you modify the nPose scripts and distribute the modifications, you must also make your modifications full perms.

"Full perms" means having the modify, copy, and transfer permissions enabled in Second Life and/or other virtual world platforms derived from Second Life (such as OpenSim).  If the platform should allow more fine-grained permissions, then "full perms" will mean the most permissive possible set of permissions allowed by the platform.
*/

list UserDefinedPermissionsList;
string USER_DEFINED_PERMISSION_TYPE_BOOL = "bool";
list MacroNames;
list MacroValues;
integer UDPBOOL = -804;
integer MACRO = -807;
integer DOCARDIF = -3500;
integer SEAT_UPDATE = 35353;
list Slots;

integer isAllowed(integer mode, string permissions) {
    // OPERATORS (listed in order of their precedence)
    // ! means a logical NOT
    // & means a logical AND
    // ~ means a logical OR
    // Operators may be surrounded by spaces
    permissions=llStringTrim(permissions, STRING_TRIM);
    if(permissions=="") {
        return TRUE;
    }
    else {
        list permItemsOr=llParseString2List(llToLower(permissions), ["~"], []);
        integer indexOr=~llGetListLength(permItemsOr);
        integer result;
        while(++indexOr && !result) {
            list permItemsAnd=llParseString2List(llList2String(permItemsOr, indexOr), ["&"], []);
            integer indexAnd=~llGetListLength(permItemsAnd);
            result=TRUE;
            while(++indexAnd && result) {
                integer invert;
                string item=llStringTrim(llList2String(permItemsAnd, indexAnd), STRING_TRIM);
                if(llGetSubString(item, 0, 0)=="!") {
                    invert=TRUE;
                    item=llStringTrim(llDeleteSubString(item, 0, 0), STRING_TRIM);
                }
                if(llGetSubString(item, 0, 0)=="@") {
                    integer macroIndex=llListFindList(MacroNames, [llDeleteSubString(item, 0, 0)]);
                    if(~macroIndex) {
                        result=logicalXor(invert, isAllowed(mode, llList2String(MacroValues, macroIndex)));
                    }
                    else {
                        //unknown Macro: assume that it is set to ""
                        result=invert;
                    }
                }
                else {
                    //maybe a user defined permission
                    integer udpIndex=llListFindList(UserDefinedPermissionsList, [item]);
                    if(~udpIndex) {
                        //plugin permission
                        string pluginPermissionType=llList2String(UserDefinedPermissionsList, udpIndex+1);
                        if(pluginPermissionType==USER_DEFINED_PERMISSION_TYPE_BOOL) {
                            result=logicalXor(invert, (integer)llList2String(UserDefinedPermissionsList, udpIndex+2));
                        }
                        else {
                            //error unknown plugin permission type
                            result=invert;
                        }
                    }
                    else {
                        //maybe the plugin has not registered itself right now. So assume a blank list or a 0 as value
                        result=invert;
                    }
                }
            }
        }
        return result;
    }
}

integer logicalXor(integer conditionA, integer conditionB) {
    //lsl do only know a bitwise XOR :(
    return(conditionA && !conditionB) || (!conditionA && conditionB);
}

default {
    //catch UPD updates as they occur and save values in ths script
    link_message(integer sender, integer num, string str, key id) {
        if(num == MACRO || num == UDPBOOL) {
            //save new option(s) or macro(s) or userdefined permissions from LINKMSG
            list optionsToSet = llParseStringKeepNulls(str, ["|"], []);
            integer length = llGetListLength(optionsToSet);
            integer index;
            for(index=0; index<length; ++index) {
                list optionsItems = llParseString2List(llList2String(optionsToSet, index), ["="], []);
                string optionItem = llToLower(llStringTrim(llList2String(optionsItems, 0), STRING_TRIM));
                string optionString = llList2String(optionsItems, 1);
                string optionSetting = llToLower(llStringTrim(optionString, STRING_TRIM));
                integer optionSettingFlag = optionSetting=="on" || (integer)optionSetting;
                if(num==MACRO) {
                    integer macroIndex=llListFindList(MacroNames, [optionItem]);
                    if(~macroIndex) {
                        MacroNames=llDeleteSubList(MacroNames, macroIndex, macroIndex);
                        MacroValues=llDeleteSubList(MacroValues, macroIndex, macroIndex);
                    }
                    MacroNames+=[optionItem];
                    MacroValues+=[optionString];
                }
                else if(num==UDPBOOL) {
                    integer udpIndex=llListFindList(UserDefinedPermissionsList, [optionItem]);
                    if(~udpIndex) {
                        UserDefinedPermissionsList=llDeleteSubList(UserDefinedPermissionsList, udpIndex, udpIndex+2);
                    }
                    if(num==UDPBOOL) {
                        UserDefinedPermissionsList+=[optionItem, USER_DEFINED_PERMISSION_TYPE_BOOL, optionSettingFlag];
                    }
                }
            }
        }
        else if(num == SEAT_UPDATE) {
            /*
            This script is going to set up a udpbool for each seat where occupied=1 and not occupied=0. The UDPBOOLs will be broadcasted to other scripts.
            ((The udpbool names for seats will be "seatfilled" + "1" as "seatfilled1", and "seatfilled" + "2" for seatfilled2, etc.))
            There is no need to build your own as these are done and maintained in this script and would cause unexpected results.
            An example might be where we have a sofa with 2 couples seats available.  
            When both sitters of a couple stand, we'd like to set their poses back to something that resempbles the default pose set but not disturb the other couple.
            We could also have some singles poses available and would really not like to have a singles AV forced into a couples pose when they sit.
            
            To get up-to-date sitter info, we'll grab that info from the seat update broadcast.
            
            syntax examples
                DOCARDIF|!seatfilled1 & !seatfilled2|Cpl1BaseCard[|RunIfFalse]
                DOCARDIF|seatfilled1 & !seatfilled2 & seatfilled3|Cpl1BaseCard[|RunIfFalse]
            */
            list seatsavailable = llParseStringKeepNulls(str, ["^"], []);
            str = "";
            integer Seatcount;
            integer stop = llGetListLength(seatsavailable)/8;
            list udps;
            for(Seatcount = 0; Seatcount < stop; ++Seatcount) {
                integer occupiedFlag = 0;
                if (llList2Key(seatsavailable, Seatcount * 8 + 4)) {
                    occupiedFlag = 1;
                }
                udps+=["seatfilled" + (string)(Seatcount+1) + "=" + (string)occupiedFlag];
            }
            llMessageLinked(LINK_SET, 220, "UDPBOOL|" + llDumpList2String(udps, "|"), "");
        }
        else if (num == DOCARDIF) {
/*
examples
DOCARDIF|is2|SET:TrueCardToRun[|FalseCardToRun]
DOCARDIF|is2&!onT|TestCardTrue[|TestCardFalse]
*/
            list TempList = llParseString2List(str, ["|"], []);
            string Permissions = llList2String(TempList, 0);
            string TrueCardName = llList2String(TempList, 1);
            string FalseCardName = llList2String(TempList, 2);
            if (isAllowed(0, Permissions)) {
                llMessageLinked(LINK_SET, 200,TrueCardName, NULL_KEY);
            }
            else if (FalseCardName != "") {
                llMessageLinked(LINK_SET, 200,FalseCardName, NULL_KEY);
            }
        }
    }
}
