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
{
Transliteration from Telugu
}

unit Tel2Tam;

interface
uses
  SysUtils, Classes,
  DCL_intf,
  HashMap,
  IntT2ET,
  Dialogs;

type
  TbjT2ET = class(TbjMapper)
  private
    { Private declarations }
    FIsAVAGRAHA: boolean;
    FIsANUSVARA: boolean;
    FIsVISARGA: boolean;
    FIsNA: boolean;
  protected
  public
    { Public declarations }
    procedure LoadMaps; override;
    { Public declarations }
    procedure SetIsAVAGRAHA(const SetUnSet: boolean); override;
    function GetIsANUSVARA: boolean; override;
    procedure SetIsANUSVARA(const SetUnSet: boolean); override;
    procedure SetIsVISARGA(const SetUnSet: boolean);  override;
    procedure SetIsNA(const SetUnSet: boolean);  override;
    constructor Create;
    destructor Destroy; override;
    property IsANUSVARA: boolean read GetIsANUSVARA write SetIsANUSVARA;
    property IsVISARGA: boolean read FIsVISARGA write SetIsVISARGA;
    property IsNA: boolean read FIsNA write SetIsNA;
end;

implementation

constructor TbjT2ET.Create;
begin
  Inherited;
  LoadMaps;
end;

destructor TbjT2ET.Destroy;
begin
  Inherited;
end;
{
<  128
>= 192
<= 224
}
procedure TbjT2ET.SetIsAVAGRAHA(const SetUnSet: boolean);
begin
  if not UirMei.ContainsKey(Chr($E0)+Chr($B0)+Chr($BD)) then
    raise Exception.Create('Error setting option');
  FIsAVAGRAHA := SetUnSet;
  if SetUnset then
  UirMei.PutValue(Chr($E0)+Chr($B0)+Chr($BD), Chr($E0)+Chr($A4)+Chr($BD)) // 93D AVAGRAHA
  else
  UirMei.PutValue(Chr($E0)+Chr($B0)+Chr($BD), Chr($E0)+Chr($B0)+Chr($BD)); // C3D AVAGRAHA
end;

function TbjT2ET.GetIsANUSVARA: boolean;
begin
  Result := FIsANUSvARA;
end;

procedure TbjT2ET.SetIsANUSVARA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B0)+Chr($82)) then
    raise Exception.Create('Error setting option');
  FIsANUSvARA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($82), Chr($E0)+Chr($AE)+Chr($AE)+Chr($E0)+Chr($AF)+Chr($8D)) // 902
  else
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // B82
end;

procedure TbjT2ET.SetIsVISARGA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B0)+Chr($83)) then
    raise Exception.Create('Error setting option');
  FIsVISARGA := SetUnSet;
  if SetUnset then
    Me1.PutValue(Chr($E0)+Chr($B0)+Chr($83), Chr($EA)+Chr($9E)+Chr($89)) // 903
  else
    Me1.PutValue(Chr($E0)+Chr($B0)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // 903
end;

procedure TbjT2ET.SetIsNA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B0)+Chr($A8)) then
    raise Exception.Create('Error setting option');
  FIsNA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A9)) // 928
  else
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // 928
end;

procedure TbjT2ET.Loadmaps;
begin
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // C02
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // C03

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($85), Chr($E0)+Chr($AE)+Chr($85)); // C05
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($86), Chr($E0)+Chr($AE)+Chr($86)); // C06
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($87), Chr($E0)+Chr($AE)+Chr($87)); // C07
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($88), Chr($E0)+Chr($AE)+Chr($88)); // C08
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($89), Chr($E0)+Chr($AE)+Chr($89)); // C09
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($8A), Chr($E0)+Chr($AE)+Chr($8A)); // C0A
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($8E), Chr($E0)+Chr($AE)+Chr($8E)); // C0E
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($8F), Chr($E0)+Chr($AE)+Chr($8F)); // C0F
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($90), Chr($E0)+Chr($AE)+Chr($90)); // C10
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($92), Chr($E0)+Chr($AE)+Chr($92)); // C12 Short O
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($93), Chr($E0)+Chr($AE)+Chr($93)); // C13
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($94), Chr($E0)+Chr($AE)+Chr($94)); // C14

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($95), Chr($E0)+Chr($AE)+Chr($95)); // C15
  Me2.PutValue(Chr($E0)+Chr($B0)+Chr($96), Chr($E0)+Chr($AE)+Chr($95)); // C16
  Me3.PutValue(Chr($E0)+Chr($B0)+Chr($97), Chr($E0)+Chr($AE)+Chr($95)); // C17
  Me4.PutValue(Chr($E0)+Chr($B0)+Chr($98), Chr($E0)+Chr($AE)+Chr($95)); // C18
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($99), Chr($E0)+Chr($AE)+Chr($99)); // C19

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($9A), Chr($E0)+Chr($AE)+Chr($9A)); // C1A
  Me2.PutValue(Chr($E0)+Chr($B0)+Chr($9B), Chr($E0)+Chr($AE)+Chr($9A)); // C1B
{
  Me1.PutValue(Chr($E0)+Chr($B2)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // C9C
  Me2.PutValue(Chr($E0)+Chr($B2)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // C9D
}
  Me3.PutValue(Chr($E0)+Chr($B0)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // C1C
  Me4.PutValue(Chr($E0)+Chr($B0)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // C1D
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($9E), Chr($E0)+Chr($AE)+Chr($9E)); // C1E

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($9F), Chr($E0)+Chr($AE)+Chr($9F)); // C1F
  Me2.PutValue(Chr($E0)+Chr($B0)+Chr($A0), Chr($E0)+Chr($AE)+Chr($9F)); // C20
  Me3.PutValue(Chr($E0)+Chr($B0)+Chr($A1), Chr($E0)+Chr($AE)+Chr($9F)); // C21
  Me4.PutValue(Chr($E0)+Chr($B0)+Chr($A2), Chr($E0)+Chr($AE)+Chr($9F)); // C22
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($A3), Chr($E0)+Chr($AE)+Chr($A3)); // C23

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($A4), Chr($E0)+Chr($AE)+Chr($A4)); // C24
  Me2.PutValue(Chr($E0)+Chr($B0)+Chr($A5), Chr($E0)+Chr($AE)+Chr($A4)); // C255
  Me3.PutValue(Chr($E0)+Chr($B0)+Chr($A6), Chr($E0)+Chr($AE)+Chr($A4)); // C26
  Me4.PutValue(Chr($E0)+Chr($B0)+Chr($A7), Chr($E0)+Chr($AE)+Chr($A4)); // C27
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // C28
{
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A9), Chr($E0)+Chr($AE)+Chr($A9)); // 928
}
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($AA), Chr($E0)+Chr($AE)+Chr($AA)); // C2A
  Me2.PutValue(Chr($E0)+Chr($B0)+Chr($AB), Chr($E0)+Chr($AE)+Chr($AA)); // 0C2B
  Me3.PutValue(Chr($E0)+Chr($B0)+Chr($AC), Chr($E0)+Chr($AE)+Chr($AA)); // C2C
  Me4.PutValue(Chr($E0)+Chr($B0)+Chr($AD), Chr($E0)+Chr($AE)+Chr($AA)); // C2D
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($AE), Chr($E0)+Chr($AE)+Chr($AE)); // C2E

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($AF), Chr($E0)+Chr($AE)+Chr($AF)); // C2F
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B0), Chr($E0)+Chr($AE)+Chr($B0)); // C30
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B1), Chr($E0)+Chr($AE)+Chr($B1)); // C31  RRA
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B2), Chr($E0)+Chr($AE)+Chr($B2)); // C32
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B3), Chr($E0)+Chr($AE)+Chr($B3)); // C33 LLA
{
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B4), Chr($E0)+Chr($AE)+Chr($B4)); // 934 LLLA
}
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B5), Chr($E0)+Chr($AE)+Chr($B5)); // C35

  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B6), Chr($E0)+Chr($AE)+Chr($B6)); // C36
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B7), Chr($E0)+Chr($AE)+Chr($B7)); // C37
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B8), Chr($E0)+Chr($AE)+Chr($B8)); // C38
  Me1.PutValue(Chr($E0)+Chr($B0)+Chr($B9), Chr($E0)+Chr($AE)+Chr($B9)); // C39

  UirMei.PutValue(Chr($E0)+Chr($B0)+Chr($BD), Chr($E0)+Chr($B0)+Chr($BD)); // C3D AVAGRAHA
  UirMei.PutValue(Chr($E0)+Chr($B0)+Chr($BE), Chr($E0)+Chr($AE)+Chr($BE)); // C3E
  UirMei.PutValue(Chr($E0)+Chr($B0)+Chr($BF), Chr($E0)+Chr($AE)+Chr($BF)); // C3F
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($80), Chr($E0)+Chr($AF)+Chr($80)); // C40
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($81), Chr($E0)+Chr($AF)+Chr($81)); // C41
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($82), Chr($E0)+Chr($AF)+Chr($82)); // C42
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($83), ); // 943
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), ); // 944
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), ); // 945 CANDRA E
}
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($83), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B0)+
                  Chr($E0)+Chr($AF)+Chr($81)); // CC3
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($84), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B1)+
                  Chr($E0)+Chr($AF)+Chr($81)); // C44
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), Chr($E0)+Chr($A5)+Chr($85)); // CC5 CANDRA E
}
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($86), Chr($E0)+Chr($AF)+Chr($86)); // CC6
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($87), Chr($E0)+Chr($AF)+Chr($87)); // CC7
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($88), Chr($E0)+Chr($AF)+Chr($88)); // C48
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($89), Chr($E0)+Chr($A5)+Chr($89)); // CC9 CANDRA O
}
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($8A), Chr($E0)+Chr($AF)+Chr($8A)); // C4A
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($8B), Chr($E0)+Chr($AF)+Chr($8B)); // C4B
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($8C), Chr($E0)+Chr($AF)+Chr($8C)); // C4C
  UirMei.PutValue(Chr($E0)+Chr($B1)+Chr($8D), Chr($E0)+Chr($AF)+Chr($8D)); // C4D

{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($90), Chr($E0)+Chr($AF)+Chr($90)); // 950
}            
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($95), Chr($E0)+Chr($B0)+Chr($99)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($95));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($96), Chr($E0)+Chr($B0)+Chr($99)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($96));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($97), Chr($E0)+Chr($B0)+Chr($99)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($97));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($98), Chr($E0)+Chr($B0)+Chr($99)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($98));

  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($9A), Chr($E0)+Chr($B0)+Chr($9E)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($9A));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($9B), Chr($E0)+Chr($B0)+Chr($9E)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($9B));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($9C), Chr($E0)+Chr($B0)+Chr($9E)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($9C));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($9D), Chr($E0)+Chr($B0)+Chr($9E)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($9D));

  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($9F), Chr($E0)+Chr($B0)+Chr($A3)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($9F));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A0), Chr($E0)+Chr($B0)+Chr($A3)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A0));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A1), Chr($E0)+Chr($B0)+Chr($A3)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A1));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A2), Chr($E0)+Chr($B0)+Chr($A3)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A2));

  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A4), Chr($E0)+Chr($B0)+Chr($A8)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A4));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A5), Chr($E0)+Chr($B0)+Chr($A8)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A5));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A6), Chr($E0)+Chr($B0)+Chr($A8)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A6));
  AnuSwap.PutValue(Chr($E0)+Chr($B0)+Chr($82)+Chr($E0)+Chr($B0)+Chr($A7), Chr($E0)+Chr($B0)+Chr($A8)+Chr($E0)+Chr($B1)+Chr($8D)+Chr($E0)+Chr($B0)+Chr($A7));
end;

end.

