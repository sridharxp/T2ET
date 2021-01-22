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
Transliteration from Malayalam
}
unit Mal2Tam;

interface
uses
  SysUtils, Classes,
  DCL_intf,
  HashMap,
  IntT2ET,
  Dialogs;

type
  TbjL2ET = class(TbjMapper)
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

constructor TbjL2ET.Create;
begin
  Inherited;
  LoadMaps;
end;

destructor TbjL2ET.Destroy;
begin
  Inherited;
end;

procedure TbjL2ET.SetIsAVAGRAHA(const SetUnSet: boolean);
begin
  if not UirMei.ContainsKey(Chr($E0)+Chr($B4)+Chr($BD)) then
    raise Exception.Create('Error setting option');
  FIsAVAGRAHA := SetUnSet;
  if SetUnset then
  UirMei.PutValue(Chr($E0)+Chr($B4)+Chr($BD), Chr($E0)+Chr($A4)+Chr($BD)) // 93D AVAGRAHA
  else
  UirMei.PutValue(Chr($E0)+Chr($B4)+Chr($BD), Chr($E0)+Chr($B2)+Chr($BD)); // D3D AVAGRAHA
end;

function TbjL2ET.GetIsANUSVARA: boolean;
begin
  Result := FIsANUSvARA;
end;

procedure TbjL2ET.SetIsANUSVARA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B4)+Chr($82)) then
    raise Exception.Create('Error setting option');
  FIsANUSvARA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($82), Chr($E0)+Chr($AE)+Chr($AE)+Chr($E0)+Chr($AF)+Chr($8D)) // 902
  else
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // D02
end;

procedure TbjL2ET.SetIsVISARGA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B4)+Chr($83)) then
    raise Exception.Create('Error setting option');
  FIsVISARGA := SetUnSet;
  if SetUnset then
    Me1.PutValue(Chr($E0)+Chr($B4)+Chr($83), Chr($EA)+Chr($9E)+Chr($89)) // 903
  else
    Me1.PutValue(Chr($E0)+Chr($B4)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // B83
end;

procedure TbjL2ET.SetIsNA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($B4)+Chr($A8)) then
    raise Exception.Create('Error setting option');
  FIsNA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A9)) // D28
  else
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // D28
end;

procedure TbjL2ET.Loadmaps;
begin
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // D02
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // D03

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($85), Chr($E0)+Chr($AE)+Chr($85)); // D05
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($86), Chr($E0)+Chr($AE)+Chr($86)); // D06
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($87), Chr($E0)+Chr($AE)+Chr($87)); // D07
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($88), Chr($E0)+Chr($AE)+Chr($88)); // D08
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($89), Chr($E0)+Chr($AE)+Chr($89)); // D09
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($8A), Chr($E0)+Chr($AE)+Chr($8A)); // D0A
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($8E), Chr($E0)+Chr($AE)+Chr($8E)); // D0E
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($8F), Chr($E0)+Chr($AE)+Chr($8F)); // D0F
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($90), Chr($E0)+Chr($AE)+Chr($90)); // D10
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($92), Chr($E0)+Chr($AE)+Chr($92)); // D12 Short O
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($93), Chr($E0)+Chr($AE)+Chr($93)); // D13
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($94), Chr($E0)+Chr($AE)+Chr($94)); // 914

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($95), Chr($E0)+Chr($AE)+Chr($95)); // D15
  Me2.PutValue(Chr($E0)+Chr($B4)+Chr($96), Chr($E0)+Chr($AE)+Chr($95)); // D16
  Me3.PutValue(Chr($E0)+Chr($B4)+Chr($97), Chr($E0)+Chr($AE)+Chr($95)); // D17
  Me4.PutValue(Chr($E0)+Chr($B4)+Chr($98), Chr($E0)+Chr($AE)+Chr($95)); // D18
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($99), Chr($E0)+Chr($AE)+Chr($99)); // D19

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($9A), Chr($E0)+Chr($AE)+Chr($9A)); // D1A
  Me2.PutValue(Chr($E0)+Chr($B4)+Chr($9B), Chr($E0)+Chr($AE)+Chr($9A)); // D1B
  Me3.PutValue(Chr($E0)+Chr($B4)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // D1C
  Me4.PutValue(Chr($E0)+Chr($B4)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // D1D
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($9E), Chr($E0)+Chr($AE)+Chr($9E)); // D1E

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($9F), Chr($E0)+Chr($AE)+Chr($9F)); // D1F
  Me2.PutValue(Chr($E0)+Chr($B4)+Chr($A0), Chr($E0)+Chr($AE)+Chr($9F)); // D20
  Me3.PutValue(Chr($E0)+Chr($B4)+Chr($A1), Chr($E0)+Chr($AE)+Chr($9F)); // D21
  Me4.PutValue(Chr($E0)+Chr($B4)+Chr($A2), Chr($E0)+Chr($AE)+Chr($9F)); // D22
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($A3), Chr($E0)+Chr($AE)+Chr($A3)); // D23

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($A4), Chr($E0)+Chr($AE)+Chr($A4)); // D24
  Me2.PutValue(Chr($E0)+Chr($B4)+Chr($A5), Chr($E0)+Chr($AE)+Chr($A4)); // D25
  Me3.PutValue(Chr($E0)+Chr($B4)+Chr($A6), Chr($E0)+Chr($AE)+Chr($A4)); // D26
  Me4.PutValue(Chr($E0)+Chr($B4)+Chr($A7), Chr($E0)+Chr($AE)+Chr($A4)); // D27
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // D28
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($A9), Chr($E0)+Chr($AE)+Chr($A9)); // D29

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($AA), Chr($E0)+Chr($AE)+Chr($AA)); // D2A
  Me2.PutValue(Chr($E0)+Chr($B4)+Chr($AB), Chr($E0)+Chr($AE)+Chr($AA)); // D2B
  Me3.PutValue(Chr($E0)+Chr($B4)+Chr($AC), Chr($E0)+Chr($AE)+Chr($AA)); // D2C
  Me4.PutValue(Chr($E0)+Chr($B4)+Chr($AD), Chr($E0)+Chr($AE)+Chr($AA)); // D2D
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($AE), Chr($E0)+Chr($AE)+Chr($AE)); // D2E

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($AF), Chr($E0)+Chr($AE)+Chr($AF)); // D2F
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B0), Chr($E0)+Chr($AE)+Chr($B0)); // D30
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B1), Chr($E0)+Chr($AE)+Chr($B1)); // D31  RRA
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B2), Chr($E0)+Chr($AE)+Chr($B2)); // D32
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B3), Chr($E0)+Chr($AE)+Chr($B3)); // D33 LLA
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B4), Chr($E0)+Chr($AE)+Chr($B4)); // D34 LLLA
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B5), Chr($E0)+Chr($AE)+Chr($B5)); // D35

  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B6), Chr($E0)+Chr($AE)+Chr($B6)); // D36
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B7), Chr($E0)+Chr($AE)+Chr($B7)); // D37
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B8), Chr($E0)+Chr($AE)+Chr($B8)); // D38
  Me1.PutValue(Chr($E0)+Chr($B4)+Chr($B9), Chr($E0)+Chr($AE)+Chr($B9)); // D39

  UirMei.PutValue(Chr($E0)+Chr($B4)+Chr($BD), Chr($E0)+Chr($B4)+Chr($BD)); // D3D AVAGRAHA
  UirMei.PutValue(Chr($E0)+Chr($B4)+Chr($BE), Chr($E0)+Chr($AE)+Chr($BE)); // D3E
  UirMei.PutValue(Chr($E0)+Chr($B4)+Chr($BF), Chr($E0)+Chr($AE)+Chr($BF)); // D3F
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($80), Chr($E0)+Chr($AF)+Chr($80)); // D40
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($81), Chr($E0)+Chr($AF)+Chr($81)); // D41
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($82), Chr($E0)+Chr($AF)+Chr($82)); // D42
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($83), ); // 943
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), ); // 944
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), ); // 945 CANDRA E
}
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($83), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B0)+
                  Chr($E0)+Chr($AF)+Chr($81)); // D43
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($84), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B1)+
                  Chr($E0)+Chr($AF)+Chr($81)); // D44
//  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), ); // 944
//  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), Chr($E0)+Chr($A5)+Chr($85)); // 945 CANDRA E
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($86), Chr($E0)+Chr($AF)+Chr($86)); // D46
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($87), Chr($E0)+Chr($AF)+Chr($87)); //D47
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($88), Chr($E0)+Chr($AF)+Chr($88)); // D48
//  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($89), Chr($E0)+Chr($A5)+Chr($89)); // 949 CANDRA O
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($8A), Chr($E0)+Chr($AF)+Chr($8A)); // D4A
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($8B), Chr($E0)+Chr($AF)+Chr($8B)); // D4B
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($8C), Chr($E0)+Chr($AF)+Chr($8C)); // D4C
  UirMei.PutValue(Chr($E0)+Chr($B5)+Chr($8D), Chr($E0)+Chr($AF)+Chr($8D)); // D4D VIRAMA

{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($90), Chr($E0)+Chr($AF)+Chr($90)); // 950
}
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($95), Chr($E0)+Chr($B4)+Chr($99)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($95));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($96), Chr($E0)+Chr($B4)+Chr($99)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($96));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($97), Chr($E0)+Chr($B4)+Chr($99)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($97));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($98), Chr($E0)+Chr($B4)+Chr($99)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($98));

  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($9A), Chr($E0)+Chr($B4)+Chr($9E)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($9A));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($9B), Chr($E0)+Chr($B4)+Chr($9E)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($9B));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($9C), Chr($E0)+Chr($B4)+Chr($9E)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($9C));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($9D), Chr($E0)+Chr($B4)+Chr($9E)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($9D));

  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($9F), Chr($E0)+Chr($B4)+Chr($A3)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($9F));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A0), Chr($E0)+Chr($B4)+Chr($A3)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A0));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A1), Chr($E0)+Chr($B4)+Chr($A3)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A1));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A2), Chr($E0)+Chr($B4)+Chr($A3)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A2));

  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A4), Chr($E0)+Chr($B4)+Chr($A8)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A4));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A5), Chr($E0)+Chr($B4)+Chr($A8)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A5));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A6), Chr($E0)+Chr($B4)+Chr($A8)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A6));
  AnuSwap.PutValue(Chr($E0)+Chr($B4)+Chr($82)+Chr($E0)+Chr($B4)+Chr($A7), Chr($E0)+Chr($B4)+Chr($A8)+Chr($E0)+Chr($B5)+Chr($8D)+Chr($E0)+Chr($B4)+Chr($A7));

end;

end.

