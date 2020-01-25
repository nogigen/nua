/* nua.l */
multipleSpaces         ([ ]+|\t)
spaces                 [ ]*
switch                 (switch1|switch2|switch3|switch4|switch5|switch6|switch7|switch8|switch9|switch10)
sensor                 (temperature|humidity|airCondition|airQuality|light|soundLevel|timestamp)
reservedVariable       ({sensor}|{switch})
integer                [0-9]+
dreal                  ([0-9]*\.[0-9]+)
ereal                  ([0-9]*\.[0-9]+[Ee][+-]?[0-9]+)
real                    {dreal}|{ereal}
digit                  [0-9]
alphabetic             ([A-Z]|[a-z])
sign                   [!-/:-?\[-`]
primFunc               ({switch}|{sensor})\(\)
extendedAlphanumerics  ({alphabetic}|{digit}|{sign})*
sendInteger            {connectUrl}.sendInteger\({reservedVariable}\)
receiveInteger         {connectUrl}.receiveInteger\(\)
nl                      \n
alphanumeric           ({alphabetic}|{digit})

nname                n{alphanumeric}*[^(;|\!=|\<=|\>=|\>|\<|\=|\:|\=\=|\&\&|\|\|)]
dname                d{alphanumeric}*[^(;|\!=|\<=|\>=|\>|\<|\=|\:|\=\=|\&\&|\|\|)]
cname                c{alphanumeric}*[^(;|\!=|\<=|\>=|\>|\<|\=|\:|\=\=|\&\&|\|\|)]
mname                    m{alphanumeric}*
leftComment             \/--
rightComment            \--\/
comment                 {leftComment}(.|\n)*[^{rightComment}]{rightComment}
string                  \".*[^\"]\"
connectUrl              connectUrl\(({string}|{cname})\)
parameter               ({nname}|{dname}|{cname}|{string}|{integer}|{real}|{reservedVariable}|{primFunc})
parameters              (({parameter}{spaces},{spaces})*{parameter})?


%%
{nl}                      { extern int lineno; lineno++;
                              /*return NL;*/
                           }

\;                        { return SEMICOLON;}
{multipleSpaces}           {}
{switch}                  {return SWITCH;}
{sensor}                  {return SENSOR;}
{nname}                     {return INT_VARIABLE;}
{dname}                   {return REAL_VARIABLE;}
{cname}                   {return STRING_VARIABLE;}
if                        {return IF;}
else                      {return ELSE;}
while                     {return WHILE;}
for                    {return FOR;}
func[ ]{mname}\({parameters}\)      {return DEFINE_FUNC;}

{primFunc}                {return PRIM_FUNC;}
{sendInteger}             {return SEND_INTEGER;}
{receiveInteger}          {return RECEIVE_INTEGER;}
{connectUrl}              {return CONNECT_URL;}
{mname}\({parameters}\)             {return CALL_FUNC;}
{comment}                  {return COMMENT;}
\(                        {return LP;}
\)                        {return RP;}
\{                        {return LB;}
\}                        {return RB;}
\+                        {return PLUS;}
\-                        {return MINUS;}
\*                        {return TIMES;}
\/                        {return DIVIDE;}
\!=                       {return NOT_EQ;}
\<=                       {return LESS_EQ;}
\>=                       {return GREATER_EQ;}
\>                        {return GREATER;}
\<                        {return LESS;}
\=                        {return ASSIGN_OP;}
\:                        {return COLON;}
\=\=                      {return EQUAL_OP;}
\&\&                      {return AND_LOGIC;}
\|\|                      {return OR_LOGIC;}

{string}                {return STRING;}

{integer}                 {return INTEGER;}
{real}                 {return REAL;}
.                      { return yytext[0]; }
%%
int yywrap() { return 1; }




