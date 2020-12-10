Config = {
	DiscordToken = "NzcyMTcyNzYyMDg4OTk2OTM0.X52z7A.VtgqUVnUVX3_sLptOLd5OA2BvWc",
	GuildId = "759076586795565058",

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["TestRole"] = "Some Role ID" -- This would be checked by doing exports.discord_perms:IsRolePresent(user, "TestRole")
	}
}
