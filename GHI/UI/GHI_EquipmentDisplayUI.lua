--[[
Equipment Display System

The slot class handles items in slots on a player. 

It is a class which is provided with information about what to display:
	-	unit (player, target, partyX etc)
	-	slot info  (refID, x,y,z,icon,size,amount)
	- 	tooltip function
	-	on click (picup / place) functions

Build in functions makes it possible to rotate the figure (only in one plane).
It is nessecary for this function to determine when the icon shall be shown in front of the figure and when it shall be shown behind it.


--]]

local calibrate = false;

local comm = GHI_Comm();

-- data
local CamPos = {};
local CamDir = {};

--	Alliance Male
CamPos["Human-Male"] = { 3.122545001, 0, -0.196758709 };
CamDir["Human-Male"] = { -1, 0, 0.021059619 };
CamPos["NightElf-Male"] = { 4.057864672, 0, -0.34 }; -- ok
CamDir["NightElf-Male"] = { -1, 0, 0 };
CamPos["Dwarf-Male"] = { 2.53132841556727, 0, 0.159508060838374 } -- ok
CamDir["Dwarf-Male"] = { -1, 0, -0.114500036602475 }
CamPos["Draenei-Male"] = { 4.33142824614634, 0, 0.111236309981817 } -- ok
CamDir["Draenei-Male"] = { -1, 0, -0.100664874109562 }
CamPos["Gnome-Male"] = { 2.1627564057806, 0, 0.0122689528924064 }
CamDir["Gnome-Male"] = { -1, 0, -0.0506036745303314 }
CamPos["Worgen-Male"] = { 3.122545001, 0, -0.196758709 };
CamDir["Worgen-Male"] = { -1, 0, 0.021059619 };


-- Alliance Female
CamPos["Gnome-Female"] = { 1.703185572, 0, 0.156207708 };
CamDir["Gnome-Female"] = { -1, 0, -0.063621795 };
CamPos["Human-Female"] = { 2.49707379233109, 0, -0.0106598778621643 }
CamDir["Human-Female"] = { -1, 0, -0.0163051664108343 }
CamPos["Dwarf-Female"] = { 2.19992199838378, 0, 0.0245148495664771 }
CamDir["Dwarf-Female"] = { -1, 0, -0.049393554608541 }
CamPos["NightElf-Female"] = { 4.23034501440184, 0, -0.0379146954580338 }
CamDir["NightElf-Female"] = { -1, 0, -0.0152025854692188 }
CamPos["Draenei-Female"] = { 3.99051376275215, 0, -0.000259100939754398 }
CamDir["Draenei-Female"] = { -1, 0, 0.0210278220327247 }
CamPos["Worgen-Female"] = { 2.49707379233109, 0, -0.0106598778621643 } -- copy of human
CamDir["Worgen-Female"] = { -1, 0, -0.0163051664108343 }

-- Horde Male
CamPos["Orc-Male"] = { 3.89031316240057, 0, -0.197486 }
CamDir["Orc-Male"] = { -1, 0, 0 }
CamPos["Undead-Male"] = { 3.42844067121756, 0, -0.287250890539236 }
CamDir["Undead-Male"] = { -1, 0, 0.0282036159719208 }
CamPos["Scourge-Male"] = { 3.42844067121756, 0, -0.287250890539236 }
CamDir["Scourge-Male"] = { -1, 0, 0.0282036159719208 }
CamPos["Tauren-Male"] = { 3.90229589455977, 0, -0.00189262571556618 }
CamDir["Tauren-Male"] = { -1, 0, -0.0194820654784481 }
CamPos["Troll-Male"] = { 4.57453194649561, 0, -0.00375368402110371 }
CamDir["Troll-Male"] = { -1, 0, -0.0586627436900888 }
CamPos["BloodElf-Male"] = { 3.86825416179682, 0, 0.0417639353605309 }
CamDir["BloodElf-Male"] = { -1, 0, 0.030287199332928 }
CamPos["Goblin-Male"] = { 3.122545001, 0, -0.196758709 }; --copy of gnome
CamDir["Goblin-Male"] = { -1, 0, 0.021059619 };

-- Horde Female
CamPos["Orc-Female"] = { 3.17238708536657, 0, 0.00148408508847812 }
CamDir["Orc-Female"] = { -1, 0, -0.0278394306049981 }
CamPos["Scourge-Female"] = { 3.28345231815537, 0, -0.0345984158985607 }
CamDir["Scourge-Female"] = { -1, 0, 0.0174701738937148 }
CamPos["Undead-Female"] = { 3.28345231815537, 0, -0.0345984158985607 }
CamDir["Undead-Female"] = { -1, 0, 0.0174701738937148 }
CamPos["Tauren-Female"] = { 3.33901313926797, 0, 0.0818068482704375 }
CamDir["Tauren-Female"] = { -1, 0, -0.146335987006906 }
CamPos["Troll-Female"] = { 3.97114719685901, 0, -0.0400682948069166 }
CamDir["Troll-Female"] = { -1, 0, -0.0575599297066138 }
CamPos["BloodElf-Female"] = { 3.2892542673688, 0, 0.0118071713949199 }
CamDir["BloodElf-Female"] = { -1, 0, -0.017794584841872 }
CamPos["Goblin-Female"] = { 1.703185572, 0, 0.156207708 }; --copy of gnome
CamDir["Goblin-Female"] = { -1, 0, -0.063621795 };






local StdSlots = {};
--StdSlots["x"] = {belt={},left_foot={},right_foot={},left_ring={},right_ring={},chest={},face={},head={},back={},legs_left_side={},leg_right_side={}};
StdSlots["Human-Male"] = { head = { 0.11, -0.01, 0.55, 0.8 }, leg_right_side = { 0.08, -0.1, -0.37, 1 }, chest = { 0.13, -0.02, 0.25, 1 }, face = { 0.16, -0.01, 0.46, 0.8 }, right_foot = { 0.06, -0.14, -0.76, 1 }, leg_left_side = { 0.17, 0.05, -0.33, 1 }, belt = { 0.1, -0.02, 0.03, 0.8 }, back = { -0.1, 0.02, 0.23, 1.2 }, left_foot = { 0.1, 0.09, -0.76, 1 }, left_ring = { 0.03, 0.23, -0.21, 0.8 }, right_ring = { -0.05, -0.31, -0.21, 0.8 }, };
StdSlots["Human-Female"] = { head = { 0.11, -0.01, 0.55, 0.8 }, leg_right_side = { 0.08, -0.08, -0.22, 1 }, chest = { 0.1, -0.02, 0.31, 1 }, face = { 0.06, -0.01, 0.46, 0.8 }, right_foot = { 0.01, -0.06, -0.64, 1 }, leg_left_side = { 0.17, 0.07, -0.22, 1 }, belt = { 0.1, -0.02, 0.03, 0.8 }, back = { -0.1, 0, 0.28, 1.2 }, left_foot = { 0.07, 0.09, -0.63, 1 }, left_ring = { -0.01, 0.19, -0.05, 0.8 }, right_ring = { -0.06, -0.19, -0.05, 0.8 }, };

StdSlots["Worgen-Male"] = { head = { 0.11, -0.01, 0.55, 0.8 }, leg_right_side = { 0.08, -0.1, -0.37, 1 }, chest = { 0.13, -0.02, 0.25, 1 }, face = { 0.16, -0.01, 0.46, 0.8 }, right_foot = { 0.06, -0.14, -0.76, 1 }, leg_left_side = { 0.17, 0.05, -0.33, 1 }, belt = { 0.1, -0.02, 0.03, 0.8 }, back = { -0.1, 0.02, 0.23, 1.2 }, left_foot = { 0.1, 0.09, -0.76, 1 }, left_ring = { 0.03, 0.23, -0.21, 0.8 }, right_ring = { -0.05, -0.31, -0.21, 0.8 }, };
StdSlots["Worgen-Female"] = { head = { 0.11, -0.01, 0.55, 0.8 }, leg_right_side = { 0.08, -0.08, -0.22, 1 }, chest = { 0.1, -0.02, 0.31, 1 }, face = { 0.06, -0.01, 0.46, 0.8 }, right_foot = { 0.01, -0.06, -0.64, 1 }, leg_left_side = { 0.17, 0.07, -0.22, 1 }, belt = { 0.1, -0.02, 0.03, 0.8 }, back = { -0.1, 0, 0.28, 1.2 }, left_foot = { 0.07, 0.09, -0.63, 1 }, left_ring = { -0.01, 0.19, -0.05, 0.8 }, right_ring = { -0.06, -0.19, -0.05, 0.8 }, };

StdSlots["Undead-Male"] = { head = { 0.3, -0.08, 0.55, 1 }, leg_right_side = { 0, -0.21, -0.47, 1 }, chest = { 0.01, -0.09, 0.19, 1.5 }, face = { 0.28, -0.07, 0.46, 1 }, right_foot = { 0.001, -0.21, -0.93, 1.5 }, leg_left_side = { 0.07, 0.32, -0.46, 1 }, belt = { 0.001, 0.03, -0.05, 1 }, back = { -0.23, -0.12, 0.33, 1.5 }, left_foot = { -0.04, 0.34, -0.94, 1.5 }, left_ring = { 0.1, 0.36, -0.36, 1 }, right_ring = { -0.19, -0.3, -0.24, 1 }, };
StdSlots["Undead-Female"] = { head = { 0.26, -0.01, 0.71, 0.8 }, leg_right_side = { 0.08, -0.08, -0.27, 1 }, chest = { 0.1, -0.02, 0.36, 1 }, face = { 0.23, -0.01, 0.61, 0.8 }, right_foot = { -0.05, -0.06, -0.74, 1 }, leg_left_side = { 0.17, 0.07, -0.26, 1 }, belt = { 0.1, 0, 0.14, 0.8 }, back = { -0.1, 0, 0.38, 1.2 }, left_foot = { 0.07, 0.15, -0.73, 1 }, left_ring = { 0.14, 0.28, -0.1, 0.8 }, right_ring = { 0.06, -0.3, -0.08, 0.8 }, };

StdSlots["Scourge-Male"] = { head = { 0.3, -0.08, 0.55, 1 }, leg_right_side = { 0, -0.21, -0.47, 1 }, chest = { 0.01, -0.09, 0.19, 1.5 }, face = { 0.28, -0.07, 0.46, 1 }, right_foot = { 0.001, -0.21, -0.93, 1.5 }, leg_left_side = { 0.07, 0.32, -0.46, 1 }, belt = { 0.001, 0.03, -0.05, 1 }, back = { -0.23, -0.12, 0.33, 1.5 }, left_foot = { -0.04, 0.34, -0.94, 1.5 }, left_ring = { 0.1, 0.36, -0.36, 1 }, right_ring = { -0.19, -0.3, -0.24, 1 }, };
StdSlots["Scourge-Female"] = { head = { 0.26, -0.01, 0.71, 0.8 }, leg_right_side = { 0.08, -0.08, -0.27, 1 }, chest = { 0.1, -0.02, 0.36, 1 }, face = { 0.23, -0.01, 0.61, 0.8 }, right_foot = { -0.05, -0.06, -0.74, 1 }, leg_left_side = { 0.17, 0.07, -0.26, 1 }, belt = { 0.1, 0, 0.14, 0.8 }, back = { -0.1, 0, 0.38, 1.2 }, left_foot = { 0.07, 0.15, -0.73, 1 }, left_ring = { 0.14, 0.28, -0.1, 0.8 }, right_ring = { 0.06, -0.3, -0.08, 0.8 }, };


StdSlots["Draenei-Male"] = { head = { 0.08, -0.03, 0.63, 1 }, leg_right_side = { 0.34, -0.12, -0.73, 1 }, chest = { 0.22, 0.09, 0.23, 1.5 }, face = { 0.19, 0.05, 0.56, 1 }, right_foot = { 0.16, -0.21, -1.28, 1.5 }, leg_left_side = { 0.07, 0.39, -0.78, 1 }, back = { -0.01, -0.12, 0.25, 1.5 }, belt = { 0.19, 0.1, -0.23, 1 }, left_foot = { -0.04, 0.22, -1.29, 1.5 }, left_ring = { 0.01, 0.55, -0.49, 1 }, right_ring = { 0.27, -0.3, -0.45, 1 }, };
StdSlots["Draenei-Female"] = { head = { 0.16, 0.01, 0.99, 1 }, leg_right_side = { 0.08, -0.08, -0.27, 1 }, chest = { 0.1, 0.04, 0.68, 1 }, face = { 0.18, 0.02, 0.89, 0.8 }, right_foot = { 0.14, -0.06, -0.85, 1 }, leg_left_side = { 0.09, 0.15, -0.26, 1 }, back = { -0.1, 0, 0.57, 1.2 }, belt = { 0.1, 0.04, 0.32, 0.8 }, left_foot = { 0.02, 0.18, -0.83, 1 }, left_ring = { 0.02, 0.27, 0.02, 0.8 }, right_ring = { 0.01, -0.24, 0.09, 0.8 }, };

StdSlots["NightElf-Male"] = { head = { 0.08, -0.03, 0.63, 1 }, leg_right_side = { 0.11, -0.16, -0.71, 1 }, chest = { 0.1, 0, 0.23, 1.5 }, face = { 0.15, -0.02, 0.49, 1 }, right_foot = { 0.05, -0.23, -1.29, 1.5 }, leg_left_side = { 0.05, 0.19, -0.71, 1 }, right_ring = { 0, -0.3, -0.45, 1 }, belt = { 0.14, 0, -0.07, 1 }, left_foot = { 0.04, 0.22, -1.29, 1.5 }, left_ring = { 0.01, 0.3, -0.49, 1 }, back = { -0.17, 0, 0.25, 1.5 }, };
StdSlots["NightElf-Female"] = { head = { 0.01, 0.04, 0.95, 1.00 }, right_foot = { 0.1, .17, -1.08, 1.00 }, right_ring = { 0.1, .33, -0.13, 1.00 }, left_foot = { 0.1, -0.23, -1.06, 1.00 }, belt = { 0.1, 0.06, 0.21, 1.00 }, chest = { 0.1, 0, 0.48, 1.00 }, left_ring = { 0.1, -0.28, -0.13, 1.00 }, face = { 0.01, 0.04, 0.79, 1.00 }, back = { -0.01, 0, 0.44, 1.00 }, leg_left_side = { 0.1, -0.13, -0.47, 1.00 }, leg_right_side = { 0.1, .16, -0.47, 1.00 } };

StdSlots["BloodElf-Male"] = { head = { 0.18, -0.03, 0.94, 1 }, leg_right_side = { 0.11, -0.13, -0.21, 1 }, chest = { 0.2, -0.05, 0.63, 1.5 }, face = { 0.04, -0.02, 0.97, 1.2 }, right_foot = { 0.11, -0.15, -0.69, 1 }, leg_left_side = { 0.01, 0.17, -0.23, 1 }, right_ring = { -0.11, -0.3, 0.1, 0.8 }, back = { -0.12, -0.14, 0.72, 1.5 }, left_foot = { 0.04, 0.22, -0.71, 1.5 }, left_ring = { -0.02, 0.3, 0.11, 1 }, belt = { 0.2, -0.05, 0.41, 1.2 }, };
StdSlots["BloodElf-Female"] = { head = { 0.01, -0.03, 0.75, 1 }, leg_right_side = { 0.08, -0.17, -0.33, 1 }, chest = { 0.1, -0.02, 0.35, 1 }, face = { 0.01, -0.03, 0.65, 0.8 }, right_foot = { 0.01, -0.27, -0.83, 1 }, leg_left_side = { 0.05, 0.02, -0.34, 1 }, belt = { 0.05, -0.03, 0.17, 0.8 }, back = { -0.1, 0, 0.32, 1.2 }, left_foot = { 0.01, 0.02, -0.79, 1 }, left_ring = { 0.02, 0.15, -0.09, 0.8 }, right_ring = { 0.01, -0.24, -0.06, 0.8 }, };

StdSlots["Troll-Male"] = { head = { 0.55, 0.02, 0.77, 1.5 }, leg_right_side = { 0.11, -0.24, -0.74, 1 }, chest = { 0.05, 0.01, 0.3, 1.5 }, face = { 0.56, 0, 0.58, 1.2 }, right_foot = { -0.1, -0.36, -1.34, 1.5 }, leg_left_side = { 0.01, 0.33, -0.77, 1 }, back = { -0.19, -0.02, 0.51, 2 }, belt = { 0, 0, 0.01, 1.5 }, left_foot = { 0.04, 0.42, -1.39, 1.5 }, left_ring = { 0.06, 0.61, -0.75, 1 }, right_ring = { 0.01, -0.53, -0.74, 0.8 }, };
StdSlots["Troll-Female"] = { head = { 0.01, 0.01, 0.64, 1 }, leg_right_side = { 0.08, -0.13, -0.6, 1 }, chest = { 0.1, -0.02, 0.25, 1 }, face = { 0.1, 0, 0.58, 0.8 }, right_foot = { 0.01, -0.12, -1.16, 1 }, leg_left_side = { 0.05, 0.17, -0.63, 1 }, right_ring = { 0.02, -0.3, -0.36, 0.8 }, belt = { 0.05, 0, -0.01, 0.8 }, left_foot = { 0.01, 0.18, -1.16, 1 }, left_ring = { -0.06, 0.34, -0.39, 0.8 }, back = { -0.11, -0.08, 0.18, 1.2 }, };

StdSlots["Orc-Male"] = { head = { 0.43, -0.02, 0.64, 1 }, leg_right_side = { 0.17, -0.32, -0.48, 1.5 }, chest = { 0.19, -0.02, 0.25, 1.3 }, face = { 0.47, -0.01, 0.5, 1 }, right_foot = { 0.04, -0.4, -1.11, 1.5 }, leg_left_side = { 0.15, 0.25, -0.47, 1.5 }, back = { -0.26, 0.01, 0.42, 2 }, belt = { 0.05, 0, -0.01, 1.5 }, left_foot = { 0.01, 0.31, -1.07, 1.5 }, left_ring = { 0.11, 0.51, -0.41, 0.8 }, right_ring = { 0.02, -0.59, -0.41, 0.8 }, };
StdSlots["Orc-Female"] = { head = { 0.03, 0, 0.58, 0.8 }, leg_right_side = { 0.08, -0.14, -0.27, 1 }, chest = { 0.05, 0.01, 0.3, 1 }, face = { 0.05, 0, 0.53, 1 }, right_foot = { 0.05, -0.15, -0.85, 1 }, leg_left_side = { 0.01, 0.13, -0.33, 1 }, right_ring = { -0.15, -0.3, -0.21, 0.8 }, belt = { 0.06, 0, 0.09, 1 }, left_foot = { -0.18, 0.14, -0.87, 1 }, left_ring = { -0.2, 0.31, -0.18, 0.8 }, back = { -0.19, -0.02, 0.29, 1.2 }, };

StdSlots["Tauren-Male"] = { head = { 0.5, 0.02, 0.69, 1 }, leg_right_side = { 0.14, -0.25, -0.48, 1.5 }, chest = { 0.23, -0.02, 0.25, 1.3 }, face = { 0.53, -0.01, 0.5, 1 }, right_foot = { -0.07, -0.27, -0.91, 1.5 }, leg_left_side = { 0.15, 0.25, -0.47, 1.5 }, right_ring = { 0.02, -0.56, -0.41, 0.8 }, back = { -0.26, 0.01, 0.42, 2 }, left_foot = { 0.3, 0.27, -0.92, 1.5 }, left_ring = { 0.02, 0.51, -0.41, 0.8 }, belt = { 0.13, 0, -0.01, 1.5 }, };
StdSlots["Tauren-Female"] = { head = { 0.28, 0, 0.32, 1 }, leg_right_side = { 0.08, -0.16, -0.7, 1.5 }, chest = { 0.17, -0.02, 0, 1.3 }, face = { 0.32, -0.01, 0.22, 1 }, right_foot = { 0, -0.16, -1.14, 1.5 }, leg_left_side = { 0.25, 0.16, -0.68, 1.5 }, belt = { 0.12, 0, -0.31, 1 }, back = { -0.25, 0.03, 0.06, 1.5 }, left_foot = { 0.21, 0.14, -1.12, 1.5 }, left_ring = { 0.1, 0.35, -0.66, 0.8 }, right_ring = { 0.02, -0.37, -0.47, 0.8 }, };

StdSlots["Dwarf-Male"] = { head = { 0.06, 0.01, 0.37, 1 }, leg_right_side = { 0.07, -0.18, -0.41, 1 }, chest = { 0.16, 0, 0.03, 1.5 }, face = { 0.09, 0.01, 0.3, 1 }, right_foot = { 0.031, -0.21, -0.72, 1.5 }, leg_left_side = { 0.15, 0.17, -0.39, 1 }, right_ring = { 0.02, -0.38, -0.32, 1 }, belt = { 0.001, 0, -0.14, 1 }, left_foot = { 0.22, 0.15, -0.67, 1.5 }, left_ring = { 0.01, 0.36, -0.36, 1 }, back = { -0.22, 0, 0.03, 1.5 }, }
StdSlots["Dwarf-Female"] = { head = { 0.06, 0.03, 0.26, 1 }, leg_right_side = { 0.07, -0.08, -0.36, 0.75 }, chest = { 0.11, 0.02, 0.03, 1 }, face = { 0.09, 0.02, 0.28, 0.7 }, right_foot = { 0.081, -0.05, -0.59, 0.8 }, leg_left_side = { 0.11, 0.13, -0.35, 0.75 }, back = { -0.12, -0.01, 0.03, 1 }, belt = { 0.001, 0, -0.14, 0.75 }, left_foot = { 0.09, 0.15, -0.58, 0.75 }, left_ring = { 0.01, 0.28, -0.21, 0.75 }, right_ring = { 0.02, -0.24, -0.23, 0.75 }, };

StdSlots["Gnome-Male"] = { head = { 0.12, 0.01, 0.26, 1 }, leg_right_side = { 0.07, -0.08, -0.36, 0.75 }, chest = { 0.11, 0.02, 0.03, 1 }, face = { 0.09, 0.02, 0.28, 0.7 }, right_foot = { 0.081, -0.15, -0.59, 0.8 }, leg_left_side = { 0.11, 0.13, -0.35, 0.75 }, right_ring = { 0.02, -0.24, -0.23, 0.75 }, back = { -0.12, -0.01, 0.03, 1 }, left_foot = { 0.09, 0.15, -0.58, 0.75 }, left_ring = { 0.01, 0.28, -0.21, 0.75 }, belt = { 0.001, 0, -0.14, 0.75 }, };
StdSlots["Gnome-Female"] = { head = { 0.12, 0.01, 0.34, 0.75 }, leg_right_side = { 0.07, -0.08, -0.21, 0.75 }, chest = { 0.11, 0, 0.03, 0.75 }, face = { 0.09, 0, 0.22, 0.7 }, right_foot = { 0.081, -0.15, -0.33, 0.8 }, leg_left_side = { 0.01, 0.07, -0.21, 0.75 }, right_ring = { 0.01, -0.2, -0.12, 0.75 }, belt = { 0.001, 0, -0.06, 0.75 }, left_foot = { 0.03, 0.15, -0.32, 0.75 }, left_ring = { 0.01, 0.22, -0.12, 0.75 }, back = { -0.12, -0.01, 0.03, 1 }, };

-- copy of gnome
StdSlots["Goblin-Male"] = { head = { 0.12, 0.01, 0.26, 1 }, leg_right_side = { 0.07, -0.08, -0.36, 0.75 }, chest = { 0.11, 0.02, 0.03, 1 }, face = { 0.09, 0.02, 0.28, 0.7 }, right_foot = { 0.081, -0.15, -0.59, 0.8 }, leg_left_side = { 0.11, 0.13, -0.35, 0.75 }, right_ring = { 0.02, -0.24, -0.23, 0.75 }, back = { -0.12, -0.01, 0.03, 1 }, left_foot = { 0.09, 0.15, -0.58, 0.75 }, left_ring = { 0.01, 0.28, -0.21, 0.75 }, belt = { 0.001, 0, -0.14, 0.75 }, };
StdSlots["Goblin-Female"] = { head = { 0.12, 0.01, 0.34, 0.75 }, leg_right_side = { 0.07, -0.08, -0.21, 0.75 }, chest = { 0.11, 0, 0.03, 0.75 }, face = { 0.09, 0, 0.22, 0.7 }, right_foot = { 0.081, -0.15, -0.33, 0.8 }, leg_left_side = { 0.01, 0.07, -0.21, 0.75 }, right_ring = { 0.01, -0.2, -0.12, 0.75 }, belt = { 0.001, 0, -0.06, 0.75 }, left_foot = { 0.03, 0.15, -0.32, 0.75 }, left_ring = { 0.01, 0.22, -0.12, 0.75 }, back = { -0.12, -0.01, 0.03, 1 }, };


GH_Display_BG_List = {
	{ p = "", x = 128, y = 256 },
	{ p = "Interface\\AddOns\\GHI\\texture\\Alliance.tga", x = 128, y = 256 },
	{ p = "Interface\\AddOns\\GHI\\texture\\HordeBgs.tga", x = 128, y = 256 },
	{ p = "Interface\\AddOns\\GHI\\texture\\Scarlet.tga", x = 128, y = 256 },
	{ p = "Interface\\AddOns\\GHI\\texture\\Forsaken.tga", x = 128, y = 256 },


	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_matte.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\rg_jlo_BloodElf_DoorTrim_01.blp", x = 128, y = 256 },



	{ p = "Interface\\GLUES\\MODELS\\UI_BLOODELF\\RG_MM_CLOUDS_03.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_CharacterSelect\\UI_CharactersClouds.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_DeathKnight\\IceCrown_Clouds_Unholy01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_DRAENEI\\draenei_platform_crystal.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Dwarf\\dwarfsky.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Dwarf\\snow.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Dwarf\\dwarfsky.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Human\\caustic02.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Human\\MM_clouds_03.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Human\\MM_sky_02.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DarkPortal_platform_01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DarkPortal_stone_01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DarkPortal_trim_01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\DurotarRock03.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\MM_clouds_01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\MM_sky_01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\mm_thorns_01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\swordgradient.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MAINMENU\\SWORDGRADIENT2.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MainMenu_BurningCrusade\\dp_Lightning2.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_MainMenu_BurningCrusade\\dp_Lightning2b.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_moonwell_glow.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_NE_clouds.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_NE_ground.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\aa_NE_sky.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\caustic01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\causticblend.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_NightElf\\KalidarMidTree_purple01.blp", x = 128, y = 256 },
	{ p = "Interface\\GLUES\\MODELS\\UI_Tauren\\sky1.blp", x = 128, y = 256 },
}


local function drawsize(size)
	return size * GetCVar("uiscale") / 0.85;
end

local miscApi;
local containerApi;

function New_GH_Display(parent)
	local i = 1000;
	while (_G["GH_D" .. i]) do
		i = i + 1;
	end
	return GH_Display:Create("GH_D" .. i, parent);
end

GH_Display = {}
GH_Display.__index = GH_Display;
GH_Display.hooked = {};

-- 	standard
local loc = GHI_Loc();
function GH_Display:Create(varName, parent)

	_G[varName] = GH_Display;

	local obj = {} -- our new object
	setmetatable(obj, _G[varName]) -- make GHU_Talent handle lookup

	-- obj.data = 1
	obj.display = CreateFrame("DressUpModel", varName .. "Display", parent or UIParent, "GHDisplayTemplate");
	obj.display.type = "GH_DisplayDressUpModel";
	obj.display:SetFrameStrata("MEDIUM");
	obj.display.main = obj;
	local n = obj.display:GetName();
	_G[n .. "RotateRightButton"]:SetFrameStrata("MEDIUM");
	_G[n .. "RotateLeftButton"]:SetFrameStrata("MEDIUM");
	_G[n .. "ZoomInButton"]:SetFrameStrata("MEDIUM");
	_G[n .. "ZoomOutButton"]:SetFrameStrata("MEDIUM");

	obj.display:SetScript("OnShow", function(self)
		self.rotation = 0;
		self.x = 0;
		self.y = 0;
		self.z = 0;
		--print("OnShow");
		self:SetRotation(0);
		self:SetPosition(0, 0, 0);
		--if not(self.orig_SetPos) then self.orig_SetPos = self.SetPosition end
		--self.SetPosition = function(t,...) print(...); t.orig_SetPos(t,...); end;
		self.main:Update(true);

		--self.main:SetPosition(self.main.x,self.main.y,self.main.z);
		self.type = "GH_Display";
	end);

	--bgFile = "Interface/Tooltips/UI-Tooltip-Background"

	obj.objects = {};

	-- insert calibration lines
	if calibrate then
		obj.display.texture1 = obj.display:CreateTexture()
		obj.display.texture1:SetPoint("LEFT", obj.display, "LEFT", 0, 0);
		obj.display.texture1:SetPoint("RIGHT", obj.display, "RIGHT", 0, 0);
		obj.display.texture1:SetHeight(1);
		obj.display.texture1:SetTexture(1.0, 0.0, 0.0, 0.5);

		obj.display.texture2 = obj.display:CreateTexture()
		obj.display.texture2:SetPoint("LEFT", obj.display, "LEFT", 0, 60);
		obj.display.texture2:SetPoint("RIGHT", obj.display, "RIGHT", 0, 60);
		obj.display.texture2:SetHeight(1);
		obj.display.texture2:SetTexture(0.0, 1.0, 0.0, 0.5);

		obj.display.texture3 = obj.display:CreateTexture()
		obj.display.texture3:SetPoint("LEFT", obj.display, "LEFT", 0, -80);
		obj.display.texture3:SetPoint("RIGHT", obj.display, "RIGHT", 0, -80);
		obj.display.texture3:SetHeight(1);
		obj.display.texture3:SetTexture(0.0, 0.0, 1.0, 0.5); --]]
	end

	_G[varName] = obj;
	return obj;
end

function GH_Display:CreateStandaloneFrame()
	if not (self.parent) then
		-- Create the frame for Normal background and border
		local f = CreateFrame("Frame", self.display:GetParent());

		f:SetPoint("CENTER", UIParent);
		f:SetWidth(drawsize(128));
		f:SetHeight(drawsize(256));
		f:SetFrameStrata("LOW");

		--[[
		local bg = ""--"Interface/GLUES/MODELS/UI_MAINMENU/MM_sky_01";
		f:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile =  bg, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
		f:SetFrameLevel(1);
		f:SetFrameStrata("BACKGROUND"); --]]
		local f2 = CreateFrame("Frame", f);
		f2:SetPoint("CENTER", f);
		f2:SetWidth(drawsize(128));
		f2:SetHeight(drawsize(256));
		f2:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = "", edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
		f2:SetFrameLevel(2);
		f2:SetFrameStrata("LOW");
		f.bgFrame = f2;


		-- create extra black backdrop frame, which is only shown when there is no other background
		local f2 = CreateFrame("Frame", f);
		f2:SetPoint("CENTER", f);
		f2:SetWidth(drawsize(128));
		f2:SetHeight(drawsize(256));
		f2:SetBackdrop({ edgeFile = "", bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark", edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
		f2:SetFrameLevel(1);
		f2:SetFrameStrata("BACKGROUND");
		f.black = f2;

		self.display:SetPoint("CENTER", f);


		-- Bar with name
		local p = CreateFrame("Button", self.display:GetName() .. "_Bar", self.display);
		p:SetWidth(self.display:GetWidth() + 10);
		p:SetHeight(16);
		p.main = self;
		p:SetPoint("TOP", 0, 14);
		--p:SetScript("OnClick",print);

		p:RegisterForDrag("LeftButton")
		p:SetMovable();

		p:SetScript("OnUpdate", function(b) if b.drag then GHI_DragEqDisplay(b.main) end end)
		p:SetScript("OnDragStart", function(b) b.drag = true; GHI_DragEqDisplay(b.main, nil, 1) end)
		p:SetScript("OnDragStop", function(b) b.drag = false; GHI_DragEqDisplay(b.main, nil, 2) end)

		local pf = p:CreateFontString();
		--pf:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
		pf:SetFontObject("GameFontHighlight");
		pf:SetText(self.name);
		pf:SetPoint("CENTER", 0, 0, p);
		pf:Show();
		self.nameString = pf;

		local bg = "Interface/RAIDFRAME/UI-RaidFrame-GroupBg"; --Interface/Tooltips/UI-Tooltip-Border
		p:SetBackdrop({ edgeFile = "", bgFile = bg, edgeSize = 0, tile = false, insets = { left = 0, right = 0, top = 0, bottom = 0 } });
		p:SetFrameStrata("MEDIUM");
		p:SetFrameLevel(1);

		-- close Button
		local b = CreateFrame("Button", self.display:GetName() .. "_Close", p, "UIPanelCloseButton");
		b:SetPoint("RIGHT", p, "RIGHT", 10, 0);
		b.main = self;

		f.main = self;
		self.parent = f;

		f:Show();



		-- register for container anchors
		GHI_ContainerAnchorFrame(self.parent, "display");
	end
end

function GH_Display:SetUnit(unit)
	if not (UnitExists(unit) and UnitRace(unit)) then
		self.CamPos = { 0, 0, 0 };
		self.CamDir = { 1, 0, 0 };
		return
	end

	self.display:SetUnit(unit);
	-- self.display:
	--self.display:SetModel("World\\ArtTest\\Boxtest\\xyz.m2");
	-- 
	self.name = UnitName(unit);
	if self.nameString then
		self.nameString:SetText(self.name);
	end

	local _, race = UnitRace(unit);
	local gender = UnitSex(unit);
	if gender == 2 then gender = "Male";
	else gender = "Female"
	end

	local s = race .. "-" .. gender;
	if not (type(CamPos[s]) == "table") then
		GHI_Message(format("No camera position data found for %s %s.", race, gender));
		self.CamPos = { 0, 0, 0 }
	else
		self.CamPos = CamPos[s];
		--print("Campos",self.CamPos[1],self.CamPos[2],self.CamPos[3]);
	end

	if not (type(CamDir[s]) == "table") then
		GHI_Message(format("No camera direction data found for %s %s.", race, gender));
		self.CamDir = { -1, 0, 0 }
	else
		self.CamDir = CamDir[s];
		--print("Camdir",self.CamDir[1],self.CamDir[2],self.CamDir[3]);
	end
end

function GH_Display:Update(forceChange)
	local change = forceChange;
	if not ((self.lastRotation or 0) == self.display:GetFacing()) then
		change = true;
	end


	local r = { self.display:GetPosition() };
	self.lastPosition = self.lastPosition or {};

	if self.dragged then
		local now = { GetCursorPosition() };
		local last = self.lastDragPos;
		if not (now[1] == last[1]) or not (now[2] == last[2]) then
			r[2] = r[2] + (now[1] - last[1]) / 100;
			r[3] = r[3] + (now[2] - last[2]) / 100;

			if (abs(atan(r[2], r[1])) < 45 and abs(atan(r[3], r[1])) < 65) or calibrate then
				self.lastDragPos = now;
				self.display:SetPosition(unpack(r));
				self.display.x = r[1];
				self.display.y = r[2];
				self.display.z = r[3];


				change = true;
			end
		end
	elseif not (self.lastPosition[1] == r[1] and self.lastPosition[2] == r[2] and self.lastPosition[3] == r[3]) then
		change = true;
	end

	if change then
		self.lastRotation = self.display:GetFacing();
		self.lastPosition = r;

		for i, o in pairs(self.objects) do

			o.object:Update(self, o.frame);
		end



		--[[
		local x,y,z = unpack(self.lastPosition);
		local a = deg(self.lastRotation);
		objX,objY,objZ = 0.1, 0.2, 0.1 -- relative to center of model
		rx,ry = (cos(a)*objX - objY*sin(a)),(sin(a)*objX + objY*cos(a));
		local behind;
		if rx < 0 then
			behind = true;
		end --]]
		--self:TestAt(x + rx,y + ry,z + objZ,behind);
	end
end

function GH_Display:AddObject(o) -- o is a GH_DO
	local new = {};

	new.object = o;


	-- create the frame
	local f = CreateFrame("Button", nil, self.display)
	if self.strata then
		f:SetFrameStrata(self.strata);
	else
		f:SetFrameStrata("MEDIUM")
	end
	f:SetAlpha(1);
	f:SetWidth(32);
	f:SetHeight(32);
	local t = f:CreateTexture(nil, "BACKGROUND");

	t:SetAllPoints(f);
	f.texture = t;
	f.object = o;

	-- setup clicks etc
	f:RegisterForClicks("AnyUp");
	f:SetScript("OnClick", o.OnClick);
	f:SetScript("OnEnter", o.OnEnter);
	f:SetScript("OnLeave", o.OnLeave);


	new.frame = f;



	table.insert(self.objects, new);
	self.version = time()
end


function GH_Display:SetObjects(objs) -- objs being a table of GH_DO

	assert(type(objs) == "table" and type(objs[1]) == "table", "Usage objs (table of GH_DO)");
	self:ClearAllObjects();
	self.objects = {};

	for _, o in pairs(objs) do
		self:AddObject(o);
	end
	self:Update(true);
end

function GH_Display:GetNumObjects()
	return #(self.objects or {});
end

function GH_Display:SetFrameStrata(strata)
	self.display:SetFrameStrata(strata);
	self.strata = strata;
end

function GH_Display:SetFrameLevel(lvl)
	self.display:SetFrameLevel(lvl);
	self.frameLevel = lvl;
end

function GH_Display:SetBackground(path)
	if self.parent then
		self.parent.bgFrame:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = path, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
	end
end

function GH_Display:ClearAllObjects()

	-- go trough all objects, hide them and dispose their frames
	if type(self.objects) == "table" then
		for i = 1, #(self.objects) do
			if type(self.objects[i]) == "table" then
				self.objects[i].frame:Hide();
			end
		end
		wipe(self.objects);
	end
end

function GH_Display:GetOverlayPos(objX, objY, objZ) -- x,y,z are relative to center of model. Returns ox,oy,scale,isBehind

	local fx, fy, fz = unpack(self.lastPosition);
	local a = deg(self.lastRotation);
	local rx, ry, rz = (cos(a) * objX - objY * sin(a)), (sin(a) * objX + objY * cos(a)), objZ;
	local x, y, z = fx + rx, fy + ry, fz + rz;
	local isBehind;
	if rx < 0 then
		isBehind = true;
	end

	local cpX, cpY, cpZ = unpack(self.CamPos);
	local cdX, cdY, cdZ = unpack(self.CamDir);
	local coX, coY, coZ = x - cpX, y - cpY, z - cpZ;
	local ay = GetVectorAngle(coX, coY, cdX, cdY);
	local az = GetVectorAngle(coX, coZ, cdX, cdZ);
	local dist = sqrt(coX * coX, coY * coY, coZ * coZ);
	local k = 337;

	local overlay_x = tan(ay) * k;
	local overlay_y = tan(az) * k;

	if coY / coX > -cdY then
		overlay_x = -overlay_x;
	end

	if coZ / coX > -cdZ then
		overlay_y = -overlay_y;
	end
	local scale = 1 / dist;

	return overlay_x, overlay_y, scale, isBehind;
end

function GH_Display:Show()
	if self.parent then
		self.parent:Show();
		if self.parent.black then
			self.parent.black:Show();
		end
		if self.parent.bgFrame then
			self.parent.bgFrame:Show();
		end
		if self.parent.anchorPlate then
			self.parent.anchorPlate:Show();
		end
	end

	self.display:Hide();
	self.display:Show();
	GHI_UpdateContainerFrameAnchors()
end

function GH_Display:Hide() --print("hide");
	if self.parent then
		self.parent:Hide();
		self.display:Hide(); --print("hiding parent",self.parent.black)
		if self.parent.black then
			self.parent.black:Hide();
		end
		if self.parent.bgFrame then
			self.parent.bgFrame:Hide();
		end
	else
		self.display:Hide();
	end
	if self.parent.anchorPlate then
		self.parent.anchorPlate:Hide();
	end
	--GHI_updateContainerFrameAnchors() 
	if self.disposeOnHide then
		GHI_RemoveAnchorFrame(self.parent.anchorPlate);
		table.wipe(self.parent);
		table.wipe(self);
	else
		GHI_UpdateContainerFrameAnchors();
	end
end

function GH_Display:IsShown()
	if self.parent then
		return self.parent:IsShown();
	else
		return self.display:IsShown();
	end
end

function GH_Display:ShowEmpty(show)
	self.showEmpty = show;
	self:Update(true);
end

function GH_Display:GetStdSlotList()
	local _, race = UnitRace("player");
	local gender = UnitSex("player");
	if gender == 2 then
		gender = "Male";
	else
		gender = "Female"
	end
	local s = race .. "-" .. gender;

	local t = {};
	for i, _ in pairs(StdSlots[s] or {}) do
		table.insert(t, i);
	end
	return t;
end

function GH_Display:GetStdSlotCoor(val)
	local _, race = UnitRace("player");
	local gender = UnitSex("player");
	if gender == 2 then
		gender = "Male";
	else
		gender = "Female"
	end
	local s = race .. "-" .. gender;

	return (StdSlots[s] or {})[val];
end


function GH_Display:TestAt(x, y, z, behind)
	--x,y,z,behind = -10,0,1.2,nil;
	if not (self.TestFrame) then
		local f = CreateFrame("Frame", nil, self.display)
		f:SetFrameStrata("MEDIUM")
		f:SetWidth(16);
		f:SetHeight(16);
		local t = f:CreateTexture(nil, "BACKGROUND")
		t:SetTexture("Interface\\QuestFrame\\UI-Quest-BulletPoint.blp")
		t:SetAllPoints(f)
		f.texture = t
		f:Show();
		self.TestFrame = f;
	end

	if behind then
		self.TestFrame:SetFrameStrata("LOW")
	else
		self.TestFrame:SetFrameStrata("MEDIUM")
	end

	local width = 0.16;

	--[[
	 	Faction checked:
		Night elf male: 528.66 and 4.0436;
	Tauren male: 528.66 and 4.0436; (acceptable but not perfect)
	Dwarf male and gnome female: (being off when zooming far in)

	end ]]


	--[[
	k1 = k1 or 528.66; --259.7138030;
	k2 = k2 or 4.0436; --3.1--2.9;
	--K3 values:
	--	0.0978  good for dwarves when z = 0.5 and y = 0.5
	--
	k3 = k3 or 1; 
	local overlay_y = ((k1*y)/(k2-x));
	local overlay_z = ((k1*z)/(k2-x))*k3;
	local scale = (k1*(y+width)/(k2-x))-overlay_y;--]]

	local cpX, cpY, cpZ = unpack(self.CamPos);
	local cdX, cdY, cdZ = unpack(self.CamDir);

	local coX, coY, coZ = x - cpX, y - cpY, z - cpZ;
	--coX,coY,coZ = -1,0,0.0891;
	--print(format("co(%s,%s,%s)",coX,coY,coZ));
	local ay = GetVectorAngle(coX, coY, cdX, cdY);
	local az = GetVectorAngle(coX, coZ, cdX, cdZ);

	local dist = sqrt(coX * coX, coY * coY, coZ * coZ);
	--print(format("ys %s %s",coY,cdY));
	--print(format("Az = %s deg",az));

	k = k or 337;

	local overlay_y = tan(ay) * k;
	local overlay_z = tan(az) * k;

	if coY < cdY then
		overlay_y = -overlay_y;
	end

	if coZ < cdZ then
		overlay_Z = -overlay_Z;
	end

	--print(format("tan(%s)*%s = %s",az,k,tan(az)*k));
	--overlay_z = 51;

	local scale = 1 / dist; -- todo calculate self
	--print(scale);

	self.TestFrame:SetHeight(scale * 20);
	self.TestFrame:SetWidth(scale * 20);
	self.TestFrame:SetPoint("CENTER", overlay_y, overlay_z);
end

function Model_OnUpdate2(self, elapsedTime, rotationsPerSecond)
	if (not rotationsPerSecond) then
		rotationsPerSecond = ROTATIONS_PER_SECOND;
	end
	if (_G[self:GetName() .. "RotateLeftButton"]:GetButtonState() == "PUSHED") then
		self.rotation = self.rotation + (elapsedTime * 2 * PI * rotationsPerSecond);
		if (self.rotation < 0) then
			self.rotation = self.rotation + (2 * PI);
		end
		self:SetRotation(self.rotation);
	end
	if (_G[self:GetName() .. "RotateRightButton"]:GetButtonState() == "PUSHED") then
		self.rotation = self.rotation - (elapsedTime * 2 * PI * rotationsPerSecond);
		if (self.rotation > (2 * PI)) then
			self.rotation = self.rotation - (2 * PI);
		end
		self:SetRotation(self.rotation);
	end
	if (_G[self:GetName() .. "ZoomInButton"]:GetButtonState() == "PUSHED") then
		self.x = min(self.x + elapsedTime, 1.4);
		self:SetPosition(self.x, self.y, self.z);
	end
	if (_G[self:GetName() .. "ZoomOutButton"]:GetButtonState() == "PUSHED") then
		self.x = max(self.x - elapsedTime, (calibrate and -29) or -1.5);
		self:SetPosition(self.x, self.y, self.z);
	end
end


function GetVectorAngle(ax, ay, bx, by) -- from http://www.allegro.cc/forums/thread/591460/673459

	local dotproduct, lengtha, lengthb, result;

	dotproduct = (ax * bx) + (ay * by);
	lengtha = sqrt(ax * ax + ay * ay);
	lengthb = sqrt(bx * bx + by * by);

	result = acos(dotproduct / (lengtha * lengthb));

	--GHI_Message(format("dot %s, lenA %s, lenB %s, res %s",dotproduct,lengtha,lengthb,result or "nil"));

	if (dotproduct < 0) then
		if (result > 0) then
			result = result + math.pi;
		else
			result = result - math.pi;
		end
	end
	return result;
end

--[[	GH Display Object
--]]
GH_DO = {}
GH_DO.__index = GH_DO;

-- 	standard
function GH_DO:Create(x, y, z, scale, name, icon, clickFunc, tooltipType, refID, codeReq)
	assert((type(x) == "number" and type(y) == "number" and type(z) == "number" and type(icon) == "string") or type(x) == "table", "Usage num,num,num,num,string,[func]");

	local i = 1000;
	while (_G["GH_DO" .. i]) do
		i = i + 1;
	end
	varName = "GH_DO" .. i;

	_G[varName] = GH_DO;

	local obj = {} -- our new object
	setmetatable(obj, _G[varName])
	if type(x) == "table" then
		obj:Deserialize(x);
	else
		obj.x = x;
		obj.y = y;
		obj.z = z;
		obj.scale = scale;
		obj.icon = icon;
		obj.clickFunc = clickFunc;
		obj.tooltipType = tooltipType;
		obj.refID = refID;
		obj.name = name;
		obj.codeReq = codeReq;
	end
	obj.type = "GH_DO";
	_G[varName] = obj;
	return obj;
end

function GH_DO:SetInfo(ref, icon)
	self.refID = ref;
	self.icon = icon;
end


function GH_DO:Update(display, frame) -- show or update


	local ox, oy, scale, isBehind = display:GetOverlayPos(self.x, self.y, self.z);

	--print((abs(oy) + scale*16)," > ",(display.display:GetHeight() / 2));

	if (abs(oy) + scale * 16) > (display.display:GetHeight() / 2) then
		--print("Too high");
		frame:Hide();
		return;
	end

	if (abs(ox) + scale * 16) > (display.display:GetWidth() / 2) then
		frame:Hide();
		return;
	end

	if self.refID == 0 and not (display.showEmpty) then
		frame:Hide();
		return;
	end

	if type(self.codeReq) == "string" and string.len(self.codeReq) > 0 then
		SHOW = false;
		GHI_DoScript(self.codeReq);
		if not (SHOW == true) then
			frame:Hide()
			return;
		end
	end

	frame.texture:SetTexture(self.icon);

	if isBehind then
		if display.strata then
			frame:SetFrameStrata(display.strata);
			frame:SetFrameLevel((display.frameLevel or 1) - 1);
		else
			frame:SetFrameStrata("LOW");
		end
	else
		if display.strata then
			frame:SetFrameLevel((display.frameLevel or 1) + 1);
		else
			frame:SetFrameStrata("MEDIUM")
		end
	end

	frame:SetHeight(scale * 32 * (self.scale or 1));
	frame:SetWidth(scale * 32 * (self.scale or 1));
	frame:SetPoint("CENTER", ox, oy);
	--print(format("%s , %s",ox,oy));



	frame:Show();
end

function GH_DO:OnClick(...)
	if self.object.clickFunc then
		self.object.clickFunc(self, ...);
	end
end

function GH_DO:OnEnter(...)
	if self.object.tooltipType then
		GHI_EqDisplayOnEnter(self, self.object.tooltipType);
		--self.object.tooltipFunc(...);
	end
end

function GH_DO:OnLeave(...)
	if self.object.tooltipType then
		GameTooltip:Hide();
	end
end

function GH_DO:Serialize()
	local t = {
		x = self.x,
		y = self.y,
		z = self.z,
		scale = self.scale,
		icon = self.icon,
		refID = self.refID,
		name = self.name,
		tooltipType = self.tooltipType
	};
	--print(sending)
	--GHI_PrintArray(t);
	return t;
end

function GH_DO:Deserialize(t)
	if not (type(t) == "table") then return end;
	self.x = t.x;
	self.y = t.y;
	self.z = t.z;
	self.scale = t.scale;
	self.icon = t.icon;
	self.refID = t.refID;
	self.name = t.name;
	self.tooltipType = t.tooltipType;
	--GHI_PrintArray(self)
end


-- =========================================
--				GHI Display USE
-- =========================================

local PD; -- player display
local Displays = {}; -- target display and other displays
local EnabledAsStd = { "neck" }
GHI_EquipmentDisplayData = GHI_EquipmentDisplayData or {};

local function SetPositionInfo(slot, id)
	local pos = GHI_EquipmentDisplayData.pos or {};
	pos[slot] = { ItemID = id };
	GHI_EquipmentDisplayData.pos = pos;
	GHI_UpdatePlayerEquipmentDisplay()
end

function GHI_SetCustomSlotInfo(slotRef, info)
	local customSlots = GHI_EquipmentDisplayData.customSlots or {};
	customSlots[slotRef] = info
	GHI_EquipmentDisplayData.customSlots = customSlots;

	-- update the display frame
	local ref = 0;
	local icon = "Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp";

	local o = GH_DO:Create(info.x, info.y, info.z, info.scale, info.name, icon, GHI_EqDisplayOnClick, GHI_EqDisplayOnEnter, ref or info.ref);
	o.SetPositionInfo = SetPositionInfo;
	o.slotRef = slotRef; -- ref for position data
	PD:AddObject(o);
	PD:Update(true);
	GHI_UpdatePlayerEquipmentDisplay();
end

function GHI_GetPlayerEquipmentDisplay()
	if not (PD) then
		--GHI_ShowPlayerEquipmentDisplay();  -- would give loop
		--PD:Hide();
		return;
	end
	return PD
end

function GHI_ShowPlayerEquipmentDisplay()
	if PD and PD.display and PD.display:IsShown() then
		PD:Hide();
		return;
	end
	if PD then
		PD:Show();
		PD.display:SetUnit("player"); -- update the 3d itself
	else
		-- show the menu for new slot and hide it (fixes it being i the wrong layer)
		local loc = GHI_Loc();
		local f = GHM_NewFrame(self, GHI_NCS_Menu);
		f:Hide();

		PD = New_GH_Display();
		PD:SetUnit("player");
		PD:CreateStandaloneFrame();
		PD:Show();

		-- Create buttons (std slot, custom slot, background, settings)
		local btns = {
			{ ref = "DisplayedSlots", short = loc.SELECT_DISPLAYED_SLOTS_SHORT, name = loc.SELECT_DISPLAYED_SLOTS }, -- todo: localize
			{ ref = "NewSlot", short = loc.NEW_CUSTOM_SLOT_SHORT, name = loc.NEW_CUSTOM_SLOT },
			{ ref = "background", short = loc.BACKGROUND_SHORT, name = loc.BACKGROUND },
			--{ref="options",short="Op",name="Equipment Display Options?"}, -- needed at all?  Used for: Show Weapons?
		}
		if calibrate then
			table.insert(btns, { ref = "calPrt", short = "prt", name = "Save position (for calibration)" });
			table.insert(btns, { ref = "showCal", short = "show", name = "Show saved positions (for calibration)" });
		end
		local margin = 5;
		local width = ((PD.display:GetWidth() - margin) / #(btns));
		for i = 1, #(btns) do
			local b = CreateFrame("Button", "GHI_PDBtn_" .. btns[i].ref, PD.display, "UIPanelButtonTemplate");
			b.ref = btns[i].ref;
			b:SetText(btns[i].short);
			b.tttext = btns[i].name;
			b:SetWidth(width - margin);
			b:SetHeight(20);
			b:SetPoint("BOTTOMLEFT", margin + ((i - 1) * width), margin);

			b:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(self.tttext, 1, 0.8196079, 0);
			GameTooltip:Show()
			self.UpdateTooltip = nil;
			end);
			b:SetScript("OnLeave", function() GameTooltip:Hide(); end);
			b:SetScript("OnClick", function(self) GHI_PlayerEDBtnClick(self.ref); end);
		end

		-- close button
		--local b = CreateFrame("Button","GHI_PDB_Close",PD.display,"UIPanelCloseButton");
		--b:SetPoint("TOPRIGHT",17,17);
		--b.main = PD;
		local b = _G[PD.display:GetName() .. "_Close"];
		b:SetScript("OnClick", function(self) self.main:Hide(); end);

		-- initialize data first time 
		if GHI_EquipmentDisplayData == nil then
			GHI_EquipmentDisplayData = {};
		end
		if GHI_EquipmentDisplayData.stdEnabled == nil then
			GHI_EquipmentDisplayData.stdEnabled = PD:GetStdSlotList();
		end


		GHI_UpdatePlayerEquipmentDisplay()
		PD:ShowEmpty(not (GHI_MiscData["hide_empty_slots"]));
	end
	GHI_UpdateContainerFrameAnchors()
end


function GHI_UpdatePlayerEquipmentDisplay()
	if not (PD) then return end;


	local data = GHI_EquipmentDisplayData or {};
	local pos = data.pos or {};
	local stdEnabled = data.stdEnabled or {};
	local customSlots = data.customSlots or {};
	local bg = data.background or "";

	local objs = {};

	--background
	PD:SetBackground(bg)

	-- insert all standard slots
	for _, slot in pairs(stdEnabled) do
		local coor = PD:GetStdSlotCoor(slot);
		--print(type(coor));
		if type(coor) == "table" then
			local icon = "Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp";
			local ref = 0; -- empty
			if type(pos[slot]) == "table" then
				local id = pos[slot].ItemID;
				if id then
					_, icon = containerApi.GHI_GetItemInfo(id);
					ref = id;
				end
			end

			local name = loc["SLOT_NAMES_"..str.upper(slot)] or "";

			--print("insert");
			local o = GH_DO:Create(coor[1], coor[2], coor[3], coor[4], name, icon, GHI_EqDisplayOnClick, "GHI", ref);
			o.SetPositionInfo = SetPositionInfo;
			o.slotRef = slot; -- ref for position data
			table.insert(objs, o);
		end
	end

	-- insert custom slots

	for id, slot in pairs(customSlots) do
		if slot.enabled == true then
			local ref = 0;
			local icon = "Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp";
			if type(pos[id]) == "table" then
				local id = pos[id].ItemID;
				if id then
					_, icon = containerApi.GHI_GetItemInfo(id);
					ref = id;
				end
			end

			local o = GH_DO:Create(slot.x, slot.y, slot.z, slot.scale, slot.name, icon, GHI_EqDisplayOnClick, "GHI", ref, slot.code);
			o.SetPositionInfo = SetPositionInfo;
			o.slotRef = id; -- ref for position data
			table.insert(objs, o);
		end
	end

	-- todo: go trough all slots, looks at their items RC actions and insert eventual armor?

	-- set slots
	if #(objs) > 0 then
		PD:SetObjects(objs);
	else
		PD:ClearAllObjects();
	end

	GHI_EqDisplayUpdated()
end

function GHI_PlayerEDBtnClick(btnRef)
	if btnRef == "NewSlot" then
		GHI_ShowNewSlotMenu();
	elseif btnRef == "calPrt" then
		local x, y, z = PD.display:GetPosition();

		local f = GHM_NewFrame(self, GHI_Calb_Menu);
		local c = f.GetLabel("code") or "";

		c = format("%s%f	%f\n", c, x, z);
		c = gsub(c, "%.", ",");
		print("Coordinates saved");
		f.ForceLabel("code", c);
	elseif btnRef == "showCal" then
		local f = GHM_NewFrame(self, GHI_Calb_Menu);
		f:Show();
	elseif btnRef == "background" then
		local f = GHM_NewFrame(self, GHI_BackgroundMenu);
		--local t = GHM_StockIcons[ "Spell" ] local l={}; for i =1,20 do table.insert(l,{p="Interface\\Interface\\Icons\\"..t[random(#(t))]}); end 
		GHI_ED_BackgroundMenu_P1_L1_O1.SetImages(GH_Display_BG_List)
		f.ForceLabel("img", GHI_EquipmentDisplayData.background) -- force current showed BG
		f:Show();
	elseif btnRef == "DisplayedSlots" then
		local f = GHM_NewFrame(self, GHI_DisplayedSlotMenu);
		local list = f.GetLabelFrame("list");
		local slots = PD:GetStdSlotList();
		local edit = f.GetLabelFrame("edit");
		edit:Disable();

		list.Clear()
		for i = 1, #(slots) do
			local enabled = false;
			for _, enabled_slot in pairs(GHI_EquipmentDisplayData.stdEnabled or {}) do
				if (slots[i] == enabled_slot) then
					enabled = true;
				end
			end
			list.InsertTuble({ name = loc["SLOT_NAMES_"..str.upper(slots[i])] or slots[i], id_name = slots[i], check = enabled, type = loc.STANDARD });
		end
		for id, slot in pairs(GHI_EquipmentDisplayData.customSlots or {}) do
			list.InsertTuble({ name = slot.name, check = slot.enabled, type = loc.CUSTOM, isCustom = true, id = id });
		end
		f:Show();
	end
end


function GHI_EqDisplayOnClick(self, btn, ...)


	local obj = self.object;
	local id = obj.refID;

	local objGotItem = (not (id == 0) and id);
	local cursorGotRealItem = CursorHasItem();

	local cursor, cursorContainerGuid, cursorSlotID = miscApi.GHI_GetCurrentCursor();
	local cursorGotGHIItem = (cursor == "GHI_ITEM" or cursor == "GHI_ITEM_REF");

	if btn == "RightButton" and objGotItem then
		local containerGuid, slotID = containerApi.GHI_FindOneItem(id);
		if containerGuid then
			containerApi.GHI_UseItem(containerGuid, slotID);
		end
		return
	end


	if cursorGotRealItem then
		return; --ClearCursor();
	end

	-- if objGotItem then
	-- save the item temp
	-- end

	if cursorGotGHIItem then
		local guid, iconTexture = containerApi.GHI_GetContainerItemInfo(cursorContainerGuid, cursorSlotID)
		if cursor == "GHI_ITEM_REF" then
			guid = cursorContainerGuid;
			_, iconTexture = containerApi.GHI_GetItemInfo(guid);
		end
		obj:SetInfo(guid, iconTexture);
		PD:Update(true);

		SetPositionInfo(obj.slotRef, guid);

		miscApi.GHI_ClearCursor();
		GameTooltip:Hide();
		GHI_EqDisplayOnEnter(btn, ...);
		GHI_EqDisplayUpdated()
	else
		obj:SetInfo(0, "Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp");
		PD:Update(true);
		GameTooltip:Hide();

		local temp = {};
		local name, icon = containerApi.GHI_GetItemInfo(id);

		miscApi.GHI_SetCursor("ITEM", icon, nil, nil, "GHI_ITEM_REF", id);
		SetPositionInfo(obj.slotRef, nil);
		GHI_ShowSlots(true)
		GHI_EqDisplayUpdated()
	end


	-- put the temp item on cursor
end

function GHI_EqDisplayOnEnter(self, doType)
	if doType == "GHI" then
		if not (self.object.refID == 0) then -- and not(GHI_GetCursor() == "item")
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			containerApi.GHI_DisplayItemTooltip(self.object.refID, GameTooltip, self);
			self.UpdateTooltip = nil;
		else
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:AddLine(self.object.name, 1.0, 0.8196079, 0, 1);
			GameTooltip:Show();
			self.UpdateTooltip = nil;
		end
	end
end

function GHI_ShowNewSlotMenu(editID)
	local f = GHM_NewFrame(self, GHI_NCS_Menu);
	f.edit = nil;
	f.ClearAll(self);

	if editID then
		local slot = (GHI_EquipmentDisplayData.customSlots or {})[editID];
		if not (type(slot)) == "table" then
			return;
		end

		f.edit = editID;
		f.ForceLabel("x", slot.x);
		f.ForceLabel("y", slot.y);
		f.ForceLabel("z", slot.z);
		f.ForceLabel("name", slot.name);
		f.ForceLabel("scale", slot.scale);
		f.ForceLabel("code", slot.code);
	end

	f:Show();
end

function GHI_ShowSlots(show)
	if PD then
		if GHI_MiscData["hide_empty_slots"] then
			PD:ShowEmpty(show);
		else
			PD:ShowEmpty(true);
		end
	end
end

function GHI_EqDisplaySetBackground(path)
	local t = GHI_EquipmentDisplayData or {};
	t.background = path;
	GHI_EquipmentDisplayData = t;
	PD:SetBackground(path)
	GHI_EqDisplayUpdated()
end

-- Communication
local subscribedPlayers = {};
local subscriptionsSend = {};
local EqDisplayDataFromPlayers = {};

function GHI_EqDisplaySubscripeForUpdates(player)
	if type(subscriptionsSend[player]) == "number" and (GetTime() - subscriptionsSend[player]) < 120 then
		return;
	end
	comm.Send("NORMAL", player, "EqDSubscribe", 120)
	subscriptionsSend[player] = GetTime();
end

function GHI_EqDisplayRecieveSubscription(sender, subscriptionTime, ...)
	subscribedPlayers[sender] = GetTime() + subscriptionTime;
	GHI_SendDisplayInfo(sender);
end

comm.AddRecieveFunc("EqDSubscribe", GHI_EqDisplayRecieveSubscription)

function GHI_UpdateSubscriptions()
	for player, timeout in pairs(subscribedPlayers) do
		if timeout < GetTime() then
			subscribedPlayers[player] = nil;
		end
	end
end

function GHI_EqDisplayUpdated()
	GHI_UpdateSubscriptions();
	GHI_SendDisplayInfo(subscribedPlayers);
end



function GHI_SendDisplayInfo(players)
	if not (type(players) == "table" or type(players) == "string") then return end;

	if not (PD) then
		GHI_ShowPlayerEquipmentDisplay()
		PD:Hide();
	end
	--	Returns slots with items (id), background
	local objs = {};
	for _, o in pairs(PD.objects or {}) do
		o = o.object;
		if not (o.refID == 0) and o.refID then
			local s = o:Serialize();
			table.insert(objs, s);
			local itemDataTransfer = GHI_ItemDataTransfer();
			if type(players) == "string" then
				itemDataTransfer.SyncItemLinkData(players, o.refID);
			elseif type(players) == "table" then
				for p, _ in pairs(players) do
					itemDataTransfer.SyncItemLinkData(p, o.refID);
				end
			end
			-- send item info to player
			--[[
			local version = GHI_GetVersions(o.refID);
			if version then
				if type(players) == "string" then
					comm.Send("ALERT",players,"ItemVersion",o.refID,version)
				elseif type(players) == "table" then
					for p,_ in pairs(players) do 
						comm.Send("ALERT",p,"ItemVersion",o.refID,version)
					end					
				end
			end--]]
		end
	end

	local bg = (GHI_EquipmentDisplayData or {}).background;
	if type(players) == "string" then --print("Send to ",players);
		comm.Send("BULK", players, "EqDInfo", objs, bg);
		return
	end

	for p, _ in pairs(players) do --print("Send to more ",p);
		comm.Send("BULK", p, "EqDInfo", objs, bg);
	end
end

function GHI_EqDisplayUpdateWithKnownInfo(display)
	local t = EqDisplayDataFromPlayers[display.name];
	if type(t) == "table" then
		local objs = {};
		for _, infoPart in pairs(t.objs) do
			table.insert(objs, GH_DO:Create(infoPart));
		end
		if #(objs) > 0 then
			display:SetObjects(objs);
		end
		display:SetBackground(t.bg);
	else
		display:SetBackground("");
	end
end

function GHI_EqDisplayRecieveInfo(sender, info, bg, ...) --print("recieved")
	-- go trough all displays and find the senders 
	local updateItems;
	for i, display in pairs(Displays) do
		if display.name == sender then
			--print("Updaing display with new info");
			-- insert
			EqDisplayDataFromPlayers[sender] = { objs = info, bg = bg };

			local objs = {};
			for _, infoPart in pairs(info) do
				table.insert(objs, GH_DO:Create(infoPart));
			end
			if #(objs) > 0 then
				display:SetObjects(objs);
			end
			display:SetBackground(bg);

			-- request ghi data
			updateItems = true;
			-- update
			--print(#(objs).." objects");
		end
	end
	if updateItems then
	end
end

comm.AddRecieveFunc("EqDInfo", GHI_EqDisplayRecieveInfo)


function GHI_SetTargetEqDisplay(unit) -- unit is normally target
	if Displays[1] == nil and not (UnitName(unit) == "") and UnitIsPlayer(unit) then
		-- create a new display
		local d = New_GH_Display();
		d:SetUnit(unit);
		d:CreateStandaloneFrame();
		d:Show();


		-- close button script
		local b = _G[d.display:GetName() .. "_Close"];
		b:SetScript("OnClick", function(self) self.main:Hide(); if self.main.num == 1 then GHI_ToggleTargetEqDisplay(); end if self.num == 2 then GHI_ToggleTargetEqDisplay() end end);

		-- todo: button to "Copy" frame to show all time
		local b2 = CreateFrame("Button", d.display:GetName() .. "_Copy", _G[d.display:GetName() .. "_Bar"], "UIPanelButtonTemplate");
		b2:SetHeight(22)
		b2:SetWidth(22)
		b2:SetText("C");
		b2:SetPoint("LEFT", _G[d.display:GetName() .. "_Bar"], "LEFT", 0, 0);
		b2.main = d;
		d.copyBtn = b2;
		b2:SetScript("OnClick", function() GHI_CopyTargetEqDisplay() end);
		b2:Show();



		d.num = 1;

		Displays[1] = d;
		--GHI_EqDisplaySubscripeForUpdates(UnitName(unit));
		GHI_UpdateDisplay(Displays[1], unit);

		--GHI_DragEqDisplay(d,{});
	elseif Displays[1] and UnitExists(unit) and UnitName(unit) then
		GHI_UpdateDisplay(Displays[1], unit);

		Displays[1]:Show();
	end
end

function GHI_UpdateDisplay(display, unit)
	display:ClearAllObjects()
	display:SetUnit(unit);
	GHI_EqDisplayUpdateWithKnownInfo(display);
	GHI_EqDisplaySubscripeForUpdates(UnitName(unit));
end

function GHI_DragEqDisplay(obj, pos, state)
	if not (type(obj) == "table") then return end

	if state == 1 then -- start drag
		GHI_RemoveAnchorFrame(obj.parent.anchorPlate);
		return;
	end




	local xpos, ypos;

	if (pos) then
		if obj.num == 1 and type(GHI_EquipmentDisplayData) == "table" and type(GHI_EquipmentDisplayData["targetPos"]) == "table" then
			xpos = pos[1] or GHI_EquipmentDisplayData["targetPos"][1] or 100;
			ypos = pos[2] or GHI_EquipmentDisplayData["targetPos"][2] or 300;
		else
			xpos = pos[1] or 100;
			ypos = pos[2] or 600;
		end
	end

	if (not xpos and not ypos) then
		local x, y = GetCursorPosition();
		local s = obj.parent:GetEffectiveScale();

		xpos, ypos = x / s, y / s;
	end

	--GHU_MiscData = GHU_MiscData or {};
	--GHU_MiscData["TargetButtonPos"] = {xpos,ypos};
	if obj.num == 1 then
		GHI_EquipmentDisplayData["targetPos"] = { xpos, ypos };
	end


	-- Hide the tooltip
	GameTooltip:Hide();

	-- Set the position
	obj.parent:SetPoint("TOP", UIParent, "BOTTOMLEFT", xpos, ypos);

	if state == 2 and (GetScreenWidth() - obj.parent:GetRight()) < obj.parent:GetWidth() * 2 then

		--GHI_ContainerAnchorFrame(obj.parent,"display");
		--GHI_updateContainerFrameAnchors();

		local ap = obj.parent.anchorPlate;
		obj.parent:ClearAllPoints();
		obj.parent:SetPoint("CENTER", ap, "CENTER", 0, 0);
		GHI_ContainerAnchorFrame(obj.parent, "display");
	end
end

function GHI_CopyTargetEqDisplay() -- make a copy of a equipment display
	local n = #(Displays) + 1
	Displays[n] = Displays[1];
	Displays[n].num = n;

	Displays[1] = nil;

	-- move the frame
	--local a,b,c,x,y = Displays[n].parent:GetPoint();
	--Displays[n].parent:SetPoint(a,b,c,x+130,y-40);
	if Displays[n].copyBtn then
		Displays[n].copyBtn:Hide();
	end
	Displays[n].disposeOnHide = true;

	GHI_SetTargetEqDisplay("target")

	--Displays[1].parent:SetPoint(a,b,c,x,y);
end

local targetBtn;
local targetToggled;

function GHI_EqDisplayEvent(event, ...)
	if event == "VARIABLES_LOADED" then
		local versionInfo = GHI_VersionInfo();
		-- set up GHT
		targetBtn = GHI_TargetUI
		targetBtn:AddButton("TargetEqDisplay", "", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT");
			GameTooltip:ClearLines()
			GameTooltip:AddLine(loc.TOGGLE_TARGET_EQD, 1, 0.8196079, 0);

			local ver = versionInfo.GetPlayerAddOnVer(UnitName("target"), "GHI");
			if ver then
				GameTooltip:AddLine("GHI v." .. ver, 0, 1, 0);
			else
				GameTooltip:AddLine(loc.NO_GHI_DETECTED, 1, 0, 0)
			end

			GameTooltip:Show()
		end, GHI_ToggleTargetEqDisplay, "FriendlyPlayer")

		--GHI_DoScript("GHI_ShowPlayerEquipmentDisplay(); GHI_GetPlayerEquipmentDisplay():Hide()",3);
		--GHI_DoScript("GHI_ShowPlayerEquipmentDisplay();  GHI_ShowPlayerEquipmentDisplay()",3);


		miscApi = GHI_MiscAPI().GetAPI();
		containerApi = GHI_ContainerAPI().GetAPI();
		return;
	elseif event == "PLAYER_TARGET_CHANGED" then
		if Displays[1] then
			if targetToggled == true and UnitExists("target") and UnitIsPlayer("target") and UnitIsFriend("target", "player") then
				GHI_SetTargetEqDisplay("target");
			else
				Displays[1]:Hide();
			end
		end
	end
end

GHI_Event("VARIABLES_LOADED", GHI_EqDisplayEvent);
GHI_Event("PLAYER_TARGET_CHANGED", GHI_EqDisplayEvent);

function GHI_ToggleTargetEqDisplay()
	targetToggled = not (targetToggled);
	if targetToggled then
	print("The GHI Equiment display is out of order and will be reimplimented at a later date.")
		--GHI_SetTargetEqDisplay("target");
	--elseif Displays[1] then
		--Displays[1]:Hide();
	end
end


GHI_NCS_Menu = {};
GHI_NCS_Menu.title = loc.NEW_CUSTOM_SLOT;    -- todo
GHI_NCS_Menu.name = "GHI_NCS";
GHI_NCS_Menu.theme = "SpellBookTheme";
GHI_NCS_Menu.icon = "Interface/Icons/Ability_Rogue_Disguise";
GHI_NCS_Menu.height = 670;
GHI_NCS_Menu.OnCancel = function(self)
	local main = self:GetParent();
	if main.edit then
		GHI_PlayerEDBtnClick("DisplayedSlots");
	end
end
GHI_NCS_Menu.OnOk = function(self)
	local main = self:GetParent();

	local display = {
		x = main.GetLabel("x"),
		y = main.GetLabel("y"),
		z = main.GetLabel("z"),
		name = main.GetLabel("name");
		scale = main.GetLabel("scale"),
		code = main.GetLabel("code"),
		enabled = true,
	};

	local id;
	if main.edit then
		id = main.edit;
	else
		id = GHI_GenerateID();
	end
	GHI_SetCustomSlotInfo(id, display);
	if main.edit then
		GHI_PlayerEDBtnClick("DisplayedSlots");
	end
end;
GHI_NCS_Menu.OnShow = function(self)
	local main = self;
	if not (main.setUp) then
		main.setUp = true;
		main.EqD = New_GH_Display();
		main.EqD:SetUnit("player");
		main.EqD.display:SetPoint("TOPLEFT", main, "TOPLEFT", 30, -80);
		main.EqD:SetFrameStrata("DIALOG");
		main.EqD.display:SetParent(main);
		main.EqD:SetFrameLevel(10);
	end

	main.EqD:Show();
	if main.edit then

	else
		main.ForceLabel("x", 0.0);
		main.ForceLabel("y", 0.0);
		main.ForceLabel("z", 0.0);
		main.ForceLabel("code", "SHOW = true;");
		main.ForceLabel("scale", 1.0);
	end
end;


GHI_NCS_Menu[1] = {};
for i = 1, 14 do
	GHI_NCS_Menu[1][i] = {};
end

obj = {};
obj.type = "Dummy";
obj.height = 0;
obj.width = 10;
obj.align = "c";
table.insert(GHI_NCS_Menu[1][1], obj);

obj = {};
obj.type = "Editbox";
obj.text = loc.SLOT_NAME; -- todo: localize
obj.align = "r";
obj.label = "name";
obj.width = 120;
table.insert(GHI_NCS_Menu[1][2], obj);

local start = 2;
local vals = { "x", "y", "z" };

for i = 1, #(vals) do
	local v = vals[i];

	obj = {};
	obj.type = "Button";
	obj.text = "++";
	obj.align = "r";
	obj.label = v .. "++";
	obj.compact = true;
	obj.OnLoad = function(self)
		self:SetScript("OnUpdate", function(self)
			if self:GetButtonState() == "PUSHED" then
				local v = self.main.GetLabel(string.sub(self.label, 0, 1)) or 0;
				self.main.ForceLabel(string.sub(self.label, 0, 1), v + 0.10)
			end
		end);
	end
	obj.onclick = function()
	--local v = self.main.GetLabel(string.sub(self.label,0,1)) or 0;
	--self.main.ForceLabel(string.sub(self.label,0,1),v+ 0.10)
	end
	table.insert(GHI_NCS_Menu[1][start + i], obj);

	obj = {};
	obj.type = "Button";
	obj.text = "+";
	obj.align = "r";
	obj.label = v .. "+";
	obj.xOff = -5;
	obj.compact = true;
	obj.OnLoad = function(self)
		self:SetScript("OnUpdate", function(self)
			if self:GetButtonState() == "PUSHED" then
				local v = self.main.GetLabel(string.sub(self.label, 0, 1)) or 0;
				self.main.ForceLabel(string.sub(self.label, 0, 1), v + 0.010)
			end
		end);
	end
	obj.onclick = function(self)
	--local v = self.main.GetLabel(string.sub(self.label,0,1)) or 0;
	--self.main.ForceLabel(string.sub(self.label,0,1),tonumber(v)+ 0.01)
	end
	table.insert(GHI_NCS_Menu[1][start + i], obj);

	obj = {};
	obj.type = "Editbox";
	obj.text = string.upper(v) .. ":";
	obj.align = "r";
	obj.label = v;
	obj.width = 40;
	obj.yOff = 4;
	obj.numbersOnly = true;
	obj.onchange = function(self)
		local x, y, z, scale = self.main.GetLabel("x") or 0, self.main.GetLabel("y") or 0, self.main.GetLabel("z") or 0, self.main.GetLabel("scale") or 0;
		local objs = { GH_DO:Create(x, y, z, scale, "", "Interface\\BUTTONS\\UI-QuickslotRed.blp", nil, nil, "R1") };
		self.main.EqD:SetObjects(objs);
	end
	table.insert(GHI_NCS_Menu[1][start + i], obj);


	obj = {};
	obj.type = "Button";
	obj.text = "-";
	obj.align = "r";
	obj.label = v .. "-";
	obj.xOff = -20;
	obj.compact = true;
	obj.OnLoad = function(self)
		self:SetScript("OnUpdate", function(self)
			if self:GetButtonState() == "PUSHED" then
				local v = self.main.GetLabel(string.sub(self.label, 0, 1)) or 0;
				self.main.ForceLabel(string.sub(self.label, 0, 1), v - 0.010)
			end
		end);
	end
	obj.onclick = function(self)
	--local v = self.main.GetLabel(string.sub(self.label,0,1)) or 0 or 0;
	--self.main.ForceLabel(string.sub(self.label,0,1),tonumber(v)- 0.01)
	end
	table.insert(GHI_NCS_Menu[1][start + i], obj);

	obj = {};
	obj.type = "Button";
	obj.text = "--";
	obj.align = "r";
	obj.label = v .. "--";
	obj.xOff = -5;
	obj.compact = true;
	obj.OnLoad = function(self) self:SetScript("OnUpdate", function(self)
		if self:GetButtonState() == "PUSHED" then
			local v = self.main.GetLabel(string.sub(self.label, 0, 1)) or 0;
			self.main.ForceLabel(string.sub(self.label, 0, 1), v - 0.10)
		end
	end);
	end
	obj.onclick = function(self)
	--local v = self.main.GetLabel(string.sub(self.label,0,1)) or 0;
	--self.main.ForceLabel(string.sub(self.label,0,1),tonumber(v)- 0.10)
	end
	table.insert(GHI_NCS_Menu[1][start + i], obj);
end

obj = {};
obj.type = "Editbox";
obj.text = loc.SCALE;
obj.align = "r";
obj.numbersOnly = true;
obj.xOff = -30;
obj.label = "scale";
obj.width = 60;
obj.onchange = function(self)
	local x, y, z, scale = self.main.GetLabel("x") or 0, self.main.GetLabel("y") or 0, self.main.GetLabel("z") or 0, self.main.GetLabel("scale") or 0;
	local objs = { GH_DO:Create(x, y, z, scale, "", "Interface\\BUTTONS\\UI-QuickslotRed.blp", nil, nil, "R1") };
	self.main.EqD:SetObjects(objs);
end
table.insert(GHI_NCS_Menu[1][6], obj);

obj = {};
obj.type = "Dummy";
obj.height = 30;
obj.width = 20;
obj.align = "c";
table.insert(GHI_NCS_Menu[1][7], obj);

obj = {};
obj.type = "EditField";
obj.align = "c";
obj.height = 100;
obj.width = 260;
obj.label = "code";
table.insert(GHI_NCS_Menu[1][8], obj);

--obj = {};
--obj.type = "Dummy";
--obj.height = 0;
--obj.width = 10;
--obj.align = "c";
--table.insert(GHI_NCS_Menu[1][8],obj);

obj = {};
obj.type = "Text";
obj.fontSize = 11;
obj.text = loc.EQD_SCRIPT;
obj.xOff = 20;
obj.align = "l";
table.insert(GHI_NCS_Menu[1][9], obj);




local c = "script"
GHI_Calb_Menu = {};
GHI_Calb_Menu.title = "Callibration Output";
GHI_Calb_Menu.name = "GHI_Calb";
GHI_Calb_Menu.theme = "SpellBookTheme";
GHI_Calb_Menu.icon = "";
GHI_Calb_Menu.height = 500;
GHI_Calb_Menu.OnOk = function()
end;
GHI_Calb_Menu[1] = {};

GHI_Calb_Menu[1][1] = {};
GHI_Calb_Menu[1][2] = {};
GHI_Calb_Menu[1][3] = {};
GHI_Calb_Menu[1][4] = {};

obj = {};
obj.type = "EditField";
obj.align = "c";
obj.height = 260;
obj.width = 260;
obj.label = "code";
table.insert(GHI_Calb_Menu[1][1], obj);




GHI_DisplayedSlotMenu = {
	-- menu selection of displayed slots
	title = "Displayed Slots",
	name = "GHI_ED_DisplayedSlots",
	theme = "BlankTheme",
	useWindow = true,
	--background = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",
	icon = "Interface\\Icons\\Ability_Rogue_BloodyEye",
	height = 410,
	width = 310,
	OnOk = function(self)
		local main = self:GetParent();
		local list = main.GetLabelFrame("list");
		t = {};
		t2 = GHI_EquipmentDisplayData.customSlots or {}
		for _, slot in pairs(list.data) do
			if slot.type == loc.STANDARD then
				if slot.check then
					table.insert(t, slot.id_name);
				end
			else
				t2[slot.id].enabled = slot.check;
			end
		end
		GHI_EquipmentDisplayData.customSlots = t2;
		GHI_EquipmentDisplayData.stdEnabled = t;
		GHI_UpdatePlayerEquipmentDisplay();
	end,
	{
		-- page 1
		{
			-- line 1
			{
				-- object 1
				type = "List",
				align = "c",
				lines = 7,
				height = 200,
				width = 280,
				label = "list",
				column = {
					{
						type = "CheckButton",
						catagory = "",
						width = 20,
						label = "check",
					},
					{
						type = "Text",
						catagory = "Slot Name",
						width = 170,
						label = "name",
					},
					{
						type = "Text",
						catagory = "Slot Type",
						width = 80,
						label = "type",
					},
				},
				onclick = function(f, n)
					local main = f.main;
					local edit = main.GetLabelFrame("edit");
					if f.data[n].isCustom then
						edit:Enable();
					else
						edit:Disable();
					end
				end,
			}
		}, {
		{
			type = "Button",
			text = loc.EDIT,   -- todo: localize
			label = "edit",
			align = "c",
			onclick = function(self)
				local main = self.main;
				local list = main.GetLabelFrame("list");
				local t = list.GetTuble(list.GetMarked());
				if t.id then
					main:Hide();
					GHI_ShowNewSlotMenu(t.id)
				end
			end,
		}
	}
	}
};


GHI_BackgroundMenu = {
	title = "Figure Background",
	name = "GHI_ED_BackgroundMenu",
	theme = "BlankTheme",
	useWindow = true,
	--background = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",
	icon = "Interface\\Icons\\Achievement_Zone_ArathiHighlands_01",
	height = 600,
	width = 310,
	OnOk = function(self)
		local main = self:GetParent();
		GHI_EqDisplaySetBackground(main.GetLabel("img"));
	end,
	{
		-- page 1
		{
			-- line 1
			{
				-- object 1
				type = "ImageList",
				align = "c",
				height = 355,
				width = 280,
				scaleX = 1.16,
				scaleY = 1.16 * 2,
				label = "img",
				xOff = -10,
			}
		}
	}
}
