--Frame
local PANEL = {}

local lightRed = Color(DAILYREWARDS.CONFIG.UI.closeButton.r * 0.7, DAILYREWARDS.CONFIG.UI.closeButton.g * 1.9, DAILYREWARDS.CONFIG.UI.closeButton.b * 1.6)

function PANEL:Init()
	self.Header = vgui.Create("Panel", self)
	self.Header:Dock(TOP)
	self.Header:SetSize(self:GetWide(), 35)
	self.Header.Paint = function(self, w, h)
		draw.RoundedBoxEx(4, 0, 0, w, h, DAILYREWARDS.CONFIG.UI.header, true, true, false, false)
	end

	self.Close = self.Header:Add("DButton")
	self.Close:SetSize(self.Header:GetTall(), self.Header:GetTall())
	self.Close:Dock(RIGHT)
	self.Close:SetText("")
	self.Close.Paint = function(self, w, h)
		draw.RoundedBox(4, 4, 4, w - 8, h - 8, self:IsHovered() and DAILYREWARDS.CONFIG.UI.closeButton or lightRed)
		draw.RoundedBox(4, 6, 6, w - 12, h - 12, self:IsHovered() and DAILYREWARDS.CONFIG.UI.buttonHover or DAILYREWARDS.CONFIG.UI.buttonbg)
		draw.SimpleText("X", "DRCloseButton", w / 2, h / 2 - 1, self:IsHovered() and color_white or DAILYREWARDS.CONFIG.UI.grayText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.Close.DoClick = function()
		self:Remove()
	end
end

function PANEL.Paint(self, w, h)
	draw.RoundedBox(8, 0, 0, w, h, DAILYREWARDS.CONFIG.UI.background)
end

vgui.Register("DR.Frame", PANEL, "EditablePanel")

--Button
local PANEL = {}

AccessorFunc(PANEL, "bgcolor", "BackgroundColor")
AccessorFunc(PANEL, "bghovercolor", "BackgroundHoverColor")
AccessorFunc(PANEL, "outlinehovercolor", "OutlineHoverColor")
AccessorFunc(PANEL, "outlineunhovercolor", "OutlineUnhoverColor")

local hiddenCol = Color(DAILYREWARDS.CONFIG.UI.rewardHidden.r * 0.8, DAILYREWARDS.CONFIG.UI.rewardHidden.g * 0.8, DAILYREWARDS.CONFIG.UI.rewardHidden.b * 0.8)
local txtBox, txtBoxHover = Color(0,0,0, 150), Color(0,0,0, 120)

function PANEL:Init()
	self.Text = ""
	self.Enabled = true
	self.Reward = DAILYREWARDS:GetLang("not_claimable")
	
	self:SetOutlineHoverColor(self:GetOutlineHoverColor() or DAILYREWARDS.CONFIG.UI.rewardHidden)
	self:SetOutlineUnhoverColor(self:GetOutlineUnhoverColor() or hiddenCol)
	self:SetBackgroundColor(self:GetBackgroundColor() or DAILYREWARDS.CONFIG.UI.buttonbg)
	self:SetBackgroundHoverColor(self:GetBackgroundHoverColor() or DAILYREWARDS.CONFIG.UI.buttonHover)
end

function PANEL:SetText(txt)
    self.Text = txt
end

function PANEL:SetEnabled(bool)
    self.Enabled = bool
end

function PANEL:GetEnabled()
    return self.Enabled
end

function PANEL:SetReward(txt)
    self.Reward = txt
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, self.Enabled and (self:IsHovered() and self:GetOutlineHoverColor() or self:GetOutlineUnhoverColor()) or self:GetOutlineUnhoverColor())
	draw.RoundedBox(8, 3, 3, w - 6, h - 6, self.Enabled and (self:IsHovered() and self:GetBackgroundHoverColor() or self:GetBackgroundColor()) or self:GetBackgroundColor())
	draw.RoundedBoxEx(8, 3, h - h * .2 - 3, w - 6, h * .2, self.Enabled and (self:IsHovered() and txtBoxHover or txtBox) or txtBox, false, false, true, true)
end

function PANEL:PaintOver(w, h)
	draw.SimpleText(self.Text, "DR80", w / 2, h * .2 * 2, self.Enabled and (self:IsHovered() and color_white or DAILYREWARDS.CONFIG.UI.grayText) or DAILYREWARDS.CONFIG.UI.grayText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.Reward, "DR17", w / 2, h - h / 1.7 * .2, self.Enabled and (self:IsHovered() and color_white or DAILYREWARDS.CONFIG.UI.grayText) or DAILYREWARDS.CONFIG.UI.grayText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:PerformLayout()
	if self.Enabled then
		self:SetCursor("hand")
	else
		self:SetCursor("no")
	end
	self:SetTextColor(Color(0, 0, 0, 0))
end

vgui.Register("DR.Button", PANEL, "DButton")

--Model
local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockMargin(6, 6, 6, ((DAILYREWARDS.Menu.RewardPanel:GetTall() / 3) - 16) * .2 + 6)
	self:SetMouseInputEnabled(false)
end

function PANEL:PerformLayout()
	if IsValid(self.Entity) then
		function self:LayoutEntity(Entity) return end
		local mn, mx = self.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
		self:SetFOV(45)
		self:SetCamPos(Vector(size, size, size))
		self:SetLookAt((mn + mx) * 0.5)
	end
end

vgui.Register("DR.Model", PANEL, "DModelPanel")

--Image
local PANEL = {}

function PANEL:Init()
	self.Image = nil

	self:Dock(FILL)
	self:DockMargin(6, 6, 6, ((DAILYREWARDS.Menu.RewardPanel:GetTall() / 3) - 16) * .2 + 6)
	self:SetMouseInputEnabled(false)
end

function PANEL:SetImage(image)
    self.Image = image
end

function PANEL:Paint(w, h)
	if self.Image then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(self.Image)
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

vgui.Register("DR.Image", PANEL, "DPanel")