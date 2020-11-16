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
  Dialogs;

type
  IT2ET = Interface
    procedure Check4BOM;
    procedure LoadMaps;
    procedure WriteSuperScript;
    procedure WriteNonUTF8Char(Const IsEnd: boolean);
    procedure WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
    procedure ProcessEndChar(const IsEnd: boolean);
    procedure Process;
    procedure SetSrcFileName(const aName: string);
    function GetTgtFileName: string;
    procedure SetTgtFileName(const aName: string);
    procedure SetIsAVAGRAHA(const SetUnSet: boolean);
    procedure SetIsANUSVARA(const SetUnSet: boolean);
    procedure SetIsVISARGA(const SetUnSet: boolean);
    procedure SetIsSimpleTransliteration(const OnOf: boolean);
    procedure SetIsNA(const SetUnSet: boolean);
    procedure SetIsSubscript(const SetUnSet: boolean);
  end;

threadvar
  Indic: array[1..3] of Ansichar;
  SuperScriptChar: char;

implementation

end.

