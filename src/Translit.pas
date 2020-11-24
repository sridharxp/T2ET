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
unit Translit;

interface
uses
  SysUtils, Classes,
  IntT2ET,
  DCL_intf,
  HashMap,
  Dev2Tam,
  Dialogs;

type
  TbjI2ET = class(TInterfacedObject, IbjT2ET)
  private
    { Private declarations }
    FSrcFileName: string;
    FSrcString: string;
    FTgtFileName: string;
    FIsSimpleTransliteration: boolean;
    FIsSubscript: boolean;
    FMap: TbjMapper;
  protected
    buf, hit: pChar;
    Dev: string;
    count: integer;
    IsUirMei: boolean;
  public
    { Public declarations }
    src, tgt: TMemoryStream;
    procedure Check4BOM;
    procedure ShuffleIndic;
    procedure NullIndic;
    procedure WriteSuperScript;
    procedure WriteNonUTF8Char(Const IsEnd: boolean);
    procedure WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
    procedure ProcessEndChar(const IsEnd: boolean);
    function NotinMap: boolean;
    procedure Process;
    procedure SetSrcFileName(const aName: string);
    procedure SetSrcString(const aName: string);
    function GetTgtFileName: string;
    procedure SetTgtFileName(const aName: string);
    procedure SetIsSimpleTransliteration(const OnOf: boolean);
    constructor Create;
    destructor Destroy; override;
    property SrcFileName: string write SetSrcFileName;
    property SrcString: string write SetSrcString;
    property TgtFileName: string read GetTgtFileName write SetTgtFileName;
    function GetMap: TbjMapper;
    procedure SetMap(const aMap: TbjMapper);
    procedure SetIsSubscript(const SetUnSet: boolean);
    property IsSimpleTransliteration: boolean write SetIsSimpleTransliteration;
    property Map: TbjMapper read GetMap write SetMap;
end;

implementation

constructor TbjI2ET.Create;
begin
  Inherited;
  NullIndic;
  SuperScriptChar := Chr(0);
  src := TMemoryStream.Create;
  tgt := TMemoryStream.Create;
  GetMem(Buf, 3);
  GetMem(hit, 10);
  FIsSimpleTransliteration := False;
end;

destructor TbjI2ET.Destroy;
begin
  FreeMem(buf);
  FreeMem(hit);
  Src.Clear;
  Tgt.Clear;
  src.Free;
  Tgt.Free;
  Map.Free;
  Inherited;
end;
{
<  128
>= 192
<= 224
}
procedure TbjI2ET.Process;
begin
  src.Seek(0, soFromBeginning);
  Check4BOM;
  while true do
  begin
    count := src.Read(buf^, 1);
    if Indic[1] = Chr(0) then
    begin
      ShuffleIndic;
      Indic[3] := buf^;
      continue;
    end;
    if Count = 0 then
    begin
      ProcessEndChar(True);
      break;
    end;
    ProcessEndChar(False);
  end;
  tgt.SaveToFile(TgtFileName);
end;

procedure TbjI2ET.ShuffleIndic;
begin
      Indic[1] := Indic[2];
      Indic[2] := Indic[3];
      Indic[3] := Chr(0);
end;

procedure TbjI2ET.NullIndic;
begin
      Indic[1] := Chr(0);
      Indic[2] := Chr(0);
      Indic[3] := Chr(0);
end;

procedure TbjI2ET.WriteSuperScript;
begin
  if FIsSimpleTransliteration then
    Exit;
  if SuperScriptChar = Chr(0) then
    Exit;
  if not FIsSubscript then
  begin
    if SuperScriptChar = '2' then
      tgt.Write(Chr($C2)+Chr($B2), 2);
    if SuperScriptChar = '3' then
      tgt.Write(Chr($C2)+Chr($B3), 2);
    if SuperScriptChar = '4' then
      tgt.Write(Chr($E2 )+Chr($81)+Chr($B4), 3);
  end;
  if FIsSubscript then
  begin
    if SuperScriptChar = '2' then
      tgt.Write(Chr($E2)+Chr($82)+Chr($82), 3);
    if SuperScriptChar = '3' then
      tgt.Write(Chr($E2)+Chr($82)+Chr($83), 3);
    if SuperScriptChar = '4' then
      tgt.Write(Chr($E2)+Chr($82)+Chr($84), 3);
   end;
  SuperScriptChar := Chr(0);
end;

procedure TbjI2ET.SetIsSubscript(const SetUnSet: boolean);
begin
  FIsSubscript :=  SetUnSet;
end;

//function TbjI2ET.NotinMap(const astr: string): boolean;
function TbjI2ET.NotinMap: boolean;
begin
  Result := False;
  if Assigned(Map) then
    Result := Map.NotinMap();
end;

procedure  TbjI2ET.WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
begin
  StrCopy(hit, pChar(Dev));
  tgt.Write(hit^, Length(Dev));
  if IsUirMei then
    WriteSuperScript;
  if not IsEnd then
  begin
    NullIndic;
    Indic[3] := buf^;
  end
  else
    WriteSuperScript;
end;

procedure  TbjI2ET.WriteNonUTF8Char(Const IsEnd: boolean);
begin
  WriteSuperScript;
  If Indic[1] <> Chr(0) then
  begin
    hit^ := Indic[1];
    tgt.Write(hit^, 1);
  end;
  if IsEnd then
  begin
    If Indic[2] <> Chr(0) then
    begin
      hit^ := Indic[2];
      tgt.Write(hit^, 1);
    end;
    If Indic[3] <> Chr(0) then
    begin
      hit^ := Indic[3];
      tgt.Write(hit^, 1);
    end;
  end
	else
	begin
    ShuffleIndic;
    Indic[3] := buf^;
  End;
end;

procedure TbjI2ET.Check4BOM;
begin
    count := src.Read(buf^, 1);
    if Count <> 0 then
    if Ord(buf^) = 254 then
    begin
    if Count <> 0 then
        Indic[3] := buf^;
    count := src.Read(buf^, 1);
    if Count <> 0 then
    if Ord(buf^) = 255 then
      raise Exception.Create('Encoding not supported');
    end;
    if Count <> 0 then
    if Ord(buf^) = 255 then
    begin
    if Count <> 0 then
        Indic[3] := buf^;
    count := src.Read(buf^, 1);
    if Count <> 0 then
    if Ord(buf^) = 254 then
      raise Exception.Create('Encoding not supported');
    end;
    ShuffleIndic;
    if Count <> 0 then
      Indic[3] := buf^;
{
    if Count <> 0 then
    if Ord(buf^) = 239 then
        tgt.Write(buf^, count);
    count := src.Read(buf^, 1);;
    if Count <> 0 then
    if (Ord(buf^) = 191) or (Ord(buf^) = 187)then
        tgt.Write(buf^, count);

    count := src.Read(buf^, 2);
    if Count <> 0 then
//    if (Ord(buf^) = 224) or (Ord(buf^) = 174) or (Ord(buf^) = 191) then
        tgt.Write(buf^, count);
}
end;

procedure TbjI2ET.SetSrcFileName(const aName: string);
begin
  FSrcFileName := aName;
  src.LoadFromFile(FSrcFileName);
end;

procedure TbjI2ET.SetSrcString(const aName: string);
begin
  FSrcString := aName;
  Src.Write(ppointer(aName)^, Length(aName));
end;

function TbjI2ET.GetTgtFileName: string;
begin
  Result := FTgtFileName;
end;

procedure TbjI2ET.SetTgtFileName(const aName: string);
begin
  FTgtFileName := aName;
end;

procedure TbjI2ET.SetIsSimpleTransliteration(const OnOf: boolean);
begin
  FIsSimpleTransliteration := OnOf;
end;

function TbjI2ET.GetMap: TbjMapper;
begin
  Result := FMap;
end;

procedure TbjI2ET.SetMap(const aMap: TbjMapper);
begin
  FMap := aMap;
end;

{ Uses maps directly }
procedure TbjI2ET.ProcessEndChar(const IsEnd: boolean);
begin
  if Map.NotinMap then
  begin
    WriteNonUtf8Char(IsEnd);
    Exit;
  end;

  Dev := Map.UirMei.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteUtf8Char(True, IsEnd);
    Exit;
  end;

  if Length(Dev) = 0 then
   Dev := Map.Me1.GetValue(Indic);
  if Length(Dev) > 0 then
    WriteSuperScript;
  if Length(Dev) = 0 then
  begin
    Dev := Map.Me2.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteSuperScript;
    SuperScriptChar := '2';
    end;
  end;
  if Length(Dev) = 0 then
  begin
    Dev := Map.Me3.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteSuperScript;
    SuperScriptChar := '3';
    end;
  end;
  if Length(Dev) = 0 then
  begin
    Dev := Map.Me4.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteSuperScript;
    SuperScriptChar := '4';
    end;
  end;

  if Length(Dev) > 0 then
    WriteUtf8Char(False, Isend);
end;

end.

