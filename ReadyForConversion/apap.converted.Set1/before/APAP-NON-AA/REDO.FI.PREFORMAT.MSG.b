*-----------------------------------------------------------------------------------------
* <Rating>-140</Rating>
*-----------------------------------------------------------------------------------------
  SUBROUTINE REDO.FI.PREFORMAT.MSG(IN.INTERFACE, IN.FIELD.TYPE, IN.MSG, OUT.MSG,OUT.ERR)
******************************************************************************************
*     Routine to preformat message before call REDO.CONDUIT.LINEAR
*
* =========================================================================================
*
*    First Release : R09
*    Developed for : APAP
*    Developed by  : CHERRERA
*    Date          : 2012/Apr/10
*===========================================================================================
* Modifications:
* 10/04/2012 - cherrera@temenos.com
*              APAP C18 :
*              Modifications
*===========================================================================================
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/06/2015        V.P.Ashokkumar              PACS00456774           Fixed to read legacy Account number.
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT

********************************************************************************************
*

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS.MESSAGE
  END
*
  IF WERROR.MSG THEN
    PROCESS.GOAHEAD = 0
    OUT.ERR         = WERROR.MSG
  END

*
  RETURN
*


* =============
FORMAT.MSG.ERR:
* =============
*
*   Formated msg error
*
  OFS.RESP = ''
  OUT.ERR<1> = "ERROR"
  Y = FIELD(OFS.RESP,'-1/NO,',2)
  Z = INDEX(Y,",",1) - 1
  IF Z = '-1' THEN
    Z = 50
  END

  OUT.ERR<2> ="ERROR"

*
  RETURN
*

*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
  LOOP.CNT  = 1   ;   MAX.LOOPS = 1
*

  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1

    END CASE
    LOOP.CNT +=1
  REPEAT
*
  RETURN

*---------------
PROCESS.MESSAGE:
*---------------

  IF W.INTERFACE EQ "BACEN" THEN
    GOSUB PROCESS.MESSAGE.BACEN
    RETURN
  END

  IF W.INTERFACE EQ "NOMINA" THEN
    GOSUB PROCESS.MESSAGE.NOMINA
    RETURN
  END

  IF W.INTERFACE EQ "ORANGE" THEN
    GOSUB PROCESS.MESSAGE.ORANGE
    RETURN
  END

  RETURN


*---------------------
PROCESS.MESSAGE.BACEN:
*---------------------


  Y.ACCOUNT = FIELD(W.MESSAGE,",",6)
  W.AMOUNT  = FIELD(W.MESSAGE,",",5)
  W.RECORD.NUMBER = FIELD(W.MESSAGE,",",1)
  GOSUB FORMAT.ACCOUNT

  GOSUB GET.ACCOUNT.CUSTOMER.INFO

  OUT.TXT = ""
  OUT.TXT = OUT.TXT:W.RECORD.NUMBER:"@":FIELD(W.MESSAGE,",",2)
  OUT.TXT = OUT.TXT:"@":W.CUSTOMER:"@":W.CUS.NAME:"@":W.ACCOUNT:"@":W.AMOUNT

  Y.COUNT   = COUNT(W.MESSAGE,",")

  FOR FVAR = 7 TO Y.COUNT

    OUT.TXT = OUT.TXT:"@":FIELD(W.MESSAGE,",",FVAR)

  NEXT

  GOSUB REC.CONTENT

  OUT.MSG = ""
* All data
  OUT.MSG<1> = OUT.TXT
* Prepared info for rec.content
  OUT.MSG<2> = W.OUT.TXT
*Description field
  OUT.MSG<3> = FIELD(OUT.TXT,"@",8)


  RETURN


*----------------------
PROCESS.MESSAGE.NOMINA:
*----------------------

  RETURN

*----------------------
PROCESS.MESSAGE.ORANGE:
*----------------------

  W.ACCOUNT = FIELD(W.MESSAGE,",",5)
  W.AMOUNT  = FIELD(W.MESSAGE,",",7)
  CHANGE '+' TO '' IN W.AMOUNT
  W.AMOUNT = TRIM(FIELD(W.AMOUNT,'.',1),"0","L") :'.':FIELD(W.AMOUNT,'.',2)
  W.CURRENCY = FIELD(W.MESSAGE,",",2)
  W.RECORD.NUMBER = FIELD(W.MESSAGE,",",1)
* GOSUB FORMAT.ACCOUNT

  GOSUB GET.ACCOUNT.CUSTOMER.INFO

  OUT.TXT = ""
  OUT.TXT = OUT.TXT:W.RECORD.NUMBER:"@":FIELD(W.MESSAGE,",",4)
  OUT.TXT = OUT.TXT:"@":W.CUSTOMER:"@":W.CUS.NAME:"@":W.ACCOUNT:"@":W.AMOUNT

  Y.COUNT   = COUNT(W.MESSAGE,",")

  FOR FVAR = 8 TO Y.COUNT

    OUT.TXT = OUT.TXT:"@":FIELD(W.MESSAGE,",",FVAR)

  NEXT

  GOSUB REC.CONTENT

  OUT.MSG = ""
* All data
  OUT.MSG<1> = OUT.TXT
* Prepared info for rec.content
  OUT.MSG<2> = W.OUT.TXT
*Description field
  OUT.MSG<3> = FIELD(OUT.TXT,"@",8)
* Currency field
  OUT.MSG<4> = W.CURRENCY

  RETURN

*-------------------
REC.CONTENT:
*--------------------
* 'Num Registro*Numero Cuenta*Codigo Cliente*Nombre Cliente*-999*Estatus*Descripcion*FT Asociada'
  W.OUT.TXT = ""
  W.OUT.TXT = W.OUT.TXT:W.RECORD.NUMBER:"@":W.ACCOUNT
  W.OUT.TXT = W.OUT.TXT:"@":W.CUSTOMER:"@":W.CUS.NAME:"@":W.AMOUNT
  RETURN


*---------------
FORMAT.ACCOUNT:
*---------------
  ERR.ALTERNATE.ACCOUNT = ''; R.ALTERNATE.ACCOUNT = ''; YALT.ID = ''; W.ACCOUNT = ''
  YALT.ID = RIGHT(Y.ACCOUNT,12)
  CALL F.READ(FN.ALTERNATE.ACCOUNT,YALT.ID,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ERR.ALTERNATE.ACCOUNT)
  IF ERR.ALTERNATE.ACCOUNT THEN
    W.ACCOUNT = RIGHT(Y.ACCOUNT,10)
  END ELSE
    W.ACCOUNT = R.ALTERNATE.ACCOUNT
  END
*    Y.LEN = LEN(Y.ACCOUNT)
*    Y.ACCOUNT.2 = SUBSTRINGS (Y.ACCOUNT,9, Y.LEN)
*    Y.LEN2 = LEN(Y.ACCOUNT.2)
*    NUM.POS.ACCOUNT = Y.LEN2
*    Y.SWITCH ="N"
*    W.ACCOUNT = ""
*    FOR K.POSI = 1 TO NUM.POS.ACCOUNT
*        Y.CARACT = SUBSTRINGS(Y.ACCOUNT.2,K.POSI,1)
*        IF Y.CARACT EQ "0" THEN
*            IF Y.SWITCH EQ "N" THEN
*                Y.SWITCH = "N"
*            END ELSE
*                W.ACCOUNT = W.ACCOUNT:Y.CARACT
*            END
*        END ELSE
*            Y.SWITCH ="S"
*            W.ACCOUNT = W.ACCOUNT:Y.CARACT
*        END
*    NEXT K.POSI
  RETURN

* ---------
INITIALISE:
* ---------
*
  PROCESS.GOAHEAD        = 1  ;*No problems

  FN.ACCOUNT  = "F.ACCOUNT"
  F.ACCOUNT   = ""
  R.ACCOUNT   = ""
  W.ACCOUNT   = ""
  Y.ACCOUNT   = ""
  Y.ACCOUNT.2 = ""

  FN.CUSTOMER = "F.CUSTOMER"
  F.CUSTOMER = ""
  R.CUSTOMER = ""
  W.CUSTOMER = ""
  W.CUS.NAME = ""
  W.CURRENCY = ""

  W.MESSAGE = IN.MSG
  W.INTERFACE = IN.INTERFACE
  W.FIELD.TYPE = IN.FIELD.TYPE
  W.AMOUNT  = 0
  W.RECORD.NUMBER = 0
  W.OUT.TXT = ""
  OUT.TXT = ""

  NUM.POS.ACCOUNT = 0

  WERROR.MSG = ""

  FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'; F.ALTERNATE.ACCOUNT = ''
  CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)
  RETURN

*--------------------------
GET.ACCOUNT.CUSTOMER.INFO:
*--------------------------

  CALL CACHE.READ(FN.ACCOUNT,W.ACCOUNT,R.ACCOUNT, Y.ERR)
  IF Y.ERR THEN
    PROCESS.GOAHEAD = 0
    E = "EB-PARAMETER.MISSING"
    WERROR.MSG = Y.ERR
    CALL ERR
  END

* Customer T24 number
  W.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

  CALL CACHE.READ(FN.CUSTOMER,W.CUSTOMER,R.CUSTOMER, Y.ERR)
  IF Y.ERR THEN
    PROCESS.GOAHEAD = 0
    E = "EB-PARAMETER.MISSING"
    WERROR.MSG = Y.ERR
    CALL ERR
  END

* Customer name
  W.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>

  RETURN

*----------
OPEN.FILES:
* ---------
*
*   Paragraph that open files
*
*
*   OPEN  ACCOUNT
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*   OPEN  CUSTOMER
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*

*
  RETURN
*

*-------- END -------

END
