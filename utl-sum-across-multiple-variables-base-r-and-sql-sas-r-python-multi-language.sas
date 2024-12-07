%let pgm=utl-sum-across-multiple-variables-base-r-and-sql-sas-r-python-multi-language;

%stop_submission;

Sum across multiple variables base r and sql sas r python multi language

  SOLUTIONS

   1 sas sql
   2 r sql
   3 python sql
   4 base r
     I could not get it to work
     Error in `contrasts<-`(`*tmp*`, value = contr) :

github
https://tinyurl.com/yc6493c4
https://github.com/rogerjdeangelis/utl-sum-across-multiple-variables-base-r-and-sql-sas-r-python-multi-language

stackoverflow r
https://tinyurl.com/nnmufzv7
https://stackoverflow.com/questions/79257683/across-dimension-computation

SOAPBOX ON
==========

R and especially python lack easy to use code generators.
Python is especially tricky due to forced indentation.
Python also deprecates the easy to use cross language sqllite dialect.
So minimally you will need to know two sql dialects?
Also python sqllite is very slow compared to r.

Both R abd Python lack the simplicity of SAS macro language.

Op does not define 'real large data'

'I work with a real large dataset.'.

I assume it is NOT big data, ie single table over 1tb.
I have 32 processors and 128gb ram and dual 1tb
NVMe drives (system cost less that $1000 on ebay)
Purchased from a gammer on ebay? Gammers
seem to want the latest hardware?

Maybe I am missing something but this seems like a very
trivial problem. Maybe not so trivial with big data?

SOAPBOX OFF
==========

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/


/**************************************************************************************************************************/
/*                                         |                                        |                                     */
/*                                         |                                        |                                     */
/*                INPUT                    |        PROCESS                         |           OUTPUT                    */
/*                =====                    |        =======                         |           ======                    */
/*                                         |                                        |                                     */
/*  SD1.HAVE total obs=4                   |  Create colum right as                 |                               ADD   */
/*                                         |  sum(ELTA1,ELTA2,ELTA0                 |                               THIS  */
/*   GEO    TIME    ELTA1  ELTA2   ELTA    |                                        |  GEO TIME  ELTA1 ELTA2  ELTA  RIGHT */
/*                                         |                                        |                                     */
/*   AT     2020     150     60     210    | 1 SAS SQL (see below)                  |  AT  2020   150    60    210    420 */
/*   BE     2020       .     70     110    |  ====================                  |  BE  2020     .    70    110    180 */
/*   CZ     2021     120     80     200    |                                        |  CZ  2021   120    80    200    400 */
/*   DE     2021       .      .    8200    |    select                              |  DE  2021     .     .   8200   8200 */
/*                                         |       *                                |                                     */
/*                                         |      ,sum(%utl_varlist(                |                                     */
/*                                         |        sd1.have                        |                                     */
/*                                         |         ,keep=ELTA:                    |                                     */
/*                                         |        ,od=%str(,))) as right          |                                     */
/*                                         |   from                                 |                                     */
/*                                         |      sd1.have                          |                                     */
/*                                         |                                        |                                     */
/*                                         |   GENERATED CODE                       |                                     */
/*                                         |   ==============                       |                                     */
/*                                         |                                        |                                     */
/*                                         |   select                               |                                     */
/*                                         |      *                                 |                                     */
/*                                         |     ,sum(ELTA1,ELTA2,ELTA)             |                                     */
/*                                         |       as right                         |                                     */
/*                                         |   from                                 |                                     */
/*                                         |      sd1.have                          |                                     */
/*                                         |                                        |                                     */
/*                                         |----------------------------------------|                                     */
/*                                         |                                        |                                     */
/*                                         | 2 r SQL (see below)                    |                                     */
/*                                         | ====================                   |                                     */
/*                                         |                                        |                                     */
/*                                         |   /*--- missings = 0 ---*/             |                                     */
/*                                         |   have[is.na(have)] <- 0               |                                     */
/*                                         |                                        |                                     */
/*                                         |   want<-sqldf("                        |                                     */
/*                                         |     select                             |                                     */
/*                                         |        *                               |                                     */
/*                                         |       ,(&elt) as right                 |                                     */
/*                                         |     from                               |                                     */
/*                                         |        have                            |                                     */
/*                                         |     ")                                 |                                     */
/*                                         |                                        |                                     */
/*                                         |      sd1.have                          |                                     */
/*                                         |                                        |                                     */
/*                                         |----------------------------------------|                                     */
/*                                         |                                        |                                     */
/*                                         | 3 r python (see below)                 |                                     */
/*                                         | ====================                   |                                     */
/*                                         |                                        |                                     */
/*                                         |   /*--- missings = 0 ---*/             |                                     */
/*                                         |   have = have.fillna(0)                |                                     */
/*                                         |                                        |                                     */
/*                                         |   want=pdsql('''        \              |                                     */
/*                                         |     select              \              |                                     */
/*                                         |        *                \              |                                     */
/*                                         |       ,(&elt) as right  \              |                                     */
/*                                         |     from                \              |                                     */
/*                                         |        have             \              |                                     */
/*                                         |      ''');                             |                                     */
/*                                         |                                        |                                     */
/*                                         |----------------------------------------|                                     */
/*                                         |                                        |                                     */
/*                                         | 4 base r (did not work?)               |                                     */
/*                                         |   Error ontrasts<-(*tmp*,value=contr)  |                                     */
/*                                         |   accepted solution                    |                                     */
/*                                         |  ===================================== |                                     */
/*                                         |                                        |                                     */
/*                                         |   left_side <- "ELTA"                  |                                     */
/*                                         |   right_side <- C("ELTA1","ELTA2")     |                                     */
/*                                         |   have <- have %>%                     |                                     */
/*                                         |     rowwise() %>%                      |                                     */
/*                                         |     mutate(right =                     |                                     */
/*                                         |       sum(c_across(                    |                                     */
/*                                         |       any_of(c(right_side,left_side))  |                                     */
/*                                         |       ),na.rm = TRUE)) %>%             |                                     */
/*                                         |     ungroup()                          |                                     */
/*                                         |   have                                 |                                     */
/*                                         |   want<-have %>%                       |                                     */
/*                                         |       mutate(across(all_of(right_side),|                                     */
/*                                         |        ~ ifelse(is.na(.x) &            |                                     */
/*                                         |       (right == !!sym(left_side))      |                                     */
/*                                         |       ,replace_na(.x,0), .x)))         |                                     */
/*                                         |   have                                 |                                     */
/*                                         |                                        |                                     */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input geo$ time EltA1 EltA2 EltA;
cards4;
AT 2020   150    60  210
BE 2020     .    70  110
CZ 2021   120    80  200
DE 2021     .     . 8200
;;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.HAVE total obs=4                                                                                                   */
/*                                                                                                                        */
/*  GEO    TIME    ELTA1    ELTA2    ELTA                                                                                 */
/*                                                                                                                        */
/*  AT     2020     150       60      210                                                                                 */
/*  BE     2020       .       70      110                                                                                 */
/*  CZ     2021     120       80      200                                                                                 */
/*  DE     2021       .        .     8200                                                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
  create
     table want as
  select
     *
    ,sum(%utl_varlist(
      sd1.have
      ,keep=ELTA:
      ,od=%str(,))) as right
  from
     sd1.have
;quit;

/*--- note the varlist maco creates

%let elt=%utl_varlist(sd1.have,keep=ELTA:,od=%str(,));
%put &=elt;

ELT= ELTA1,ELTA2,ELTA


proc sql;
  create
     table want as
  select
     *
    ,sum(ELTA1,ELTA2,ELTA)
      as right
  from
     sd1.have
;quit;

---*/


/**************************************************************************************************************************/
/*                                                                                                                        */
/* 40 obs from WANT total obs=4 07DEC2024:07:23:10                                                                        */
/*  GEO    TIME    ELTA1    ELTA2    ELTA    RIGHT                                                                        */
/*                                                                                                                        */
/*  AT     2020     150       60      210      420                                                                        */
/*  BE     2020       .       70      110      180                                                                        */
/*  CZ     2021     120       80      200      400                                                                        */
/*  DE     2021       .        .     8200     8200                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%let elt=%utl_varlist(sd1.have,keep=ELTA:,od=%str(+));
%put &=elt;

/*--- ELT=ELTA1+ELTA2+ELTA ---*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

options validvarname=upcase;
libname sd1 "d:/sd1";

%utl_rbeginx;
parmcards4;
library(sqldf)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
have[is.na(have)] <- 0
want<-sqldf("
  select
     *
    ,(&elt) as right
  from
     have
  ")
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                   |                                                                                    */
/*  R                                |                                                                                    */
/*                                   |                                                                                    */
/*    GEO    TIME ELTA1 ELTA2  ELTA  | ROWNAMES    GEO    TIME    ELTA1    ELTA2    ELTA    RIGHT                         */
/*    <chr> <dbl> <dbl> <dbl> <dbl>  |                                                                                    */
/*  1 AT     2020   150    60   210  |     1       AT     2020     150       60      210      420                         */
/*  2 BE     2020    NA    70   110  |     2       BE     2020       0       70      110      180                         */
/*  3 CZ     2021   120    80   200  |     3       CZ     2021     120       80      200      400                         */
/*  4 DE     2021    NA    NA  8200  |     4       DE     2021       0        0     8200     8200                         */
/*                                   |                                                                                    */
/**************************************************************************************************************************/


%let elt=%utl_varlist(sd1.have,keep=ELTA:,od=%str(+));
%put &=elt;

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
have = have.fillna(0)
want=pdsql('''        \
  select              \
     *                \
    ,(&elt) as right  \
  from                \
     have             \
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx(resolve=Y);

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                                              |                                                                         */
/* Python                                       |    SAS                                                                  */
/*                                              |                                                                         */
/*   GEO    TIME  ELTA1  ELTA2    ELTA   right  |     GEO    TIME    ELTA1    ELTA2    ELTA    RIGHT                      */
/*                                              |                                                                         */
/* 0  AT  2020.0  150.0   60.0   210.0   420.0  |     AT     2020     150       60      210      420                      */
/* 1  BE  2020.0    0.0   70.0   110.0   180.0  |     BE     2020       0       70      110      180                      */
/* 2  CZ  2021.0  120.0   80.0   200.0   400.0  |     CZ     2021     120       80      200      400                      */
/* 3  DE  2021.0    0.0    0.0  8200.0  8200.0  |     DE     2021       0        0     8200     8200                      */
/*                                              |                                                                         */
/**************************************************************************************************************************/

/*  _     _
| || |   | |__   __ _ ___  ___   _ __
| || |_  | `_ \ / _` / __|/ _ \ | `__|
|__   _| | |_) | (_| \__ \  __/ | |
   |_|   |_.__/ \__,_|___/\___| |_|
       _     _               _                        _    ___
  __| (_) __| |  _ __   ___ | |_  __      _____  _ __| | _|__ \
 / _` | |/ _` | | `_ \ / _ \| __| \ \ /\ / / _ \| `__| |/ / / /
| (_| | | (_| | | | | | (_) | |_   \ V  V / (_) | |  |   < |_|
 \__,_|_|\__,_| |_| |_|\___/ \__|   \_/\_/ \___/|_|  |_|\_\(_)

*/


proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

options validvarname=upcase;
libname sd1 "d:/sd1";

%utl_rbeginx;
parmcards4;
library(haven)
library(rlang)
library(tidyverse)
#source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
left_side <- "ELTA"
right_side <- C("ELTA1","ELTA2")
have <- have %>%
  rowwise() %>%
  mutate(right =
    sum(c_across(
    any_of(c(right_side,left_side))
    ),na.rm = TRUE)) %>%
  ungroup()
have
want<-have %>%
    mutate(across(all_of(right_side),
     ~ ifelse(is.na(.x) &
    (right == !!sym(left_side))
    ,replace_na(.x,0), .x)))
have
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
