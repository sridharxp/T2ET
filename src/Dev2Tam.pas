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
Transliteration from Devanagari
}
unit Dev2Tam;

interface
uses
  SysUtils, Classes,
  DCL_intf,
  HashMap,
  IntT2ET,
  Dialogs;

type
  TbjD2ET = class(TbjMapper)
  private
    { Private declarations }
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

constructor TbjD2ET.Create;
begin
  Inherited;
  LoadMaps;
end;

destructor TbjD2ET.Destroy;
begin
  Inherited;
end;

function TbjD2ET.GetIsANUSVARA: boolean;
begin
  Result := FIsANUSvARA;
end;

procedure TbjD2ET.SetIsAVAGRAHA(const SetUnSet: boolean);
begin
{ No AVAGRAHA }
end;

procedure TbjD2ET.SetIsANUSVARA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($A4)+Chr($82)) then
    raise Exception.Create('Error setting option');
  FIsANUSvARA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($82), Chr($E0)+Chr($AE)+Chr($AE)+Chr($E0)+Chr($AF)+Chr($8D)) // 902
  else
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // B82
end;

procedure TbjD2ET.SetIsVISARGA(const SetUnSet: boolean);
begin
  if not Me1.ContainsKey(Chr($E0)+Chr($A4)+Chr($83)) then
    raise Exception.Create('Error setting option');
  FIsVISARGA := SetUnSet;
  if SetUnset then
    Me1.PutValue(Chr($E0)+Chr($A4)+Chr($83), Chr($EA)+Chr($9E)+Chr($89)) // 903
  else
    Me1.PutValue(Chr($E0)+Chr($A4)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // 903
end;

procedure TbjD2ET.SetIsNA(const SetUnSet: boolean);
begin
//  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // 928
  if not Me1.ContainsKey(Chr($E0)+Chr($A4)+Chr($A8)) then
    raise Exception.Create('Error setting option');
  FIsNA := SetUnSet;
  if SetUnset then
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A9)) // 928
  else
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // 928
end;

procedure TbjD2ET.Loadmaps;
begin
//  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($81), Chr($E0)+Chr($A4)+Chr($81)); // 901
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // 902
//  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($82), Chr($E0)+Chr($AF)+Chr($A6)); // 902 Zero
//  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($82), Chr($E0)+Chr($AE)+Chr($82)); // 902  Dev
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($83), Chr($E0)+Chr($AE)+Chr($83)); // 903
//  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($83), Chr($E0)+Chr($A4)+Chr($83)); // 903

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($85), Chr($E0)+Chr($AE)+Chr($85));   // 905
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($86), Chr($E0)+Chr($AE)+Chr($86));   // 906
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($87), Chr($E0)+Chr($AE)+Chr($87));   // 907
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($88), Chr($E0)+Chr($AE)+Chr($88));   // 908
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($89), Chr($E0)+Chr($AE)+Chr($89));   // 909
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($8A), Chr($E0)+Chr($AE)+Chr($8A));   // 90A
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($8E), Chr($E0)+Chr($AE)+Chr($8E));   // 90E
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($8F), Chr($E0)+Chr($AE)+Chr($8F)); // 90F
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($90), Chr($E0)+Chr($AE)+Chr($90)); // 910
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($92), Chr($E0)+Chr($AE)+Chr($92)); // 912 Short O
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($93), Chr($E0)+Chr($AE)+Chr($93)); // 913
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($94), Chr($E0)+Chr($AE)+Chr($94)); // 914

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($95), Chr($E0)+Chr($AE)+Chr($95)); // 915
  Me2.PutValue(Chr($E0)+Chr($A4)+Chr($96), Chr($E0)+Chr($AE)+Chr($95)); // 916
  Me3.PutValue(Chr($E0)+Chr($A4)+Chr($97), Chr($E0)+Chr($AE)+Chr($95)); // 917
  Me4.PutValue(Chr($E0)+Chr($A4)+Chr($98), Chr($E0)+Chr($AE)+Chr($95)); // 918
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($99), Chr($E0)+Chr($AE)+Chr($99)); // 915

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($9A), Chr($E0)+Chr($AE)+Chr($9A)); // 91A
  Me2.PutValue(Chr($E0)+Chr($A4)+Chr($9B), Chr($E0)+Chr($AE)+Chr($9A)); // 91B
{
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // 91C
  Me2.PutValue(Chr($E0)+Chr($A4)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // 91D
}
  Me3.PutValue(Chr($E0)+Chr($A4)+Chr($9C), Chr($E0)+Chr($AE)+Chr($9C)); // 91C
  Me4.PutValue(Chr($E0)+Chr($A4)+Chr($9D), Chr($E0)+Chr($AE)+Chr($9C)); // 91D
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($9E), Chr($E0)+Chr($AE)+Chr($9E)); // 91E

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($9F), Chr($E0)+Chr($AE)+Chr($9F)); // 91F
  Me2.PutValue(Chr($E0)+Chr($A4)+Chr($A0), Chr($E0)+Chr($AE)+Chr($9F)); // 920
  Me3.PutValue(Chr($E0)+Chr($A4)+Chr($A1), Chr($E0)+Chr($AE)+Chr($9F)); // 921
  Me4.PutValue(Chr($E0)+Chr($A4)+Chr($A2), Chr($E0)+Chr($AE)+Chr($9F)); // 922
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A3), Chr($E0)+Chr($AE)+Chr($A3)); // 923

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A4), Chr($E0)+Chr($AE)+Chr($A4)); // 924
  Me2.PutValue(Chr($E0)+Chr($A4)+Chr($A5), Chr($E0)+Chr($AE)+Chr($A4)); // 925
  Me3.PutValue(Chr($E0)+Chr($A4)+Chr($A6), Chr($E0)+Chr($AE)+Chr($A4)); // 926
  Me4.PutValue(Chr($E0)+Chr($A4)+Chr($A7), Chr($E0)+Chr($AE)+Chr($A4)); // 927
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A8), Chr($E0)+Chr($AE)+Chr($A8)); // 928
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($A9), Chr($E0)+Chr($AE)+Chr($A9)); // 928

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($AA), Chr($E0)+Chr($AE)+Chr($AA)); // 92A
  Me2.PutValue(Chr($E0)+Chr($A4)+Chr($AB), Chr($E0)+Chr($AE)+Chr($AA)); // 92B
  Me3.PutValue(Chr($E0)+Chr($A4)+Chr($AC), Chr($E0)+Chr($AE)+Chr($AA)); // 92C
  Me4.PutValue(Chr($E0)+Chr($A4)+Chr($AD), Chr($E0)+Chr($AE)+Chr($AA)); // 92D
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($AE), Chr($E0)+Chr($AE)+Chr($AE)); // 92E

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($AF), Chr($E0)+Chr($AE)+Chr($AF)); // 92F
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B0), Chr($E0)+Chr($AE)+Chr($B0)); // 930
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B1), Chr($E0)+Chr($AE)+Chr($B1)); // 931  RRA
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B2), Chr($E0)+Chr($AE)+Chr($B2)); // 932
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B3), Chr($E0)+Chr($AE)+Chr($B3)); // 933 LLA
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B4), Chr($E0)+Chr($AE)+Chr($B4)); // 934 LLLA
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B5), Chr($E0)+Chr($AE)+Chr($B5)); // 935

  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B6), Chr($E0)+Chr($AE)+Chr($B6)); // 936
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B7), Chr($E0)+Chr($AE)+Chr($B7)); // 937
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B8), Chr($E0)+Chr($AE)+Chr($B8)); // 938
  Me1.PutValue(Chr($E0)+Chr($A4)+Chr($B9), Chr($E0)+Chr($AE)+Chr($B9)); // 939

{ No AVAGRAHA }
  UirMei.PutValue(Chr($E0)+Chr($A4)+Chr($BD), Chr($E0)+Chr($A4)+Chr($BD)); // 93D
  UirMei.PutValue(Chr($E0)+Chr($A4)+Chr($BE), Chr($E0)+Chr($AE)+Chr($BE)); // 93E
  UirMei.PutValue(Chr($E0)+Chr($A4)+Chr($BF), Chr($E0)+Chr($AE)+Chr($BF)); // 93F
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($80), Chr($E0)+Chr($AF)+Chr($80)); // 940
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($81), Chr($E0)+Chr($AF)+Chr($81)); // 941
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($82), Chr($E0)+Chr($AF)+Chr($82)); // 942
{
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($83), ); // 943
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), ); // 944
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), ); // 945 CANDRA E
}
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($83), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B0)+
                  Chr($E0)+Chr($AF)+Chr($81)); // 943
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), Chr($E0)+Chr($AF)+Chr($8D)+
                  Chr($E0)+Chr($AE)+Chr($B1)+
                  Chr($E0)+Chr($AF)+Chr($81)); // 944
//  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($84), ); // 944
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($85), Chr($E0)+Chr($A5)+Chr($85)); // 945 CANDRA E
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($86), Chr($E0)+Chr($AF)+Chr($86)); // 946
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($87), Chr($E0)+Chr($AF)+Chr($87)); //947
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($88), Chr($E0)+Chr($AF)+Chr($88)); // 948
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($89), Chr($E0)+Chr($A5)+Chr($89)); // 949 CANDRA O
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($8A), Chr($E0)+Chr($AF)+Chr($8A)); // 94A
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($8B), Chr($E0)+Chr($AF)+Chr($8B)); // 94B
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($8C), Chr($E0)+Chr($AF)+Chr($8C)); // 94C
  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($8D), Chr($E0)+Chr($AF)+Chr($8D)); // 94D

  UirMei.PutValue(Chr($E0)+Chr($A5)+Chr($90), Chr($E0)+Chr($AF)+Chr($90)); // 950

  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($95), Chr($E0)+Chr($A4)+Chr($99)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($95));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($96), Chr($E0)+Chr($A4)+Chr($99)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($96));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($97), Chr($E0)+Chr($A4)+Chr($99)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($97));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($98), Chr($E0)+Chr($A4)+Chr($99)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($98));

  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($9A), Chr($E0)+Chr($A4)+Chr($9E)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($9A));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($9B), Chr($E0)+Chr($A4)+Chr($9E)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($9B));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($9C), Chr($E0)+Chr($A4)+Chr($9E)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($9C));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($9D), Chr($E0)+Chr($A4)+Chr($9E)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($9D));

  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($9F), Chr($E0)+Chr($A4)+Chr($A3)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($9F));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A0), Chr($E0)+Chr($A4)+Chr($A3)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A0));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A1), Chr($E0)+Chr($A4)+Chr($A3)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A1));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A2), Chr($E0)+Chr($A4)+Chr($A3)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A2));

  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A4), Chr($E0)+Chr($A4)+Chr($A8)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A4));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A5), Chr($E0)+Chr($A4)+Chr($A8)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A5));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A6), Chr($E0)+Chr($A4)+Chr($A8)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A6));
  AnuSwap.PutValue(Chr($E0)+Chr($A4)+Chr($82)+Chr($E0)+Chr($A4)+Chr($A7), Chr($E0)+Chr($A4)+Chr($A8)+Chr($E0)+Chr($A5)+Chr($8D)+Chr($E0)+Chr($A4)+Chr($A7));
end;
end.

