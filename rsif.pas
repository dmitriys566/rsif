{This program is TP70 compartible, but it can be compiled by FPC or
other pascal compilers with making minimal changes}



program rsif;
{$N+}
uses cthreads,ptcgraph;
var
  n,i,l,k:longint;
  m:array[1..6,1..512] of extended;
  p:array[1..512] of extended;
  a,b,c,d,e,f:extended;
  sum,x,y,t:extended;
  fin:text;
  mid_x,mid_y,radius:integer;
  iterations:longint;
  GraphDriver,GraphMode,ErrorCode:integer;
procedure GraphOpen;
begin
   GraphDriver:=detect;
   InitGraph(GraphDriver,GraphMode,'');
   ErrorCode:=GraphResult;
   if ErrorCode<>grOk then
   begin
      writeln('Error:',
      GraphErrorMsg(ErrorCode));
      writeln('Exit');
      readln;
      halt(1);
   end;
end;
function det(cnt:integer):extended;
begin
  det:=m[1][cnt]*m[4][cnt]-m[2][cnt]*m[3][cnt];
end;

function get:longint;
var
  k:longint;
  q,p_cur:extended;
begin
  q:=random;
  p_cur:=0;
  for k:=1 to l do
  begin
    p_cur:=p_cur+p[k];
    if q<=p_cur then
    begin
      break;
    end;
  end;
  get:=k;
end;

begin
  if ParamCount = 1 then
  begin
    assign(fin,ParamStr(1));
  end
  else
  begin
    writeln('Usage: rsif <input.txt>');
    halt(1);
  end;
  reset(fin);
  i:=1;
  read(fin,radius,iterations);
  while not Eof(fin) do
  begin
    read(fin,a,b,c,d,e,f);
    m[1][i]:=a;
    m[2][i]:=b;
    m[3][i]:=c;
    m[4][i]:=d;
    m[5][i]:=e;
    m[6][i]:=f;
    inc(i);
  end;
  l:=i-1;
  for i:=1 to l do
  begin
    sum:=sum+abs(det(i));
  end;
  for i:=1 to l do
  begin
    p[i]:=abs(det(i))/sum;
    if p[i]=0 then p[i]:=0.01;
  end;
  Randomize;
  x:=1.0;
  y:=0.0;
  GraphOpen;
  mid_x:=GetMaxX div 2;
  mid_y:=GetMaxY;
  for i:=1 to iterations do
  begin
    k:=get;
    t:=x;
    x:=m[1][k]*x+m[2][k]*y+m[5][k];
    y:=m[3][k]*t+m[4][k]*y+m[6][k];
    putpixel(mid_x+round(radius*x),mid_y-round(radius*y),65280);
  end;
  readln;
  restorecrtmode;
end.
{Wrote by Dima Samosvat
If this program doesn't work or compile properly, try to modify procedure
GraphOpen}