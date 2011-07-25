unit subtitleviewerform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Menus, ExtCtrls, subtitle, subtitlesync;

type


  { TForm1 }

  TForm1 = class(TForm)
   ColorDialog1: TColorDialog;
   FontDialog1: TFontDialog;
   Label1: TLabel;
   MenuItem1: TMenuItem;
   MenuItem10: TMenuItem;
   MenuItem2: TMenuItem;
   MenuItem3: TMenuItem;
   MenuItem4: TMenuItem;
   MenuItem5: TMenuItem;
   MenuItem6: TMenuItem;
   MenuItem7: TMenuItem;
   MenuItem8: TMenuItem;
   MenuItem9: TMenuItem;
   OpenDialog1: TOpenDialog;
   PopupMenu1: TPopupMenu;
   Timer1: TTimer;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure Label1Click(Sender: TObject);
   procedure MenuItem10Click(Sender: TObject);
   procedure MenuItem1Click(Sender: TObject);
   procedure MenuItem2Click(Sender: TObject);
   procedure MenuItem3Click(Sender: TObject);
   procedure MenuItem4Click(Sender: TObject);
   procedure MenuItem5Click(Sender: TObject);
   procedure MenuItem6Click(Sender: TObject);
   procedure MenuItem7Click(Sender: TObject);
   procedure MenuItem8Click(Sender: TObject);
   procedure MenuItem9Click(Sender: TObject);
   procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    subtitles: TSubTitleList;
    pauseStart: TDateTime;


  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 subtitles := TSubTitleList.Create;
 pauseStart:=0;
 Label1.top:=0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  subtitles.Free;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
  if pauseStart = 0 then begin
    pauseStart := now;
    Label1.Caption:=Label1.Caption+'paused';
  end else begin
    subtitles.hiddenOffset += now - pauseStart;
    pauseStart := 0;
  end;
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
   ColorDialog1.Color:=Color;
  if ColorDialog1.Execute then color:=ColorDialog1.Color;

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    subtitles.loadfromFile(OpenDialog1.FileName);
    if form2.IsVisible then form2.setSubTitles(subtitles);
  end;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  FontDialog1.Font := Label1.Font;
  if FontDialog1.Execute then
    label1.Font:=FontDialog1.font;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
   label1.Alignment:=taRightJustify;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
   label1.Alignment:=taLeftJustify;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
  label1.Alignment:=taCenter;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  form2.setsubtitles(subtitles);
  form2.Show;
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  ColorDialog1.Color:=Label1.Font.Color;
  if ColorDialog1.Execute then label1.font.color:=ColorDialog1.Color;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (pauseStart <> 0) or (length(subtitles.titles) = 0) then exit;
  label1.Caption := subtitles.getCurrentTitleText();
end;

end.

