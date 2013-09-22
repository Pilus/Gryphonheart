describe("GHP_PerformActionUI",function()

	require("StandardMock");
	require("GHP_PerformActionUI");


	local PERFORM_TEXT, PERFORM_TT
	local FRAME_SHOWN = true;
	local EXPRESSION = {};

	GHP_Loc = function()
		return {
			PERFORM_TEXT = "Perform: %s";
		}
	end
	local ExpressionHandler = mock({
		SendChatMessage = function()
		end
	});

	GHI_ExpressionHandler = function() return ExpressionHandler	end

	local FRAME;
	before_each(function()
		PERFORM_TEXT,PERFORM_TT = nil,nil;
		CreateFrame = function()
			FRAME = {
				SetPoint = function() end,
				Show = function() end,
				SetPerformText = function(_,text) PERFORM_TEXT = text; end,
				SetPerformTooltipFunc = function(_,func) PERFORM_TT = func; end,
				IsShown = function() return FRAME_SHOWN; end,
				GetExpression = function()
					return EXPRESSION
				end
			}
			return FRAME;
		end

	end);
	it("should set up without errors",function()
		local perform = GHP_PerformActionUI();
	end);

	it("should implement New",function()
		local perform = GHP_PerformActionUI();
		assert.are.same("function",type(perform.New))


		local perf = "Do something.";
		local TT_received
		local ttFunc = function(tt) TT_received = tt; end;
		local enter = false;
		local onEnterFunc = function() enter = true;  end;

		perform.New(perf,ttFunc,onEnterFunc)

		-- it should set the perform text
		assert.are.same("Perform: "..perf,PERFORM_TEXT);
		assert.are.same("function",type(PERFORM_TT));

		-- calling Perform TT with a tooltip obj should result in the ttFunc receiving a shell object for security reasons
		local GameTooltip = mock({
			AddLine = function() end,
			AddDoubleLine = function() end,
			AddTexture = function() end,
			ClearLines = function() end,
		})
		PERFORM_TT(GameTooltip);
		TT_received:AddLine("Test text")
		assert.spy(GameTooltip.AddLine).was.called_with(GameTooltip,"Test text");

		-- on send
		assert.are.same("function",type(FRAME.OnEnter));
		EXPRESSION = {
			{
				chatType = "EMOTE",
				text = "text1",
			},
			{
				chatType = "SAY",
				text = "text2",
				delay = 2,
			},
			{
				chatType = "SAY",
				text = string.rep("testing string ",10),
				delay = 1,
			},
			{
				chatType = "SAY",
				text = "text4",
				delay = "auto",
			},
		}
		assert.are.same(false,enter)
		FRAME.OnEnter();
		assert.are.same(true,enter);
		assert.spy(ExpressionHandler.SendChatMessage).was.called_with("text1","EMOTE",nil,nil,nil,nil,true);
		assert.spy(ExpressionHandler.SendChatMessage).was.called_with("text2","SAY",nil,nil,2,nil,true);
		assert.spy(ExpressionHandler.SendChatMessage).was.called_with(string.rep("testing string ",10),"SAY",nil,nil,3,nil,true);
		assert.spy(ExpressionHandler.SendChatMessage).was.called_with("text4","SAY",nil,nil,13,nil,true);
	end);

	it("should implement IsInUse, drawing on frame.IsShown",function()
		local perform = GHP_PerformActionUI();
		assert.are.same("function",type(perform.IsInUse))
		assert.are.same(true,perform.IsInUse())
		FRAME_SHOWN = false;
		assert.are.same(false,perform.IsInUse())
	end);

end);