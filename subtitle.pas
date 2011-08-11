unit subtitle;

{$mode objfpc}

interface

uses
  Classes, SysUtils; 

type
  TSubTitle=record
    fromtime, totime : TDateTime;
    text: string;
  end;
  TSubTitles = array of TSubTitle;

  { TSubTitleList }

  TSubTitleList = class
    titles: TSubTitles;
    hiddenOffset: TDateTime;
    offsetMs: double;
    scale: double;
    procedure loadfromFile(const fn: string);
    function getCurrentTitleText(): string;
  private
    procedure loadSRT(const sl: TStringList);
    procedure loadSUB(const sl: TStringList); //microdiv
  end;



implementation
uses bbutils, dregexpr;

{ TSubTitleList }

procedure TSubTitleList.loadfromFile(const fn: string);
var
 sl: TStringList;
begin
  setlength(titles,0);
  hiddenOffset:=Now;
  offsetms:=0;
  scale:=1;

  sl := TStringList.Create;
  sl.LoadFromFile(fn);
  if  copy(sl[0],1,3) = #$EF#$BB#$BF then sl[0] := copy(sl[0],4,length(sl[0])-3);
  while sl[0] = '' do sl.Delete(0);

  if strBeginsWith(sl[0],'{') then loadSUB(sl)
  else loadSRT(sl);

  sl.free;
end;

function TSubTitleList.getCurrentTitleText(): string;
var cur: Double;
 i: Integer;
begin
  Result:='';
  cur := (now - hiddenOffset)*scale + offsetMs * 1 / 24 / 60 / 60 / 1000;
  for i:=0 to high(titles) do
    if (titles[i].fromtime <= cur) and (titles[i].totime >= cur) then
      exit(titles[i].text);
end;

procedure TSubTitleList.loadSRT(const sl: TStringList);
type TState = (sExpectRecord, sExpectTime, sExpectText);
var i, index: integer;
    state: TState;

    h1,m1,s1,ms1, h2, m2, s2, ms2: integer;
    newtitle: TSubTitle;
    temp: String;
begin
  index := 0;
  for i:=0 to sl.Count-1 do begin
    case state of
      sExpectRecord: begin
        if sl[i] = '' then continue;
        if strtoint(Trim(sl[i])) < index+1 then raise Exception.Create('unexpected index: "'+trim(sl[i]) + '" expected "'+inttostr(index+1)+'"');
        inc(index);
        inc(state);
      end;
      sExpectTime: begin
         temp := sl[i];
         SScanf(temp,'%d:%d:%d,%d --> %d:%d:%d,%d', [@h1,@m1,@s1,@ms1,@h2,@m2,@s2,@ms2]);
         newtitle.text:='';
         newtitle.fromtime:=EncodeTime(h1,m1,s1,ms1);
         newtitle.totime:=EncodeTime(h2,m2,s2,ms2);
         inc(state);
      end;
      sExpectText: begin
        if sl[i] = '' then begin
          state:= sExpectRecord;
          newtitle.text:=StringReplace(newtitle.text,'<i>','',[rfReplaceAll,rfIgnoreCase]);
          newtitle.text:=StringReplace(newtitle.text,'</i>','',[rfReplaceAll,rfIgnoreCase]);
          setlength(titles,length(titles)+1);
          titles[high(titles)] := newtitle;
          continue;
        end;
        if newtitle.text<>'' then newtitle.text+=LineEnding;
        newtitle.text+=sl[i];
      end;
    end;
  end;
end;

procedure TSubTitleList.loadSUB(const sl: TStringList);
const frameToDateTime = 1 / 25        / 24 / 60 / 60  ;
var re: TRegExpr;
 i: Integer;
begin
  re := TRegExpr.Create('\{([0-9]+)\}\{([0-9]+)\}(\{[^}]+\})?(\{[^}]+\})?(.*)');
  for i:=0 to sl.Count-1 do begin
    if not re.Exec(sl[i]) then continue;
    SetLength(titles,length(titles)+1);
    titles[high(titles)].fromtime:=frameToDateTime*StrToInt(re.Match[1]);
    titles[high(titles)].totime:=frameToDateTime*StrToInt(re.Match[2]);
    titles[high(titles)].text:=StringReplace(re.Match[5],'|',LineEnding,[rfReplaceAll]);
  end;
end;

end.

