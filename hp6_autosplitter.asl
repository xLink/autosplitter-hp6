// HP6 autosplitter
// Made by PrudenGaming & xLink
// base code & memory locations obtained from Marczeslaw
// Works only with dedicated splits

state("hp6")
{
	string50 cutscene: 0x00965B80, 0xC, 0x203;
	byte map: 0x4928BC;
	uint inDuel: 0xBCD354;
	uint inPotion: 0xBCD42C;
	uint inQuidditch: 0xBCD6DC;
}

startup
{
	settings.Add("autostart", true, "Autostart on first cutscene (full game run)");
}

init
{
	vars.gamestate = 0;

	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
		var textSettings = timer.Layout.Components
			.Where(x => x.GetType().Name == "TextComponent")
			.Select(x => x.GetType().GetProperty("Settings")
			.GetValue(x, null));
		var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
		if (textSetting == null)
		{
			var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
			var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
			timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

			textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
			textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
		}

		if (textSetting != null)
			textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
	});
}

start 
{
	return current.cutscene != old.cutscene && (current.cutscene == "ns01.vp6" && settings["autostart"]);
}

update
{
}

split
{
	if (vars.gamestate == 0 && current.cutscene == "ns01.vp6") {vars.gamestate = 10;} // Starting new game
	else if (vars.gamestate == 10 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 11; return true;} // Burrow flying
	else if (vars.gamestate == 11 && current.cutscene == "ns02.vp6") {vars.gamestate = 15; return true;} // Cauldrons
	else if (vars.gamestate == 15 && current.cutscene == "ns03.vp6") {vars.gamestate = 20; return true;} // Enter Hogwarts
	else if (vars.gamestate == 20 && old.map == 18 && current.map == 64) {vars.gamestate = 21;} // enter potions
	else if (vars.gamestate == 21 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 22;} // tutorial
	else if (vars.gamestate == 22 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 23;} // first potion
	else if (vars.gamestate == 23 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 24;} // tutorial
	else if (vars.gamestate == 24 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 25;}
	else if (vars.gamestate == 25 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 26;} // second potion
	else if (vars.gamestate == 26 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 27;} // third potion
	else if (vars.gamestate == 27 && old.map == 64 && current.map == 18) {vars.gamestate = 28; return true;} // leaving potions
	else if (vars.gamestate == 28 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 29;} // stupefy
	else if (vars.gamestate == 29 && old.map == 40 && current.map == 23) {vars.gamestate = 30; return true;} // Leave duelling
	else if (vars.gamestate == 30 && current.cutscene == "ns04.vp6") {vars.gamestate = 40;} // riddle cs
	else if (vars.gamestate == 40 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 41; return true;} // Goyle fight
	else if (vars.gamestate == 41 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 42; return true;} // Quidditch tryouts
	else if (vars.gamestate == 42 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 43;} // volubilis
	else if (vars.gamestate == 43 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 44;} // tutorial
	else if (vars.gamestate == 44 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 45;} // tutorial
	else if (vars.gamestate == 45 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 46;} // shrinking solution
	else if (vars.gamestate == 46 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 47;} // Crabbe fight
	else if (vars.gamestate == 47 && current.cutscene == "ns05.vp6") {vars.gamestate = 50; return true;} // hogsmeade
	else if (vars.gamestate == 50 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 51;}
	else if (vars.gamestate == 51 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 52; return true;} // Slytherin match
	else if (vars.gamestate == 52 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 53;} // tutorial
	else if (vars.gamestate == 53 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 54; return true;} // Ponche
	else if (vars.gamestate == 54 && current.cutscene == "ns08.vp6") {vars.gamestate = 60; return true;} // Follow snape
	else if (vars.gamestate == 60 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 61;} // Burrow bella 1
	else if (vars.gamestate == 61 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 62;} // Burrow bella 2
	else if (vars.gamestate == 62 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 63;} // Burrow fenrir
	else if (vars.gamestate == 63 && current.cutscene == "ns09.vp6") {vars.gamestate = 70; return true;} // Burrow fights
	else if (vars.gamestate == 70 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 71; return true;} // Polyjuice
	else if (vars.gamestate == 71 && old.map == 21 && current.map == 17) {vars.gamestate = 72; return true;} // noisy hitter
	else if (vars.gamestate == 72 && current.cutscene == "ns10.vp6") {vars.gamestate = 80;} // Second memory
	else if (vars.gamestate == 80 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 81;} // tutorial
	else if (vars.gamestate == 81 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 82;} // Ravenclaw duelling club
	else if (vars.gamestate == 82 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 83; return true;} // Quidditch practice
	else if (vars.gamestate == 83 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 84;} // slytherin duel
	else if (vars.gamestate == 84 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 85; return true;} // Euphoria
	else if (vars.gamestate == 85 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 86;} // astronomy 1
	else if (vars.gamestate == 86 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 87;} // astronomy 2
	else if (vars.gamestate == 87 && current.cutscene == "ns11.vp6") {vars.gamestate = 90; return true;} // astronomy trapped
	else if (vars.gamestate == 90 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 91; return true;} // love potion
	else if (vars.gamestate == 91 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 92;}
	else if (vars.gamestate == 92 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 93; return true;} // Hufflepuff match
	else if (vars.gamestate == 93 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 94; return true;} //sectumsempra
	else if (vars.gamestate == 94 && current.cutscene == "ns12.vp6") {vars.gamestate = 100;} // RoR kiss
	else if (vars.gamestate == 100 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 101;} // bridge fight 1
	else if (vars.gamestate == 101 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 102;} // bridge fight 2
	else if (vars.gamestate == 102 && old.inPotion == 0 && current.inPotion == 1) {vars.gamestate = 103;} // Jazz walk
	else if (vars.gamestate == 103 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 104; return true;} // fertilizer
	else if (vars.gamestate == 104 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 105; return true;} // Crabbe fight
	else if (vars.gamestate == 105 && current.cutscene == "ns13.vp6") {vars.gamestate = 110;} // third memory
	else if (vars.gamestate == 110 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 111;}
	else if (vars.gamestate == 111 && old.inQuidditch == 1 && current.inQuidditch == 0) {vars.gamestate = 112; return true;} // Ravenclaw Match
	else if (vars.gamestate == 112 && old.inPotion == 1 && current.inPotion == 0) {vars.gamestate = 113; return true;} // wiggenweld
	else if (vars.gamestate == 113 && current.cutscene == "ns14.vp6") {vars.gamestate = 120;} // to cave
	else if (vars.gamestate == 120 && current.cutscene == "ns15.vp6") {vars.gamestate = 130; return true;} // Inferi
	else if (vars.gamestate == 130 && old.inDuel == 1 && current.inDuel == 0) {vars.gamestate = 131;} // first death eater
	else if (vars.gamestate == 131 && old.inDuel == 1 && current.inDuel == 0 && current.map == 45) {vars.gamestate = 132;} // second death eather
	else if (vars.gamestate == 132 && old.inDuel == 1 && current.inDuel == 0 && current.map == 9) {vars.gamestate = 133;} // Fenrir
	else if (vars.gamestate == 133 && old.inDuel == 1 && current.inDuel == 0 && current.map == 41) {vars.gamestate = 134; return true;} // end
	else if (vars.gamestate == 134) {vars.gamestate = 135;} // octo fix

}
