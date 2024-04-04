#include <amxmodx>
#include <amxmisc>

#define MAX_PLAYERS 32

new gf_VoteTimer;
new gi_VoteInterval;
new gf_MinYesVotes;
new gi_YesVotes;
new gi_NoVotes;
new gi_TotalVotes;
new gi_Menu;
new gi_LastVote = 0;
new gi_SysTimeOffset = 0;
new gb_AnnounceResult;
new gb_Disable;
new gb_InProgress = 0;
new ga_ServerAlias;

public plugin_init() {
    register_plugin("FoXBot Votekick", "1.0", "d3m0n")
    register_clcmd("say /kickbots", "StartVote")

    gb_Disable = register_cvar("amx_fbvk_disable", "0"); // Example: Disable plugin
    gf_VoteTimer = register_cvar("amx_fbvk_vote_timer", "20"); // Example: 20 seconds
    gf_MinYesVotes = register_cvar("amx_fbvk_minyesvotes", "1"); // Example: 1 being 100% of the votes and 0.5 being 50% of the votes
    gi_VoteInterval = register_cvar("amx_fbvk_vote_interval", "30"); // Example: Another vote cannot be started within 30 seconds
    gb_AnnounceResult = register_cvar("amx_fbvk_announce", "1"); // Example: Announce result in chat
    ga_ServerAlias = register_cvar("amx_fbvk_server_alias", "SERVER"); // Example: Server name
}

public StartVote(id) {
    // Check if plugin is disabled
    if(get_pcvar_num(gb_Disable)) {
        client_print(id, print_chat, "FoXBot Votekick is disabled.")
        return PLUGIN_HANDLED;
    }

    // Check if vote is already in progress
    if (gb_InProgress) {
        client_print(0, print_chat, "A vote to kick bots is already in progress.", ga_ServerAlias)
        return PLUGIN_HANDLED;
    }
    
    // Elapsed time since last vote
    new Elapsed = get_systime(gi_SysTimeOffset) - gi_LastVote
    new Delay = get_pcvar_num(gi_VoteInterval)

    // Check if vote interval has passed
    if(Delay > Elapsed) {
        new seconds = Delay - Elapsed;
        new minutes = seconds / 60;
        seconds %= 60;
        if (minutes > 0) {
            client_print(id, print_chat, "You have to wait %d minutes and %d seconds before a new bot vote kick can be started.", minutes, seconds);
        } else {
            client_print(id, print_chat, "You have to wait %d seconds before a new bot vote kick can be started.", seconds);
        }
        return PLUGIN_HANDLED;
    }

    // Start a new vote and update gi_LastVote with the current time
    new Now = get_systime(gi_SysTimeOffset);
    gi_LastVote = Now;

    // Reset vote counts from any previous votes
    // TODO: Use one global struct to store all vote data
    gi_YesVotes = 0;
    gi_NoVotes = 0;

    // Create vote menu for every player
    gi_Menu = menu_create("Kick all bots?", "Vote");

    // Add menu items
    menu_additem(gi_Menu, "Yes");
    menu_additem(gi_Menu, "No");

    // Set players to max players
    new players[MAX_PLAYERS], numPlayers, tempId;

    // Get players
    get_players(players, numPlayers);

    // Display vote menu to all players
    for (new i = 0; i < numPlayers; i++) {
        tempId = players[i];
        menu_display(tempId, gi_Menu);
    }

    // Announce vote in chat
    client_print(0, print_chat, "A vote to kick all bots has been started.", ga_ServerAlias);

    // Set vote in progress
    gb_InProgress = 1;

    // End the vote after vote timer
    set_task(get_pcvar_float(gf_VoteTimer), "EndVote");

    return PLUGIN_HANDLED;
}

public Vote(id, menu, item) {
    switch (item) {
        case 0: {
            gi_YesVotes++;
            client_print(id, print_chat, "You have chosen to kick the bots.");
        }
        case 1: {
            gi_NoVotes++;
            client_print(id, print_chat, "You have chosen not to kick the bots.");
        }
        case MENU_EXIT: {
            client_print(id, print_chat, "You have chosen not to vote.");
        }
    }

    return PLUGIN_HANDLED;
}

public EndVote() {
    // Handle vote results
    HandleResults();

    // Reset vote in progress
    gb_InProgress = 0;

    // Destroy vote menu
    menu_destroy(gi_Menu);

    return PLUGIN_HANDLED;
}

public HandleResults() {
    // Count total votes
    gi_TotalVotes = gi_YesVotes + gi_NoVotes;

    // Check if vote passed
    if (gi_YesVotes > gi_NoVotes) {

        // Minimum yes votes check (optional)
        if (gi_YesVotes < gi_TotalVotes * get_pcvar_num(gf_MinYesVotes)) {
            if (gb_AnnounceResult) {
                client_print(0, print_chat, "Vote failed: Not enough yes votes.");
            }
            return PLUGIN_HANDLED;
        }
        
        if (gb_AnnounceResult) {
            client_print(0, print_chat, "Vote passed: Kicking all bots.");
        }

        // Execute rcon command
        server_cmd("bot ^"max_bots 0^"");
    } else {
        if (gb_AnnounceResult) {
            client_print(0, print_chat, "Vote failed: Kicking bots rejected.");
        }
    }

    return PLUGIN_HANDLED;
}
