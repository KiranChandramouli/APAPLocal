*--------------------------------------------------------------------------------------------------------
* <Rating>-84</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.REQUEST.REGOFF(TX.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.NOF.REQUEST.REGOFF
*--------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for the enquiry REDO.CARD.REGOFF
*Linked With  : Enquiry REDO.CARD.REGOFF
*In Parameter : N/A
*Out Parameter: TX.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
* 4th Aug 2010    SWAMINATHAN.S.R        ODR-2010-03-0400        Initial Creation
* 28 Sep 2011      Balagurunathan         PACS00131231            Bulk renewal process
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
$INSERT I_F.COMPANY
$INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

  GOSUB OPEN.PARA
  GOSUB SEL.PROC
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********

  FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST = ''
  R.REDO.CARD.REQUEST = ''
  REDO.CARD.REQUEST.ERR = ''
  CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

  FN.USER = 'F.USER'
  F.USER = ''
  CALL OPF(FN.USER,F.USER)

  FN.COMPANY = 'F.COMPANY'
  F.COMPANY =''
  CALL OPF(FN.COMPANY,F.COMPANY)

  RETURN
*--------------------------------------------------------------------------------------------------------
SEL.PROC:
***********

  GOSUB LOCATE.PROC

  SEL.CMD = 'SELECT ':FN.REDO.CARD.REQUEST:' WITH STATUS EQ "1" AND WITH RENEWAL.FLAG NE "YES" '
  Y.USER.ID = OPERATOR
  CALL F.READ(FN.USER,Y.USER.ID,R.USER.REC,F.USER,Y.ERR.USER)
  Y.COMPANY.CODE = R.USER.REC<EB.USE.COMPANY.CODE>
  IF Y.AGENCY.VAL NE '' THEN
    IF Y.COMPANY.CODE EQ 'ALL' THEN
      SEL.CMD :=" AND AGENCY EQ ":Y.AGENCY.VAL
    END ELSE
      LOCATE Y.AGENCY.VAL IN Y.COMPANY.CODE<1,1> SETTING Y.AGEN.COMP.POS THEN
        SEL.CMD :=" AND AGENCY EQ ":Y.AGENCY.VAL
      END ELSE
        ENQ.ERROR = 'EB-CANNOT.ACCESS.COMPANY'
      END
    END
  END ELSE
    CHANGE VM TO ' ' IN Y.COMPANY.CODE
    IF Y.COMPANY.CODE EQ 'ALL' THEN
      SEL.CMD.COMP = "SELECT ":FN.COMPANY
      CALL EB.READLIST(SEL.CMD.COMP,SEL.CMD.LIST,'',NO.OF.REC.COMP,Y.ERR.LIST)
      CHANGE VM TO ' ' IN SEL.CMD.LIST
      CHANGE FM TO ' ' IN SEL.CMD.LIST
      Y.COMPANY.CODE = SEL.CMD.LIST
    END
    SEL.CMD :=" AND AGENCY EQ ":Y.COMPANY.CODE
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
LOCATE.PROC:
**************

  LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
    Y.AGENCY.VAL           = D.RANGE.AND.VALUE<Y.AGENCY.POS>
    CHANGE SM TO ' ' IN Y.AGENCY.VAL
  END

  LOCATE "DATE" IN D.FIELDS<1> SETTING Y.DATE.POS  THEN
    Y.DATE.VAL         = D.RANGE.AND.VALUE<Y.DATE.POS>
    Y.DATE.VAL.FROM = D.RANGE.AND.VALUE<Y.DATE.POS,1,1>
    Y.DATE.VAL.TO = D.RANGE.AND.VALUE<Y.DATE.POS,1,2>
    IF NOT(NUM(Y.DATE.VAL.FROM)) OR LEN(Y.DATE.VAL.FROM) NE '8' OR NOT(NUM(Y.DATE.VAL.TO)) OR LEN(Y.DATE.VAL.TO) NE '8' THEN
      ENQ.ERROR = 'EB-REDO.DATE.RANGE'

    END

    IF Y.DATE.VAL.FROM[5,2] GT 12 OR Y.DATE.VAL.TO[5,2] GT 12 OR Y.DATE.VAL.FROM[7,2] GT 31 OR Y.DATE.VAL.TO[7,2] GT 31 OR Y.DATE.VAL.TO GT TODAY OR Y.DATE.VAL.FROM GT TODAY OR Y.DATE.VAL.FROM GT Y.DATE.VAL.TO THEN
      ENQ.ERROR = 'EB-REDO.DATE.RANGE'

    END
  END

  RETURN
*---------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',COUNT.LIST,ERR)
  LOOP
    REMOVE Y.CARD.REQ.ID FROM SEL.LIST SETTING POS
  WHILE Y.CARD.REQ.ID : POS

    CALL F.READ(FN.REDO.CARD.REQUEST,Y.CARD.REQ.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REDO.CARD.REQUEST.ERR)
    IF R.REDO.CARD.REQUEST THEN
      Y.CREATION.DATE = R.REDO.CARD.REQUEST<REDO.CARD.REQ.DATE>
      Y.STATUS                = R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>
      IF Y.DATE.VAL NE '' THEN
        IF Y.CREATION.DATE GE Y.DATE.VAL.FROM AND Y.CREATION.DATE LE Y.DATE.VAL.TO THEN
          GOSUB PROCESS.DATE
        END
      END ELSE
        GOSUB PROCESS.DATE
      END
    END
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.DATE:
*************
  Y.PERS.CARD.COUNT = DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD>,VM)
  GOSUB CONVERT.VM.FM
  STAT.FLG = ''
  IF Y.STATUS NE '' THEN
    IF Y.CREATION.DATE EQ TODAY THEN
      GOSUB URGENT.PROC
    END
    GOSUB PROC.MAIN
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
URGENT.PROC:
**************
  GOSUB GET.URGENT.REQ
  IF Y.PERS.CARD EQ '' THEN
    STAT.FLG = '1'
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
PROC.MAIN:
***************
  IF STAT.FLG EQ '' THEN
    GOSUB CONVERT.FM.VM

    GOSUB FINAL.ARRAY
  END
  RETURN
*---------------------------------------------------------------------------------------------------------
**************
CONVERT.VM.FM:
**************
  Y.CARD.TYPE             = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>
  Y.BIN                   = R.REDO.CARD.REQUEST<REDO.CARD.REQ.BIN>
  Y.BRANCH.ORDERQTY       = R.REDO.CARD.REQUEST<REDO.CARD.REQ.BRANCH.ORDERQTY>
  Y.REGOFF.ACCEPTQT       = R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY>
  Y.CARD.SERIES.ID        = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID>
  Y.CARD.START.NO         = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO>
  Y.PERS.CARD             = R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD>
  Y.CUSTOMER.NO           = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO>
  Y.ACCOUNT.NO            = R.REDO.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO>
  Y.CUSTOMER.NAME         = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME>
  Y.COMMENTS              = R.REDO.CARD.REQUEST<REDO.CARD.REQ.COMMENTS>

  CHANGE VM TO FM IN Y.PERS.CARD
  CHANGE VM TO FM IN Y.CARD.TYPE
  CHANGE VM TO FM IN Y.BIN
  CHANGE VM TO FM IN Y.BRANCH.ORDERQTY
  CHANGE VM TO FM IN Y.REGOFF.ACCEPTQT
  CHANGE VM TO FM IN Y.CARD.SERIES.ID
  CHANGE VM TO FM IN Y.CARD.START.NO
  CHANGE SM TO VM IN Y.CUSTOMER.NO
  CHANGE VM TO FM IN Y.CUSTOMER.NO
  CHANGE SM TO VM IN Y.CUSTOMER.NAME
  CHANGE VM TO FM IN Y.CUSTOMER.NAME
  CHANGE VM TO FM IN Y.COMMENTS
*CHANGE VM TO FM IN Y.STATUS
  CHANGE SM TO VM IN Y.ACCOUNT.NO
  CHANGE VM TO FM IN Y.ACCOUNT.NO

  RETURN
*---------------------------------------------------------------------------------------------------
**************
GET.URGENT.REQ:
**************

  Y.INIT.COUNT = 1
  LOOP
  WHILE Y.INIT.COUNT LE Y.PERS.CARD.COUNT
    LOCATE 'REGULAR' IN Y.PERS.CARD SETTING REG.POS THEN

      COM.POS = REG.POS
      GOSUB DEL.UNWANT.VALUE

    END
    LOCATE '' IN Y.PERS.CARD SETTING NUL.POS THEN
      COM.POS = NUL.POS
      GOSUB DEL.UNWANT.VALUE

    END
    Y.INIT.COUNT +=1
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
DEL.UNWANT.VALUE:

  DEL Y.PERS.CARD<COM.POS>
  DEL Y.CARD.TYPE<COM.POS>
  DEL Y.BIN<COM.POS>
  DEL Y.BRANCH.ORDERQTY<COM.POS>
  DEL Y.REGOFF.ACCEPTQT<COM.POS>
  DEL Y.CARD.SERIES.ID<COM.POS>
  DEL Y.CARD.START.NO<COM.POS>
  DEL Y.CUSTOMER.NO<COM.POS>
  DEL Y.ACCOUNT.NO<COM.POS>
  DEL Y.CUSTOMER.NAME<COM.POS>
  DEL Y.COMMENTS<COM.POS>
*DEL Y.STATUS<COM.POS>

  RETURN
*--------------------------------------------------------------------------------------------------------
**************
CONVERT.FM.VM:
***************
  CHANGE FM TO VM IN Y.PERS.CARD
  CHANGE FM TO VM IN Y.CARD.TYPE
  CHANGE FM TO VM IN Y.BIN
  CHANGE FM TO VM IN Y.BRANCH.ORDERQTY
  CHANGE FM TO VM IN Y.REGOFF.ACCEPTQT
  CHANGE FM TO VM IN Y.CARD.SERIES.ID
  CHANGE FM TO VM IN Y.CARD.START.NO
  CHANGE FM TO VM IN Y.CUSTOMER.NO
  CHANGE FM TO VM IN Y.CUSTOMER.NAME
  CHANGE FM TO VM IN Y.COMMENTS
*CHANGE FM TO VM IN Y.STATUS
  CHANGE FM TO VM IN Y.ACCOUNT.NO


  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>           =     Y.CARD.TYPE
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.BIN>                 =     Y.BIN
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.BRANCH.ORDERQTY>     =     Y.BRANCH.ORDERQTY
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY>    =     Y.REGOFF.ACCEPTQT
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID>      =     Y.CARD.SERIES.ID
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO>       =     Y.CARD.START.NO
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD>           =     Y.PERS.CARD
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO>         =     Y.CUSTOMER.NO
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO>          =     Y.ACCOUNT.NO
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME>       =     Y.CUSTOMER.NAME
  R.REDO.CARD.REQUEST<REDO.CARD.REQ.COMMENTS>            =     Y.COMMENTS
*R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>              =     Y.STATUS

  RETURN
**************
FINAL.ARRAY:
**************
  Y.DATE.FINAL                        =  Y.CREATION.DATE
  Y.AGENCY.FINAL                      =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.AGENCY>
  Y.AUTO.REQUEST.FLAG.FINAL           =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.AUTO.REQUEST.FLAG>
  Y.CARD.TYPE.FINAL                   =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>
  Y.BIN.FINAL                         =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.BIN>
  Y.BRANCH.ORDERQTY.FINAL             =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.BRANCH.ORDERQTY>
  Y.REGOFF.ACCEPTQT.FINAL             =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY>
  Y.CARD.SERIES.ID.FINAL              =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID>
  Y.CARD.START.NO.FINAL               =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO>
  Y.PERS.CARD.FINAL                   =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD>
  Y.CUSTOMER.NO.FINAL                 =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO>
  Y.ACCOUNT.NO.FINAL                  =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO>
  Y.CUSTOMER.NAME.FINAL               =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME>
  Y.COMMENTS.FINAL                    =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.COMMENTS>
  Y.STATUS.FINAL                      =  R.REDO.CARD.REQUEST<REDO.CARD.REQ.STATUS>
*********
  TX.ARRAY<-1> = Y.CARD.REQ.ID:'*':Y.AGENCY.FINAL:'*':Y.CARD.TYPE.FINAL:'*':Y.BIN.FINAL:'*':Y.BRANCH.ORDERQTY.FINAL:'*':Y.REGOFF.ACCEPTQT.FINAL:'*':Y.CARD.SERIES.ID.FINAL:'*':Y.CARD.START.NO.FINAL:'*':Y.PERS.CARD.FINAL:'*':Y.CUSTOMER.NO.FINAL:'*':Y.ACCOUNT.NO.FINAL:'*':Y.CUSTOMER.NAME.FINAL:'*':Y.COMMENTS.FINAL:'*':Y.STATUS.FINAL:'*':Y.AUTO.REQUEST.FLAG.FINAL:'*':Y.DATE.FINAL

  RETURN
END
