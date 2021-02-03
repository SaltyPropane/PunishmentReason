#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Salty"
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <basecomm>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "PunishmentReasons",
	author = PLUGIN_AUTHOR,
	description = "Punishments with a reason",
	version = PLUGIN_VERSION,
	url = ""
};



public void OnPluginStart()
{
    LoadTranslations("common.phrases");
    LoadTranslations("playercommands.phrases");

    RegAdminCmd("sm_rslay", Command_Rslay, ADMFLAG_SLAY, "Slay with a reason.");
    RegAdminCmd("sm_rmute", Command_Rmute, ADMFLAG_CHAT, "Mute with a reason.");
    RegAdminCmd("sm_rgag", Command_Rgag, ADMFLAG_CHAT, "Gag with a reason.");

}

void slay(int target)
{
    for(int i = 0; i < 5; i++)
    {
        int weapon = GetPlayerWeaponSlot(target, i);

        while(weapon > 0)
        {
            RemovePlayerItem(target, weapon);
            AcceptEntityInput(weapon, "Kill");
            weapon = GetPlayerWeaponSlot(target, i);
        }
    }
    
    ForcePlayerSuicide(target);
}

void mute(int target)
{
    BaseComm_SetClientMute(target, true);
}
void gag(int target)
{
    BaseComm_SetClientGag(target, true);
}


public Action Command_Rslay(int client, int args)
{
    if (args < 1)
    {
        ReplyToCommand(client, "Usage: /rslay <name> <reason>");
        return Plugin_Handled;
    }

    int len; 
    char Arguments[256];
    GetCmdArgString(Arguments, sizeof(Arguments));
    char arg[65];
    len = BreakString(Arguments, arg, sizeof(arg));
    int target = FindTarget(client, arg, true);

    
    

    if (target == -1)
    {
        ReplyToCommand(client, "Could not find any player with the name: \"%s\"", arg);
        return Plugin_Handled;
    }
    char getName[MAX_NAME_LENGTH];
    GetClientName(target, getName, sizeof(getName));
    slay(target);
    ShowActivity2(client, " \x02[SM] ", " \x01Slayed %s. \x04Reason: \x01%s.", getName, Arguments[len]);

    return Plugin_Handled;

}


public Action Command_Rmute(int client, int args)
{
    if(args < 1)
    {
        ReplyToCommand(client, "Usage: /rmute <name> <reason>");
        return Plugin_Handled;
    }



    //creates multiple arguments
    int len; 
    char Arguments[256];
    GetCmdArgString(Arguments, sizeof(Arguments));
    char arg[65];
    len = BreakString(Arguments, arg, sizeof(arg));
    int target = FindTarget(client, arg, true);



    if(target == -1)
    {
        ReplyToCommand(client, "Could not find any player with the name \'%s\'", arg);
        return Plugin_Handled;
    }

    char getName[MAX_NAME_LENGTH];
    GetClientName(target, getName, sizeof(getName));
    mute(target);
    ShowActivity2(client, " \x02[SM] ", " \x01Muted %s. \x04Reason: \x01%s.", getName, Arguments[len]);
    
    return Plugin_Handled;

}

public Action Command_Rgag(int client, int args)
{
    if(args < 1)
    {
        ReplyToCommand(client, "Usage: /rgag <name> <reason>");
        return Plugin_Handled;
    }

    int len; 
    char Arguments[256];
    GetCmdArgString(Arguments, sizeof(Arguments));
    char arg[65];
    len = BreakString(Arguments, arg, sizeof(arg));
    int target = FindTarget(client, arg, true);


    if(target == -1)
    {
        ReplyToCommand(client, "Could not find any player with the name \'%s\'", arg);
        return Plugin_Handled;
    }

    char getName[MAX_NAME_LENGTH];
    GetClientName(target, getName, sizeof(getName));
    gag(target);
    ShowActivity2(client, " \x02[SM] ", " \x01Gagged %s. \x04Reason: \x01%s.", getName, Arguments[len]);
    
    return Plugin_Handled;


}