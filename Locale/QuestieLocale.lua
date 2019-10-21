QuestieLocale = {};
QuestieLocale.locale = {};
LangItemLookup = {}
LangNameLookup= {};
LangObjectIdLookup = {};
LangObjectLookup = {};
LangQuestLookup = {};

local locale = 'enUS';

-- Initialize lookup tables for localization
function QuestieLocale:Initialize()
    local lang = GetLocale()

    LangItemLookup = LangItemLookup[lang] or {};
    LangNameLookup = LangNameLookup[lang] or {};
    LangQuestLookup = LangQuestLookup[lang] or {};
    LangObjectIdLookup = LangObjectLookup[lang] or {}; -- This table is String -> ID
    LangObjectLookup = {} -- This table is ID -> String

    --Create the ID -> String table!
    for k, v in pairs(LangObjectIdLookup) do
        if(not LangObjectLookup[v]) then
            LangObjectLookup[v] = {};
        end
        table.insert(LangObjectLookup[v], k);
    end
    -- Create the english String -> ID table.
    if(lang == "enUS" or lang == "enGB") then
        for id, data in pairs(QuestieDB.objectData) do
            if(not LangObjectLookup[data[1]]) then
                LangObjectLookup[data[1]] = {};
            end
            table.insert(LangObjectLookup[data[1]], id);
        end
    end
end

function QuestieLocale:FallbackLocale(lang)

    if not lang then
        return 'enUS';
    end

    if QuestieLocale.locale[lang] then
        return lang;
    elseif lang == 'enGB' then
        return 'enUS';
    elseif lang == 'enCN' then
        return 'zhCN';
    elseif lang == 'enTW' then 
        return 'zhTW';
    elseif lang == 'esMX' then
        return 'esES';
    elseif lang == 'ptPT' then
        return 'ptBR';
    else
        return 'enUS';
    end
end

function QuestieLocale:SetUILocale(lang)
    if lang then
        locale = QuestieLocale:FallbackLocale(lang);
    else
        locale = QuestieLocale:FallbackLocale(GetLocale());
    end
end

function QuestieLocale:GetUILocale()
    return locale;
end

function QuestieLocale:GetLocaleTable()
    if QuestieLocale.locale[locale] then
        return QuestieLocale.locale[locale];
    else
        return QuestieLocale.locale['enUS'];
    end
end

function QuestieLocale:GetUIString(key, ...)
    local result, val = pcall(QuestieLocale._GetUIString, QuestieLocale, key, ...)
    if result then
        return val
    else
        return tostring(key) .. ' ERROR: '.. val;
    end
end

function QuestieLocale:_GetUIString(key, ...)
    if key then
        -- convert all args to string
        local arg = {...};        
        for i, v in ipairs(arg) do
            arg[i] = tostring(v);
        end

        if QuestieLocale.locale[locale] then
            if QuestieLocale.locale[locale][key] then
                return string.format(QuestieLocale.locale[locale][key], unpack(arg))
            else
                if QuestieLocale.locale['enUS'] and QuestieLocale.locale['enUS'][key] then
                    return string.format(QuestieLocale.locale['enUS'][key], unpack(arg));
                else
                    return tostring(key) ..' ERROR: '..tostring(locale)..' key missing!';
                end
            end
        else
            if QuestieLocale.locale['enUS'] and QuestieLocale.locale['enUS'][key] then
                return string.format(QuestieLocale.locale['enUS'][key], unpack(arg));
            else
                return tostring(key) ..' ERROR: enUS key missing!';
            end
        end
    end
end
