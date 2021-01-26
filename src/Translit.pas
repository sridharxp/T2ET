(*
Copyright (C) 2020, Sridharan S

This file is part of T2ET (Transliterate to Extended Tamil).

T2ET is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

T2ET is distributed in the hope that it will be useful,
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
  DCL_intf,
  HashMap,
  IntT2ET,
  Dialogs;

type
  TbjI2ET = class(TInterfacedObject, IbjT2ET)
  private
    { Private declarations }
    FSrcFileName: string;
    FSrcStr: string;
    FTgtFileName: string;
    FTgtStr: string;
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
    src, SwapTgt, Tgt: TMemoryStream;
    procedure Check4BOM;
    procedure ShuffleIndic;
    procedure ShuffleCombi;
    procedure NullIndic;
    procedure NullCombi;
    procedure WriteSuperScript;
    procedure WriteNonUTF8Char(Const IsEnd: boolean);
    procedure WriteNonCombi(Const IsEnd: boolean);
    procedure WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
    procedure WriteCombi(IsEnd: boolean);
    procedure P_ProcessCombi(const IsEnd: boolean);
    procedure ProcessEndChar(const IsEnd: boolean);
    procedure Process;
    procedure SetSrcFileName(const aName: string);
    procedure SetSrcStr(const aStr: string);
    function GetTgtFileName: string;
    procedure SetTgtFileName(const aName: string);
    function GetTgtStr: string;
    procedure SetIsSimpleTransliteration(const OnOf: boolean);
    constructor Create;
    destructor Destroy; override;
    property SrcFileName: string write SetSrcFileName;
    property TgtFileName: string read GetTgtFileName write SetTgtFileName;
    property SrcStr: string write SetSrcStr;
    property TgtStr: string read GetTgtStr;
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
  SwapTgt := TMemoryStream.Create;
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
  SwapTgt.Clear;
  Tgt.Clear;
  src.Free;
  SwapTgt.Free;
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
  count := src.Read(buf^, 1);
  If Count = 0 then
    Abort;
  while true do
  begin
    if Combi[1] = Chr(0) then
    begin
      ShuffleCombi;
      Combi[DSize] := buf^;
      count := src.Read(buf^, 1);
      continue;
    end;
    if Count = 0 then
    begin
      P_ProcessCombi(True);
      break;
    end;
    P_ProcessCombi(False);
    count := src.Read(buf^, 1);
  end;
  NullCombi;
  SwapTgt.Seek(0, soFromBeginning);
  Check4BOM;
  count := SwapTgt.Read(buf^, 1);

  If Count = 0 then
    Abort;

  while true do
  begin
    if Indic[1] = Chr(0) then
    begin
      ShuffleIndic;
      Indic[usIZE] := buf^;
      count := SwapTgt.Read(buf^, 1);
      continue;
    end;
    if Count = 0 then
    begin
      ProcessEndChar(True);
      break;
    end;
    ProcessEndChar(False);
    count := SwapTgt.Read(buf^, 1);
  end;
  NullIndic;

  SetString(FTgtStr, pchar(Tgt.Memory),
    Tgt.Size div Sizeof(char));
  if Length(TgtFileName) > 0 then
    tgt.SaveToFile(TgtFileName);
end;

procedure TbjI2ET.ShuffleIndic;
var
  i: integer;
begin
  for i := 1 to USize-1 do
    Indic[i] := Indic[i+1];
  Indic[USize] := Chr(0);
end;

procedure TbjI2ET.ShuffleCombi;
var
  i: integer;
begin
  for i := 1 to DSize-1 do
    Combi[i] := Combi[i+1];
  Combi[DSize] := Chr(0);
end;

procedure TbjI2ET.NullIndic;
var
  i: integer;
begin
  for i := 1 to USize do
    Indic[i] := Chr(0);
end;

procedure TbjI2ET.NullCombi;
var
  i: integer;
begin
  for i := 1 to DSize do
    Combi[i] := Chr(0);
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

procedure  TbjI2ET.WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
begin
  StrCopy(hit, pChar(Dev));
  tgt.Write(hit^, Length(Dev));
  if IsUirMei then
    WriteSuperScript;
  if not IsEnd then
  begin
    NullIndic;
    Indic[USize] := buf^;
  end
  else
    WriteSuperScript;
end;

procedure  TbjI2ET.WriteCombi(IsEnd: boolean);
var
  i: integer;
  aStr: string;
begin
//if FIsSimpleTransliteration or (not Map.GetIsANUSVARA) then
//  begin
//    for i := 1 to DSize do
//      aStr := aStr + Combi[i];
//    StrCopy(hit, pChar(aStr));
//  end
//  else
//Exit;
  StrCopy(hit, pChar(Dev));
  SwapTgt.Write(hit^, Length(hit));
  if not IsEnd then
  begin
    NullCombi;
    Combi[DSize] := buf^;
  end
end;

procedure  TbjI2ET.WriteNonUTF8Char(Const IsEnd: boolean);
var
  i: integer;
begin
  WriteSuperScript;
  If Indic[1] <> Chr(0) then
  begin
    hit^ := Indic[1];
    tgt.Write(hit^, 1);
  end;
  if IsEnd then
  begin
  for i := 2 to USize do
  begin
    If Indic[i] <> Chr(0) then
    begin
      hit^ := Indic[i];
      tgt.Write(hit^, 1);
    end;
  end;
  end
	else
	begin
    ShuffleIndic;
    Indic[USize] := buf^;
  End;
end;

procedure  TbjI2ET.WriteNonCombi(Const IsEnd: boolean);
var
  i: integer;
begin
  If Combi[1] <> Chr(0) then
  begin
    hit^ := Combi[1];
    SwapTgt.Write(hit^, 1);
  end;
  if IsEnd then
  begin
  for i := 2 to DSize do
  begin
    If Combi[i] <> Chr(0) then
    begin
      hit^ := Combi[i];
      SwapTgt.Write(hit^, 1);
    end;
  end;
  end
	else
	begin
    ShuffleCombi;
    Combi[DSize] := buf^;
  End;
end;

procedure TbjI2ET.Check4BOM;
var
  aStream: TMemoryStream;
begin

  aStream := SwapTgt;
  count := aStream.Read(buf^, 1);
  If Count = 0 then
    Abort;
  if Count <> 0 then
  if Ord(buf^) = 254 then
  begin
    Indic[3] := buf^;
    count := aStream.Read(buf^, 1);
    if Count <> 0 then
    if Ord(buf^) = 255 then
      raise Exception.Create('Encoding not supported');
  end;
  if Count <> 0 then
  if Ord(buf^) = 255 then
  begin
    Indic[3] := buf^;
    count := aStream.Read(buf^, 1);
    if Count <> 0 then
    if Ord(buf^) = 254 then
      raise Exception.Create('Encoding not supported');
  end;

   if Count <> 0 then
    if Ord(buf^) = 239 then
    begin
      ShuffleIndic;
      Indic[3] := buf^;

      count := src.Read(buf^, 1);;
      if Count <> 0 then
      if (Ord(buf^) = 191) or (Ord(buf^) = 187)then
      begin
        ShuffleIndic;
        Indic[3] := buf^;
        count := src.Read(buf^, 1);;
        if Count <> 0 then
        begin
         ShuffleIndic;
          Indic[3] := buf^;
        end;
      end;
    end;
end;

procedure TbjI2ET.SetSrcFileName(const aName: string);
begin
  FSrcFileName := aName;
  src.LoadFromFile(FSrcFileName);
end;

procedure TbjI2ET.SetSrcStr(const aStr: string);
begin
  FSrcStr := aStr;
  Src.Write(ppointer(aStr)^, Length(aStr));
end;

function TbjI2ET.GetTgtStr: string;
begin
  Result  := FTgtStr;
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

procedure TbjI2ET.P_ProcessCombi(const IsEnd: boolean);
begin
  if Map.NotinMap then
  begin
    WriteNoncombi(IsEnd);
    Exit;
  end;
  if (not Map.GetIsANUSVARA) then
  begin
    WriteNoncombi(IsEnd);
    Exit;
  end;
  Dev := Map.AnuSwap.GetValue(Combi);
  if Length(Dev) > 0 then
    WriteCombi(IsEnd);
end;

{ Uses maps directly }
procedure TbjI2ET.ProcessEndChar(const IsEnd: boolean);
var
  aStr: string;
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

