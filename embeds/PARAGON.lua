-- pulled from title of http://www.wowhead.com/faction=2089
local paragonStrings = {
	deDE = 'Huldigend',
	esES = 'Baluarte',
	frFR = 'Parangon',
	itIT = 'Eccellenza',
	ptBR = 'Parag\195\163o',
	ruRU = '\208\152\208\180\208\181\208\176\208\187',
	koKR = '\235\182\136\235\169\184\236\157\152 \235\143\153\235\167\185',
	zhCN = '\229\183\133\229\179\176',
}

paragonStrings.esMX = paragonStrings.esES
paragonStrings.zhTW = paragonStrings.zhCN

_G.PARAGON = paragonStrings[GetLocale()] or 'Paragon'
