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
unit Kan2Tam;

interface
uses
  SysUtils, Classes,
  IntT2ET,
  DCL_intf,
  HashMap,
  Dialogs;

type
  TbjK2ET = class(TInterfacedObject, IT2ET)
  private
    { Private declarations }
    FsrcFileName: string;
    FSrcString: string;
    FtgtFileName: string;
    FIsSimpleTransliteration: boolean;
    FIsAVAGRAHA: boolean;
    FIsANUSVARA: boolean;
    FIsVISARGA: boolean;
    FIsNA: boolean;
    FIsSubscript: boolean;
  protected
    buf, hit: pChar;
    Dev: string;
    count: integer;
    IsUirMei: boolean;
    Me1: IStrStrMap;
    Me2: IStrStrMap;
    Me3: IStrStrMap;
    Me4: IStrStrMap;
    UirMei: IStrStrMap;
    procedure LoadMaps;
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
    procedure SetIsAVAGRAHA(const SetUnSet: boolean);
    procedure SetIsANUSVARA(const SetUnSet: boolean);
    procedure SetIsVISARGA(const SetUnSet: boolean);
    procedure SetIsNA(const SetUnSet: boolean);
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
    property IsAVAGRAHA: boolean read FIsAVAGRAHA write SetIsAVAGRAHA;
    property IsANUSVARA: boolean read FIsANUSVARA write SetIsANUSVARA;
    property IsVISARGA: boolean read FIsVISARGA write SetIsVISARGA;
    property IsNA: boolean read FIsNA write SetIsNA;
    procedure SetIsSubscript(const SetUnSet: boolean);
    property IsSimpleTransliteration: boolean write SetIsSimpleTransliteration;
end;

implementation

constructor TbjK2ET.Create;
begin
  Inherited;
  NullIndic;
  SuperScriptChar := Chr(0);
  src := TMemoryStream.Create;
  tgt := TMemoryStream.Create;
  GetMem(Buf, 3);
  GetMem(hit, 10);
  Me1 := TStrStrHashMap.Create;
  Me2 := TStrStrHashMap.Create;
  Me3 := TStrStrHashMap.Create;
  Me4 := TStrStrHashMap.Create;
  UirMei := TStrStrHashMap.Create;
  FIsSimpleTransliteration := False;
  LoadMaps;
end;

destructor TbjK2ET.Destroy;
begin
  FreeMem(buf);
  FreeMem(hit);
  Src.Clear;
  Tgt.Clear;
  src.Free;
  Tgt.Free;
  Inherited;
end;
{
<  128
>= 192
<= 224
}
procedure TbjK2ET.Process;
begin
//  src.LoadFromFile(FSrcFileName);
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

procedure TbjK2ET.ShuffleIndic;
begin
      Indic[1] := Indic[2];
      Indic[2] := Indic[3];
      Indic[3] := Chr(0);
end;

procedure TbjK2ET.NullIndic;
begin
      Indic[1] := Chr(0);
      Indic[2] := Chr(0);
      Indic[3] := Chr(0);
end;

procedure TbjK2ET.WriteSuperScript;
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

procedure TbjK2ET.SetIsSubscript(const SetUnSet: boolean);
begin
  FIsSubscript :=  SetUnSet;
end;

procedure  TbjK2ET.WriteUTF8Char(Const IsUirMei, IsEnd: boolean);
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

procedure  TbjK2ET.WriteNonUTF8Char(Const IsEnd: boolean);
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

procedure TbjK2ET.Check4BOM;
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

procedure TbjK2ET.SetSrcFileName(const aName: string);
begin
  FSrcFileName := aName;
  src.LoadFromFile(FSrcFileName);
end;

procedure TbjK2ET.SetSrcString(const aName: string);
begin
  FSrcString := aName;
  Src.Write(ppointer(aName)^, Length(aName));
end;

function TbjK2ET.GetTgtFileName: string;
begin
  Result := FTgtFileName;
end;

procedure TbjK2ET.SetTgtFileName(const aName: string);
begin
  FTgtFileName := aName;
end;

procedure TbjK2ET.SetIsSimpleTransliteration(const OnOf: boolean);
begin
  FIsSimpleTransliteration := OnOf;
end;


procedure TbjK2ET.ProcessEndChar(const IsEnd: boolean);
begin
{
  if (not Me1.ContainsKey(Indic))
    and (not Me2.ContainsKey(Indic))
    and (not Me3.ContainsKey(Indic))
    and (not Me4.ContainsKey(Indic))
    and (not UirMei.ContainsKey(Indic)) then
}
  if NotinMap then
  begin
    WriteNonUtf8Char(IsEnd);
    Exit;
  end;

  Dev := UirMei.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteUtf8Char(True, IsEnd);
    Exit;
  end;

  if Length(Dev) = 0 then
   Dev := Me1.GetValue(Indic);
  if Length(Dev) > 0 then
    WriteSuperScript;
  if Length(Dev) = 0 then
  begin
    Dev := Me2.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteSuperScript;
    SuperScriptChar := '2';
    end;
  end;
  if Length(Dev) = 0 then
  begin
    Dev := Me3.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteSuperScript;
    SuperScriptChar := '3';
    end;
  end;
  if Length(Dev) = 0 then
  begin
    Dev := Me4.GetValue(Indic);
  if Length(Dev) > 0 then
  begin
    WriteSuperScript;
    SuperScriptChar := '4';
    end;
  end;

  if Length(Dev) > 0 then
    WriteUtf8Char(False, Isend);
end;

function TbjK2ET.NotinMap: boolean;
begin
  Result := False;
  if (not Me1.ContainsKey(Indic))
    and (not Me2.ContainsKey(Indic))
    and (not Me3.ContainsKey(Indic))
    and (not Me4.ContainsKey(Indic))
    and (not UirMei.ContainsKey(Indic)) then
  Result := True;
end;

procedure TbjK2ET.SetIsAVAGRAHA(const SetUnSet: boolean);
begin
  if not UirMei.ContainsKey(Chr($E0)+Chr($B2)+Chr($BD)) then
    raise Exception.Create('Error setting option');
  FIsAVAGRAHA := SetUnSet;
  if SetUnset then
  UirMei.PutValue(Chr($E0)+Chr($B2)+Chr($BD), Chr($E0)+Chr($A4)+Chr($BD)) // 93D AVAGRAHA
  else
  UirMei.PutValue(Chr($E0)+Chr($B2)+Chr($BD), Chr($E0)+Chr($B2)+Chr($BD)); // CBD AVAGRAHA
end;

procedure TbjK2ET.SetIsANUSVARA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B2)+Chr($82)) then
    raise Exception.Create('Error setting option');
  FIsANUSvARA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($82), Chr($E0)+Chr($AE)+Chr($AE)+Chr($E0)+Chr($AF)+Chr($8D)) // 902
  else
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // 902
end;

procedure TbjK2ET.SetIsVISARGA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B2)+Chr($83)) then
    raise Exception.Create('Error setting option');
  FIsVISARGA := SetUnSet;
  if SetUnset then
    Me1.PutValue(Chr($E0)+Chr($B2)+Chr($83), Chr($EA)+Chr($9E)+Chr($89)) // 903
  else
    Me1.PutValue(Chr($E0)+Chr($B2)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // 903
end;

procedure TbjK2ET.SetIsNA(const SetUnSet: boolean);
begin
//  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B3), Chr($E0)+Chr($AE)+Chr($A8)); // 928
  if not Me1.ContainsKey(Chr($E0)+Chr($B2)+Chr($A8)) then
    raise Exception.Create('Error setting option');
  FIsNA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A9)) // 928
  else
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // 928
end;

procedure TbjK2ET.Loadmaps;
begin
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // C82
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // C83

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($85), Chr($E0)+Chr($AE)+Chr($85)); // C85
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($86), Chr($E0)+Chr($AE)+Chr($86)); // C86
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($87), Chr($E0)+Chr($AE)+Chr($87)); // C87
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($88), Chr($E0)+Chr($AE)+Chr($88)); // C88
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($89), Chr($E0)+Chr($AE)+Chr($89)); // C89
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($8A), Chr($E0)+Chr($AE)+Chr($8A)); // C8A
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($8E), Chr($E0)+Chr($AE)+Chr($8E)); // C8E
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($8F), Chr($E0)+Chr($AE)+Chr($8F)); // C8F
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($90), Chr($E0)+Chr($AE)+Chr($90)); // C90
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($92), Chr($E0)+Chr($AE)+Chr($92)); // C92 Short O
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($93), Chr($E0)+Chr($AE)+Chr($93)); // C93
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($94), Chr($E0)+Chr($AE)+Chr($94)); // C94

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($95), Chr($E0)+Chr($AE)+Chr($95)); // C95
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($96), Chr($E0)+Chr($AE)+Chr($95)); // C96
  Me3.PutValue(Chr($E0)+Chr($B2)+Chr($97), Chr($E0)+Chr($AE)+Chr($95)); // C97
  Me4.PutValue(Chr($E0)+Chr($B2)+Chr($98), Chr($E0)+Chr($AE)+Chr($95)); // C98
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($99), Chr($E0)+Chr($AE)+Chr($99)); // C99

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($9A), Chr($E0)+Chr($AE)+Chr($9A)); // C9A
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($9B), Chr($E0)+Chr($AE)+Chr($9A)); // C9B
{
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // C9C
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // C9D
}
  Me3.PutValue(Chr($E0)+Chr($B2)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // C9C
  Me4.PutValue(Chr($E0)+Chr($B2)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // C9D
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($9E), Chr($E0)+Chr($AE)+Chr($9E)); // C9E

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($9F), Chr($E0)+Chr($AE)+Chr($9F)); // C9F
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($A0), Chr($E0)+Chr($AE)+Chr($9F)); // CA0
  Me3.PutValue(Chr($E0)+Chr($B2)+Chr($A1), Chr($E0)+Chr($AE)+Chr($9F)); // CA1
  Me4.PutValue(Chr($E0)+Chr($B2)+Chr($A2), Chr($E0)+Chr($AE)+Chr($9F)); // CA2
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($A3), Chr($E0)+Chr($AE)+Chr($A3)); // CA3

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($A4), Chr($E0)+Chr($AE)+Chr($A4)); // CA4
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($A5), Chr($E0)+Chr($AE)+Chr($A4)); // CA5
  Me3.PutValue(Chr($E0)+Chr($B2)+Chr($A6), Chr($E0)+Chr($AE)+Chr($A4)); // CA6
  Me4.PutValue(Chr($E0)+Chr($B2)+Chr($A7), Chr($E0)+Chr($AE)+Chr($A4)); // CA7
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // CA8
{
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A9), Chr($E0)+Chr($AE)+Chr($A9)); // 928
}
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($AA), Chr($E0)+Chr($AE)+Chr($AA)); // CAA
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($AB), Chr($E0)+Chr($AE)+Chr($AA)); // CAB
  Me3.PutValue(Chr($E0)+Chr($B2)+Chr($AC), Chr($E0)+Chr($AE)+Chr($AA)); // CAC
  Me4.PutValue(Chr($E0)+Chr($B2)+Chr($AD), Chr($E0)+Chr($AE)+Chr($AA)); // CAD
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($AE), Chr($E0)+Chr($AE)+Chr($AE)); // CAE

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($AF), Chr($E0)+Chr($AE)+Chr($AF)); // CAF
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B0), Chr($E0)+Chr($AE)+Chr($B0)); // CB0
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B1), Chr($E0)+Chr($AE)+Chr($B1)); // CB1  RRA
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B2), Chr($E0)+Chr($AE)+Chr($B2)); // CB2
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B3), Chr($E0)+Chr($AE)+Chr($B3)); // CB3 LLA
{
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B4), Chr($E0)+Chr($AE)+Chr($B4)); // 934 LLLA
}
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B5), Chr($E0)+Chr($AE)+Chr($B5)); // CB5

  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B6), Chr($E0)+Chr($AE)+Chr($B6)); // CB6
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B7), Chr($E0)+Chr($AE)+Chr($B7)); // CB7
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B8), Chr($E0)+Chr($AE)+Chr($B8)); // CB8
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($B9), Chr($E0)+Chr($AE)+Chr($B9)); // CB9

  UirMei.PutValue(Chr($E0)+Chr($B2)+Chr($BD), Chr($E0)+Chr($B2)+Chr($BD)); // CBD AVAGRAHA
  UirMei.PutValue(Chr($E0)+Chr($B2)+Chr($BE), Chr($E0)+Chr($AE)+Chr($BE)); // CBE
  UirMei.PutValue(Chr($E0)+Chr($B2)+Chr($BF), Chr($E0)+Chr($AE)+Chr($BF)); // CBF
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($80), Chr($E0)+Chr($AF)+Chr($80)); // CC0
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($81), Chr($E0)+Chr($AF)+Chr($81)); // CC1
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($82), Chr($E0)+Chr($AF)+Chr($82)); // CC2
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($83), ); // 943
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), ); // 944
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), ); // 945 CANDRA E
}
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($83), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B0)+
                  Chr($E0)+Chr($AF)+Chr($81)); // CC3
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($84), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B1)+
                  Chr($E0)+Chr($AF)+Chr($81)); // CC4
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), Chr($E0)+Chr($A5)+Chr($85)); // CC5 CANDRA E
}
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($86), Chr($E0)+Chr($AF)+Chr($86)); // CC6
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($87), Chr($E0)+Chr($AF)+Chr($87)); //CC7
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($88), Chr($E0)+Chr($AF)+Chr($88)); // CC8
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($89), Chr($E0)+Chr($A5)+Chr($89)); // CC9 CANDRA O
}
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($8A), Chr($E0)+Chr($AF)+Chr($8A)); // CCA
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($8B), Chr($E0)+Chr($AF)+Chr($8B)); // CCB
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($8C), Chr($E0)+Chr($AF)+Chr($8C)); // CCC
  UirMei.PutValue(Chr($E0)+Chr($B3)+Chr($8D), Chr($E0)+Chr($AF)+Chr($8D)); // CCD

{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($90), Chr($E0)+Chr($AF)+Chr($90)); // 950
}
end;

end.

