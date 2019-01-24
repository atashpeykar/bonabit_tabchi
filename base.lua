serpent = (loadfile "serpent.lua")()
tdcli = dofile('tdcli.lua')
redis = (loadfile "redis.lua")()
tabchi_id = "TABCHI-ID"

function vardump(value)
  return serpent.block(value,{comment=false})
end

function reload()
  tabchi = dofile("tabchi.lua")
end

function dl_cb (arg, data)
end

reload()

function tdcli_update_callback(data)
  tabchi.update(data, tabchi_id)
  if data.message_ and data.message_.content_.text_ and data.message_.content_.text_ == "بارگذاری" and data.message_.sender_user_id_ == tonumber(redis:get("tabchi:" .. tabchi_id ..":fullsudo")) then
    reload()
    tdcli.sendMessage(data.message_.chat_id_, 0, 1, "*ربات با موفقیت در سرور بارگذاری شد*", 1, "md")
  elseif data.message_ and data.message_.content_.text_ and data.message_.content_.text_ == "بروز رسانی" and data.message_.sender_user_id_ == tonumber(redis:get("tabchi:" .. tabchi_id ..":fullsudo")) then
    io.popen("git fetch --all && git reset --hard origin/master && git pull origin master"):read("*all")
    reload()
    tdcli.sendMessage(data.message_.chat_id_, 0, 1, "*فایل های ربات با موفقیت بروز رسانی شد و ربات نیز مجددا شروع بکار کرد*", 1, "md")
  end
end

