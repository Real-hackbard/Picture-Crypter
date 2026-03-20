unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Shell.ShellCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Jpeg, PngImage, GIFImg;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Button1: TButton;
    StatusBar1: TStatusBar;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    Button4: TButton;
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R-}
procedure LoadPngToBmp(var Dest: TBitmap; AFilename: TFilename);
type
  TRGB32 = packed record
    B, G, R, A : Byte;
  end;
  PRGBArray32 = ^TRGBArray32;
  TRGBArray32 = array[0..0] of TRGB32;
type
  TRG24 = packed record
    rgbtBlue, rgbtGreen, rgbtRed : Byte;
  end;
  PRGBArray24 = ^TPRGBArray24;
  TPRGBArray24 = array[0..0] of TRG24;
type
  TByteArray = Array[Word] of Byte;
  PByteArray = ^TByteArray;
  TPByteArray = array[0..0] of TByteArray;
var
  BMP : TBitmap;
  PNG: TPNGObject;
  x, y: Integer;
  BmpRow: PRGBArray32;
  PngRow : PRGBArray24;
  AlphaRow: PByteArray;
begin
  Bmp := TBitmap.Create;
  PNG := TPNGObject.Create;
  try
    if AFilename <> '' then
    begin
      PNG.LoadFromFile(AFilename);
      BMP.PixelFormat := pf32bit;
      BMP.Height := PNG.Height;
      BMP.Width := PNG.Width;

      if ( PNG.TransparencyMode = ptmPartial ) then
      begin
        for Y := 0 to BMP.Height-1 do
        begin
          BmpRow := PRGBArray32(BMP.ScanLine[Y]);
          PngRow := PRGBArray24(PNG.ScanLine[Y]);
          AlphaRow := PByteArray(PNG.AlphaScanline[Y]);
          for X := 0 to BMP.Width - 1 do
          begin
            with BmpRow[X] do
            begin
              with PngRow[X] do
              begin
                R := rgbtRed; G := rgbtGreen; B := rgbtBlue;
              end;
              A := Byte(AlphaRow[X]);
            end;
          end;

        end;

      end else
      begin
        for Y := 0 to BMP.Height-1 do
        begin
          BmpRow := PRGBArray32(BMP.ScanLine[Y]);
          PngRow := PRGBArray24(PNG.ScanLine[Y]);
          for X := 0 to BMP.Width - 1 do
          begin
            with BmpRow[X] do
            begin
              with PngRow[X] do
              begin
                R := rgbtRed; G := rgbtGreen; B := rgbtBlue;
              end;
              A := 255;
            end;
          end;
        end;
      end;
      Dest.Assign(BMP);
    end;
  finally
    Bmp.Free;
    PNG.Free;
  end;
end;

function GeneratePass(syllables, numbers: Byte): string;

  function Replicate(Caracter: string; Quant: Integer): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Quant do
      Result := Result + Caracter;
  end;
const
  conso: array [0..19] of Char = ('b', 'c', 'd', 'f', 'g', 'h', 'j',
    'k', 'l', 'm', 'n', 'p', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z');
  vocal: array [0..4] of Char = ('a', 'e', 'i', 'o', 'u');
var
  i: Integer;
  si, sf: Longint;
  n: string;
begin
  Result := '';
  Randomize;

  if syllables <> 0 then
    for i := 1 to syllables do
    begin
      Result := Result + conso[Random(19)];
      Result := Result + vocal[Random(4)];
    end;

  if numbers = 1 then Result := Result + IntToStr(Random(9))
  else if numbers >= 2 then
  begin
    if numbers > 9 then numbers := 9;
    si     := StrToInt('1' + Replicate('0', numbers - 1));
    sf     := StrToInt(Replicate('9', numbers));
    n      := FloatToStr(si + Random(sf));
    Result := Result + Copy(n, 0,numbers);
  end;
end;

procedure EncryptBMP(const BMP: TBitmap; Key: Integer);
var
  BytesPorScan: Integer;
  w, h: integer;
  p: pByteArray;
begin
  Screen.Cursor := crHourGlass;
  try
    BytesPorScan := Abs(Integer(BMP.ScanLine[1]) -
      Integer(BMP.ScanLine[0]));
  except
    raise Exception.Create('Error');
  end;
  RandSeed := Key;

  for h := 0 to BMP.Height - 1 do
  begin
    P := BMP.ScanLine[h];
    for w := 0 to BytesPorScan - 1 do
      P^[w] := P^[w] xor Random(StrToInt(Form1.Edit2.Text));
  end;
  Sleep(250);
  Screen.Cursor := crDefault;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  EncryptBMP(Image1.Picture.Bitmap, StrToInt(Edit1.Text));
  Image1.Refresh;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FileHeader: TBitmapFileHeader;
  InfoHeader: TBitmapInfoHeader;
  Stream    : TFileStream;
  Mem       : TMemoryStream;
  JPEGImage : TJPEGImage;
  bmp, Bitmap : TBitmap;
  GIF: TGIFImage;
begin
  if OpenDialog1.Execute then
  begin
    if OpenDialog1.FilterIndex = 1 then
    begin
      Image1.Picture.Bitmap.LoadFromFile(OpenDialog1.FileName);
      StatusBar1.Panels[1].Text := ExtractFileName(OpenDialog1.FileName);
      StatusBar1.Panels[3].Text := ExtractFileExt(OpenDialog1.FileName);
      Stream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareDenyNone);
      try
        Stream.Read(FileHeader, SizeOf(FileHeader));
        Stream.Read(InfoHeader, SizeOf(InfoHeader));
        StatusBar1.Panels[5].Text := Format('%d', [FileHeader.bfSize div 1000]) + ' Kb';
        StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biBitCount]);
        StatusBar1.Panels[9].Text := Format('%d', [InfoHeader.biWidth]) + 'x' +
                                     Format('%d', [InfoHeader.biHeight]);
      finally
        Stream.Free;
      end;
    end;

    if OpenDialog1.FilterIndex = 2 then
    begin
      JPEGImage:=TJPEGImage.Create;
      bmp := TBitmap.Create;
      JPEGImage.LoadFromFile(OpenDialog1.FileName);
      try
        with bmp do
        begin
          PixelFormat:=pf24bit;
          Height:=JPEGImage.Height;
          Width:=JPEGImage.Width;
          Canvas.Draw(0,0, JPEGImage);
        end;

        bmp.SaveToFile(ExtractFilePath(Application.ExeName) + 'Data\_res.bmp');
        Image1.Picture.Bitmap.Assign(bmp);

        Stream := TFileStream.Create(ExtractFilePath(Application.ExeName) +
                                'Data\_res.bmp', fmOpenRead or fmShareDenyNone);
        try
          Stream.Read(FileHeader, SizeOf(FileHeader));
          Stream.Read(InfoHeader, SizeOf(InfoHeader));
          StatusBar1.Panels[5].Text := Format('%d', [FileHeader.bfSize div 1000]) + ' Kb';
          StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biBitCount]);
          StatusBar1.Panels[9].Text := Format('%d', [InfoHeader.biWidth]) + 'x' +
                                       Format('%d', [InfoHeader.biHeight]);
        finally
          Stream.Free;
        end;
      finally
        JPEGImage.Free;
        bmp.Free;
      end;
      StatusBar1.Panels[1].Text := ExtractFileName(OpenDialog1.FileName);
      StatusBar1.Panels[3].Text := ExtractFileExt(OpenDialog1.FileName);
    end;

    if OpenDialog1.FilterIndex = 3 then
    begin
      try
        Bitmap := TBitmap.Create;
        LoadPngToBmp(Bitmap, OpenDialog1.FileName);
        Bitmap.SaveToFile(ExtractFilePath(Application.ExeName) + 'Data\_res.bmp');
        Image1.Picture.Bitmap.Assign(Bitmap);
        Stream := TFileStream.Create(ExtractFilePath(Application.ExeName) +
                                'Data\_res.bmp', fmOpenRead or fmShareDenyNone);

        Stream.Read(FileHeader, SizeOf(FileHeader));
        Stream.Read(InfoHeader, SizeOf(InfoHeader));
        StatusBar1.Panels[5].Text := Format('%d', [FileHeader.bfSize div 1000]) + ' Kb';
        StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biBitCount]);
        StatusBar1.Panels[9].Text := Format('%d', [InfoHeader.biWidth]) + 'x' +
                                     Format('%d', [InfoHeader.biHeight]);
      finally
        Stream.Free;
        Bitmap.Free;
      end;
      StatusBar1.Panels[1].Text := ExtractFileName(OpenDialog1.FileName);
      StatusBar1.Panels[3].Text := ExtractFileExt(OpenDialog1.FileName);
    end;

    if OpenDialog1.FilterIndex = 4 then
    begin
      try
        Bitmap := TBitmap.Create;
        GIF := TGIFImage.Create;
        GIF.LoadFromFile(OpenDialog1.FileName);
        Bitmap.Assign(GIF);
        Bitmap.SaveToFile(ExtractFilePath(Application.ExeName) +
                                  'Data\_res.bmp');
        Image1.Picture.Bitmap.Assign(Bitmap);

        Stream := TFileStream.Create(ExtractFilePath(Application.ExeName) +
                                'Data\_res.bmp', fmOpenRead or fmShareDenyNone);

        Stream.Read(FileHeader, SizeOf(FileHeader));
        Stream.Read(InfoHeader, SizeOf(InfoHeader));
        StatusBar1.Panels[5].Text := Format('%d', [FileHeader.bfSize div 1000]) + ' Kb';
        StatusBar1.Panels[7].Text := Format('%d', [InfoHeader.biBitCount]);
        StatusBar1.Panels[9].Text := Format('%d', [InfoHeader.biWidth]) + 'x' +
                                     Format('%d', [InfoHeader.biHeight]);
      finally
        Stream.Free;
      end;
      StatusBar1.Panels[1].Text := ExtractFileName(OpenDialog1.FileName);
      StatusBar1.Panels[3].Text := ExtractFileExt(OpenDialog1.FileName);
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Image1.Picture.Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
  0 : begin
        Edit1.MaxLength := 3;
        Edit1.Text := GeneratePass(0, 3);
        Edit1.Font.Color := clGreen;
      end;
  1 : begin
        Edit1.MaxLength := 5;
        Edit1.Text := GeneratePass(0, 5);
        Edit1.Font.Color := clNavy;
      end;
  2 : begin
        Edit1.MaxLength := 10;
        Edit1.Text := GeneratePass(0, 10);
        Edit1.Font.Color := clRed;
      end;
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked = true then
  begin
    Image1.AutoSize := false;
    Image1.Align := alClient;
    Image1.Stretch := true;
  end else begin
    Image1.AutoSize := true;
    Image1.Align := alNone;
    Image1.Stretch := false;
  end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if NOT (Key in [#08, '0'..'9']) then
    Key := #0;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if NOT (Key in [#08, '0'..'9']) then
    Key := #0;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
  0 : begin
        Edit1.MaxLength := 3;
        Edit1.Text := GeneratePass(0, 3);
        Edit1.Font.Color := clGreen;
      end;
  1 : begin
        Edit1.MaxLength := 5;
        Edit1.Text := GeneratePass(0, 5);
        Edit1.Font.Color := clNavy;
      end;
  2 : begin
        Edit1.MaxLength := 10;
        Edit1.Text := GeneratePass(0, 10);
        Edit1.Font.Color := clRed;
      end;
  end;
end;

end.
 