(*
Copyright (C) 2020, Sridharan S

This file is part of Transliterate to Extended Tamil.

Tamil Keyboard is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Tamil Keyboard is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License version 3
 along with Transliterate to Extended Tamil.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
Copyright (C) 2020, Sridharan S

This file is part of Transliterate to Extended Tamil.

Tamil Keyboard is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Tamil Keyboard is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License version 3
 along with Transliterate to Extended Tamil.  If not, see <http://www.gnu.org/licenses/>.
*)
unit IntT2ET;

interface
uses
  SysUtils, Classes,
  DCL_intf,
  HashMap,
  Dialogs;

type
  TbjMapper = class;
  IbjT2ET = Interface
    procedure Check4BOM;
    function GetMap: TbjMapper;
    procedure SetMap(const aMap: TbjMapper);
    procedure WriteSuperScript;
    procedure WriteNonUTF8Char(Const IsEnd: boolean);
    procedure WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
    procedure ProcessEndChar(const IsEnd: boolean);
    procedure Process;
    procedure SetSrcFileName(const aName: string);
    function GetTgtFileName: string;
    procedure SetTgtFileName(const aName: string);
    procedure SetIsSimpleTransliteration(const OnOf: boolean);
    procedure SetIsSubscript(const SetUnSet: boolean);
    property Map: TbjMapper read GetMap write SetMap;
  end;

  TbjMapper = class
  public
    Me1: IStrStrMap;
    Me2: IStrStrMap;
    Me3: IStrStrMap;
    Me4: IStrStrMap;
    UirMei: IStrStrMap;
    procedure LoadMaps; virtual; abstract;
    function NotinMap: boolean; virtual;
    procedure SetIsAVAGRAHA(const SetUnSet: boolean); virtual; abstract;
    procedure SetIsANUSVARA(const SetUnSet: boolean); virtual; abstract;
    procedure SetIsVISARGA(const SetUnSet: boolean); virtual; abstract;
    procedure SetIsNA(const SetUnSet: boolean); virtual; abstract;
    constructor Create;
    destructor Destroy; override;
  end;


threadvar
  Indic: array[1..3] of Ansichar;
  SuperScriptChar: char;


implementation

constructor TbjMapper.Create;
begin
  Inherited;
  Me1 := TStrStrHashMap.Create;
  Me2 := TStrStrHashMap.Create;
  Me3 := TStrStrHashMap.Create;
  Me4 := TStrStrHashMap.Create;
  UirMei := TStrStrHashMap.Create;
end;

destructor TbjMapper.Destroy;
begin
  Inherited;
end;

function TbjMapper.NotinMap: boolean;
begin
  Result := False;
  if (not Me1.ContainsKey(Indic))
    and (not Me2.ContainsKey(Indic))
    and (not Me3.ContainsKey(Indic))
    and (not Me4.ContainsKey(Indic))
    and (not UirMei.ContainsKey(Indic)) then
  Result := True;
end;

end.

