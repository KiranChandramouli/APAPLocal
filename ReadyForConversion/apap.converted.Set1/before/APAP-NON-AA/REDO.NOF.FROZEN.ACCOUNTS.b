*-----------------------------------------------------------------------------
* <Rating>-129</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.FROZEN.ACCOUNTS(Y.RETURN)
*----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* This is the Nofile Enquiry for the Dev FS-63
*
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : Y.RETURN
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date            Who             Reference            Description
* 08-Nov-2010  Kishore.SP      ODR-2010-03-0177      Initial Creation
* 15-Nov-2010  Ramkumar.G      ODR-2010-03-0177      Initial Creation
* 02-Dec-2010  SabariKumar.A   ODR-2010-03-0177      Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.RELATION
$INSERT I_F.DEPT.ACCT.OFFICER
$INSERT I_F.AC.LOCKED.EVENTS
*Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
*----------------------------------------------------------------------------
*
  GOSUB INITIALISE
  GOSUB LOCATE.VALUES
*
  RETURN

*----------------------------------------------------------------------------
INITIALISE:
*----------
* Intialise the necessary variables and Open the file
!
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
!
  FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
  F.ACCOUNT$HIS   = ''
  CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT$HIS)
!
  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER  = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
!
  FN.RELATION = 'F.RELATION'
  F.RELATION  = ''
  CALL OPF(FN.RELATION,F.RELATION)
!
  FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
  F.DEPT.ACCT.OFFICER  = ''
  CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
!
  FN.AC.LOCKED.EVENTS  = 'F.AC.LOCKED.EVENTS'
  F.AC.LOCKED.EVENTS   = ''
  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
!
  FN.AC.LOCKED.EVENTS.HIS  = 'F.AC.LOCKED.EVENTS$HIS'
  F.AC.LOCKED.EVENTS$HIS   = ''
  CALL OPF(FN.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS$HIS)
!
  APPL.ARRAY = "CUSTOMER":FM:"ACCOUNT":FM:'AC.LOCKED.EVENTS'
  FLD.ARRAY  = "L.CU.TIPO.CL":FM:"L.AC.NOTIFY.1":VM:"L.AC.STATUS2":FM:"L.AC.STATUS2"
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.CU.TIPO.CL.POS  = FLD.POS<1,1>
  LOC.AC.NOTIF.POS      = FLD.POS<2,1>
  LOC.STATUS.POS        = FLD.POS<2,2>
  LOC.AC.STATUS2.POS    = FLD.POS<3,1>
!
* Initialising all the required variables
!
  Y.DATE  =       "" ; Y.COUNT =       "" ; Y.NOTIF =       "" ;
!
  Y.AC.TY.POS     =       "" ; Y.AC.TYPE       =       "" ; Y.NOTIF.POS     =       "" ; Y.NOTIF.OPERAND =       "" ;
  Y.BLOCK.POS     =       "" ; Y.STA.OPERAND   =       "" ; Y.STATUS        =       "" ; Y.DATE.POS      =       "" ;
  Y.ACT.ID        =       "" ; Y.AC.SEL.POS    =       "" ; Y.ACCT.TYPE     =       "" ; Y.ACCT.NO       =       "" ;
  Y.AGENCY        =       "" ; Y.ACCT.EXEC     =       "" ; Y.CURR.BAL      =       "" ; Y.AC.CUR.NO     =       "" ;
  Y.NOTIF.TYPE    =       "" ; Y.N.INPUTTER    =       "" ; Y.N.AUTHORISER  =       "" ; Y.NOTIF.INPUT   =       "" ;
  Y.NOTIFY.AUTH    =       "" ; Y.INPUTTER      =       "" ; Y.AUTHORISER    =       "" ; Y.START.DATE    =       "" ;
  Y.INPUT.USER    =       "" ; Y.AUT.USER      =       "" ; Y.AC.COUNT      =       "" ; Y.ACT.HIS.ID    =       "" ;
  Y.HIS.COUNT     =       "" ; Y.NEW.HIS.COUNT =       "" ; Y.DATE.TIME     =       "" ; Y.NOTIFY.TYPE   =       "" ;
  Y.FLAG          =       "" ; Y.CUS.NAMES     =       "" ; Y.REL.DESC      =       "" ; CUSTOMER.ID     =       "" ;
  Y.CUS.NAME      =       "" ; Y.CLIENT.CODE   =       "" ; Y.ACCT.NAME     =       "" ; Y.SEL.ACL.LIST  =       "" ;
  Y.ACL.POS       =       "" ; Y.ACL.STATUS    =       "" ; Y.SEZ.AMOUNT    =       "" ; Y.SEZ.USER      =       "" ;
  Y.SEZ.AUTH      =       "" ; Y.FREEZING.TYPE =       "" ; Y.SEZ.LIFT.DATE =       "" ; Y.ACL.CUR.NO    =       "" ;
  Y.FREEZ.TYPE    =       "" ; Y.ACL.COUNT     =       "" ; Y.ACL.HIS.ID    =       "" ; Y.HIS.STATUS    =       "" ;
  Y.FROZEN.AMOUNT =       "" ; Y.FROZ.USER     =       "" ; Y.FROZ.AUTH     =       "" ; Y.FROZEN.INPUT  =       "" ;
  Y.FROZEN.AUTH   =       "" ; Y.SE.USER       =       "" ; Y.SE.AUTH       =       "" ; Y.SEZ.INPUT     =       "" ;
  Y.ACL.ID        =       "" ; Y.RELATION.ID   =       "" ; Y.RETURN        =       "" ; Y.RETURN.ARRAY  =       "" ;
  Y.STATUS        =       "" ; Y.AC.TYPE       =       "" ; Y.NOTIF         =       "" ; Y.NOTIFY.TYPE   =       "" ;
!
  Y.ACLK.HIS.COUNT.1      =       "" ; Y.ACLK.HIS.COUNT        =       "" ; Y.FROZ.START.DATE       =       "" ;
  Y.FROZ.LIFT.DATE        =       "" ; Y.SEZ.START.DATE        =       "" ; Y.RELATION.COUNT        =       "" ;
  Y.ACCT.OFFICER.ID       =       "" ; Y.BDY.ACCT.OFFICER      =       "" ; Y.NOTIF.START.DATE      =       "" ;
  Y.AC.TYPE.OPERAND       =       "" ; Y.NOTIF.LIFT.DATE       =       "" ; Y.PREV.ACT.NUMBER       =       "" ;
  Y.CLASSIFICATION        =       "" ; Y.ACCOUNT.NO            =       "" ; Y.ACC.ID                =       "" ;
  Y.NOT.FLAG              =       "" ; Y.CAT.FLAG              =       "" ; Y.BLK.FLAG              =       "" ;
  Y.FLAG = ''  ; FLAG.MAIN.PROC = ''
  RETURN

*----------------------------------------------------------------------------
LOCATE.VALUES:
*-------------
* Locate the values
!
  LOCATE "ACCOUNT.TYPE" IN D.FIELDS<1> SETTING Y.AC.TY.POS THEN
    Y.AC.TYPE               = D.RANGE.AND.VALUE<Y.AC.TY.POS>
    Y.CAT.FLAG = 1
  END
!
  LOCATE "NOTIFICATION" IN D.FIELDS<1> SETTING Y.NOTIF.POS THEN
    Y.NOTIF                = D.RANGE.AND.VALUE<Y.NOTIF.POS>
    Y.NOT.FLAG = 1
  END
!
  LOCATE "BLOCK" IN D.FIELDS<1> SETTING Y.BLOCK.POS THEN
    Y.STATUS             = D.RANGE.AND.VALUE<Y.BLOCK.POS>
    Y.BLK.FLAG = 1
  END

  SEL.CMD = "SELECT ":FN.AC.LOCKED.EVENTS
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  Y.CATEGORY = ''
  Y.AC.NOTIFY = ''
  Y.BLOCK = ''
  GOSUB GET.ACLOCK.IDS
  RETURN

*----------------------------------------------------------------------------
GET.ACLOCK.IDS:
*------------------------

  LOOP
    Y.AC.LOCKED.EVN = ''
    REMOVE Y.AC.LOCKED.EVN FROM SEL.LIST SETTING LOCK.POS
  WHILE Y.AC.LOCKED.EVN:LOCK.POS
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.AC.LOCKED.EVN,R.LOCKED,F.AC.LOCKED.EVENTS,EVN.ERR)
    GOSUB MAIN.PROC
  REPEAT
  RETURN
*----------------------------------------------------------------------------
MAIN.PROC:
*----------
  GOSUB AC.LOCK.DETAILS
  Y.ACC.ID = ''
  LOCATE "DATE.RANGE" IN D.FIELDS<1> SETTING Y.DATE.POS THEN
    Y.STA.OPERAND        = D.LOGICAL.OPERANDS<Y.DATE.POS>
    Y.DATE               = D.RANGE.AND.VALUE<Y.DATE.POS>
    Y.START.RG = Y.DATE<1,1,1>
    Y.END.RG = Y.DATE<1,1,2>
    Y.DATE.TIME = R.LOCKED<AC.LCK.DATE.TIME>
    Y.YEAR = TODAY[1,2]
    Y.DATE.TIME = Y.DATE.TIME[1,6]
    Y.EXACT.DATE.TIME = Y.YEAR:Y.DATE.TIME
    IF Y.EXACT.DATE.TIME GE Y.START.RG AND Y.EXACT.DATE.TIME LE Y.END.RG THEN
      Y.ACC.ID = R.LOCKED<AC.LCK.ACCOUNT.NUMBER>
      FLAG.MAIN.PROC = 1
    END
  END ELSE
    Y.ACC.ID = R.LOCKED<AC.LCK.ACCOUNT.NUMBER>
    FLAG.MAIN.PROC = 1
  END
  IF Y.ACC.ID EQ '' THEN
    RETURN
  END
  IF FLAG.MAIN.PROC EQ 1 THEN
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CATEGORY = ''
    Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    Y.AC.NOTIFY = ''
    Y.AC.NOTIFY = R.ACCOUNT<AC.LOCAL.REF,LOC.AC.NOTIF.POS>
    Y.BLOCK = ''
    Y.BLOCK = R.LOCKED<AC.LCK.LOCAL.REF,LOC.AC.STATUS2.POS>
    IF Y.BLOCK NE 'GARNISHMENT' THEN
      Y.FREEZ.TYPE = Y.BLOCK
    END
    GOSUB SEL.PROC
    GOSUB PROCESS
    Y.FROZEN.AMOUNT = ''
    Y.FROZ.USER     = ''
    Y.FROZ.AUTH     = ''
    Y.FROZEN.INPUT  = ''
    Y.FROZEN.AUTH   = ''
    Y.SEZ.AMOUNT  = ''
    Y.SE.USER     = ''
    Y.SE.AUTH     = ''
    Y.SEZ.INPUT   = ''
    Y.SEZ.AUTH    = ''
  END
  RETURN
*-------------------------------------------------------------------------------
SEL.PROC:
*---------
* Selection of records according to user
  Y.ACCOUNT.NO = ''
  Y.FLAG = ''
  IF Y.CAT.FLAG NE '' AND Y.NOT.FLAG NE '' AND Y.BLK.FLAG  NE '' THEN
    IF Y.AC.TYPE EQ Y.CATEGORY AND Y.NOTIF EQ Y.AC.NOTIFY AND Y.STATUS EQ Y.BLOCK THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG = 1
  END
  IF Y.CAT.FLAG NE '' AND Y.NOT.FLAG NE '' AND Y.FLAG NE 1 THEN
    IF Y.AC.TYPE EQ Y.CATEGORY AND Y.NOTIF EQ Y.AC.NOTIFY AND Y.FLAG NE 1 THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG = 1
  END
  IF Y.NOT.FLAG NE '' AND Y.BLK.FLAG NE '' AND Y.FLAG NE 1 THEN
    IF Y.NOTIF EQ Y.AC.NOTIFY AND Y.STATUS EQ Y.BLOCK AND Y.FLAG NE 1 THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG =1
  END
  IF Y.CAT.FLAG NE '' AND Y.BLK.FLAG NE '' AND Y.FLAG NE 1 THEN
    IF Y.AC.TYPE EQ Y.CATEGORY AND Y.STATUS EQ Y.BLOCK AND Y.FLAG NE 1 THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG = 1
  END
  IF Y.CAT.FLAG NE '' AND Y.FLAG NE 1 THEN
    IF Y.AC.TYPE EQ Y.CATEGORY AND Y.FLAG NE 1 THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG =1
  END
  IF Y.NOT.FLAG NE '' AND Y.FLAG NE 1 THEN
    IF Y.NOTIF EQ Y.AC.NOTIFY AND Y.FLAG NE 1 THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG = 1
  END
  IF Y.BLK.FLAG NE '' AND Y.FLAG NE 1 THEN
    IF Y.STATUS EQ Y.BLOCK AND Y.FLAG NE 1 THEN
      Y.ACCOUNT.NO = Y.ACC.ID
    END
    Y.FLAG =1
  END
  IF Y.FLAG EQ '' AND Y.ACCOUNT.NO EQ '' THEN
    Y.ACCOUNT.NO = Y.ACC.ID
  END

  RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------
* Form the select Array

  R.ACCOUNT = ''
  Y.NOTIF.TYPE = ''
  Y.NOTIF.START.DATE = ''
  Y.NOTIF.LIFT.DATE = ''
  Y.ACT.ID = Y.ACCOUNT.NO
  GOSUB READ.ACCOUNT
  IF R.ACCOUNT NE '' THEN
    GOSUB GET.ACCOUNT.VALUES
    GOSUB NOTIFICATION.DETAILS
    Y.ACCT.NAME = R.ACCOUNT<AC.CUSTOMER>
    GOSUB RETURN.ARRAY
  END
  RETURN

*----------------------------------------------------------------------------
GET.ACCOUNT.VALUES:
*-------------------
  Y.ACCT.TYPE            = R.ACCOUNT<AC.CATEGORY>
  Y.PREV.ACT.NUMBER      = R.ACCOUNT<AC.ALT.ACCT.ID>
  Y.ACCT.NO              = Y.ACT.ID
  Y.AGENCY               = R.ACCOUNT<AC.CO.CODE>
  Y.ACCT.EXEC            = R.ACCOUNT<AC.ACCOUNT.OFFICER>
* Y.CURR.BAL             = R.ACCOUNT<AC.OPEN.ACTUAL.BAL>;*Tus Start
  Y.CURR.BAL             = R.ECB<ECB.OPEN.ACTUAL.BAL>;*Tus End
  Y.AC.CUR.NO            = R.ACCOUNT<AC.CURR.NO>
  Y.NOTIF.TYPE           = R.ACCOUNT<AC.LOCAL.REF><1,LOC.AC.NOTIF.POS>
  Y.DATE.TIME            = R.ACCOUNT<AC.DATE.TIME>[1,6]
  Y.INPUTTER = R.ACCOUNT<AC.INPUTTER>
  Y.AUTHORISER = R.ACCOUNT<AC.AUTHORISER>
  Y.START.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
  Y.INPUT.USER = FIELD(Y.INPUTTER,"_",2)
  Y.AUT.USER =  FIELD(Y.AUTHORISER,"_",2)
  RETURN

*----------------------------------------------------------------------------
NOTIFICATION.DETAILS:
*--------------------
  Y.NOTIF.START.DATE = ''
  Y.NOTIF.LIFT.DATE = ''
  IF Y.NOTIF.TYPE NE '' THEN
    GOSUB GET.NOTIFY.START.DATE
    Y.NOTIF.START.DATE = Y.START.DATE
  END ELSE
    GOSUB GET.NOTIFY.LIFT.DATE
    Y.NOTIF.LIFT.DATE = Y.START.DATE
  END
  RETURN

*----------------------------------------------------------------------------
GET.NOTIFY.START.DATE:
*------------------------
  Y.NOTIF.TYPE.REC = ''
  IF Y.AC.CUR.NO EQ '1' THEN
    Y.DATE.TIME = R.ACCOUNT<AC.DATE.TIME>
    Y.INPUTTER = R.ACCOUNT<AC.INPUTTER>
    Y.AUTHORISER = R.ACCOUNT<AC.AUTHORISER>
    Y.START.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
    Y.INPUT.USER = FIELD(Y.INPUTTER,"_",2)
    Y.AUT.USER =  FIELD(Y.AUTHORISER,"_",2)
  END ELSE
    Y.CNT = Y.AC.CUR.NO - 1
    LOOP
    WHILE Y.CNT GE 1
      Y.HIS.ID = Y.ACT.ID:";":Y.CNT
      R.ACCOUNT.HIS = ''
      CALL F.READ(FN.ACCOUNT.HIS,Y.HIS.ID,R.ACCOUNT.HIS,F.ACCOUNT$HIS,Y.ERR.ACHIS)
      Y.NOTIF.TYPE.REC = R.ACCOUNT.HIS<AC.LOCAL.REF><1,LOC.AC.NOTIF.POS>
      IF Y.NOTIF.TYPE.REC NE '' THEN
        GOSUB GET.NOTIFY.REC.DETAILS
      END
      Y.CNT --
    REPEAT
  END
  RETURN

*----------------------------------------------------------------------------
GET.NOTIFY.LIFT.DATE:
*------------------------
  Y.NOTIF.TYPE.REC = ''
  Y.NOT.FLAG = ''
  IF Y.AC.CUR.NO EQ '1' THEN
    Y.DATE.TIME = R.ACCOUNT<AC.DATE.TIME>
    Y.INPUTTER = R.ACCOUNT<AC.INPUTTER>
    Y.AUTHORISER = R.ACCOUNT<AC.AUTHORISER>
    Y.START.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
    Y.INPUT.USER = FIELD(Y.INPUTTER,"_",2)
    Y.AUT.USER =  FIELD(Y.AUTHORISER,"_",2)
  END ELSE
    Y.CNT = Y.AC.CUR.NO - 1
    LOOP
    WHILE Y.CNT GE 1
      Y.HIS.ID = Y.ACT.ID:";":Y.CNT
      R.ACCOUNT.HIS = ''
      CALL F.READ(FN.ACCOUNT.HIS,Y.HIS.ID,R.ACCOUNT.HIS,F.ACCOUNT$HIS,Y.ERR.ACHIS)
      Y.NOTIF.TYPE.REC = R.ACCOUNT.HIS<AC.LOCAL.REF><1,LOC.AC.NOTIF.POS>
      IF Y.NOTIF.TYPE.REC EQ '' THEN
        GOSUB GET.NOTIFY.REC.DETAILS
        Y.NOT.FLAG =1
      END
      IF Y.NOTIF.TYPE.REC NE '' AND Y.NOT.FLAG EQ 1 THEN
        RETURN
      END
      Y.CNT --
    REPEAT
  END
  RETURN

*----------------------------------------------------------------------------
GET.NOTIFY.REC.DETAILS:
*-----------------------
  Y.DATE.TIME = ''
  Y.INPUTTER = ''
  Y.AUTHORISER = ''
  Y.START.DATE = ''
  Y.NOTIF.INPUT = ''
  Y.NOTIFY.AUTH = ''
  Y.DATE.TIME = R.ACCOUNT.HIS<AC.DATE.TIME>
  Y.INPUTTER = R.ACCOUNT.HIS<AC.INPUTTER>
  Y.AUTHORISER = R.ACCOUNT.HIS<AC.AUTHORISER>
  Y.START.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
  Y.NOTIF.INPUT = FIELD(Y.INPUTTER,"_",2)
  Y.NOTIFY.AUTH =  FIELD(Y.AUTHORISER,"_",2)

  RETURN
*----------------------------------------------------------------------------
AC.LOCK.DETAILS:
*---------------

  IF R.LOCKED NE '' THEN
    Y.ACL.STATUS = R.LOCKED<AC.LCK.LOCAL.REF,LOC.AC.STATUS2.POS>
* Checking if the selection field value is equal
    Y.ACL.CUR.NO = R.LOCKED<AC.LCK.CURR.NO>
    GOSUB CHECK.STATUS
  END
  RETURN

*----------------------------------------------------------------------------
CHECK.STATUS:
*------------
  Y.FROZ.START.DATE = ''
  Y.FROZ.LIFT.DATE = ''
  Y.FROZEN.AMOUNT = ''
  Y.FROZ.USER = ''
  Y.FROZ.AUTH = ''
  Y.FROZEN.INPUT = ''
  Y.FROZEN.AUTH = ''

  IF Y.ACL.STATUS NE '' THEN
    GOSUB FIND.FROZEN.START.DATE.DETAILS
  END ELSE
    GOSUB FIND.FROZEN.LIFT.DATE.DETAILS
  END
  Y.SEZ.START.DATE = ''
  Y.SEZ.AMOUNT  = ''
  Y.SE.USER     = ''
  Y.SE.AUTH     = ''
  Y.SEZ.INPUT   = ''
  Y.SEZ.AUTH    = ''

  IF Y.ACL.STATUS NE '' THEN
    GOSUB FIND.SEZ.START.DATE
  END ELSE
    GOSUB  FIND.SEZ.LIFT.DATE
  END

  IF Y.ACL.STATUS EQ '' THEN
    Y.FROZ.START.DATE = ''
    Y.FREEZ.TYPE    = ''
    Y.SEZ.START.DATE   = ''
  END

  RETURN

*----------------------------------------------------------------------------
FIND.FROZEN.START.DATE.DETAILS:
*------------------------
  Y.FRZ.CNT = ''
  Y.FRO.FLAG = ''
  IF Y.ACL.CUR.NO EQ '1' THEN
    Y.FROZ.START.DATE = ''
    Y.FROZ.LIFT.DATE  = ''
  END ELSE
    Y.FRZ.CNT = Y.ACL.CUR.NO - 1
    LOOP
    WHILE Y.FRZ.CNT GE 1
      Y.ACL.HIS.ID = Y.AC.LOCKED.EVN:";":Y.FRZ.CNT
      R.HISTORY = ''
      CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,Y.ACL.HIS.ID,R.HISTORY,F.AC.LOCKED.EVENTS$HIS,Y.ACL.HIS.ERR)
      Y.HIS.STATUS = R.HISTORY<AC.LCK.LOCAL.REF><1,LOC.AC.STATUS2.POS>
      IF Y.HIS.STATUS NE "GARNISHMENT" AND Y.HIS.STATUS NE '' AND Y.FRO.FLAG NE 1 THEN
        Y.DATE.TIME = R.HISTORY<AC.LCK.DATE.TIME>
        Y.FROZ.START.DATE  = TODAY[1,2]:Y.DATE.TIME[1,6]
        Y.FROZEN.AMOUNT = R.HISTORY<AC.LCK.LOCKED.AMOUNT>
        Y.FROZ.USER     = R.HISTORY<AC.LCK.INPUTTER>
        Y.FROZ.AUTH     = R.HISTORY<AC.LCK.AUTHORISER>
        Y.FROZEN.INPUT  = FIELD(Y.FROZ.USER,'_',2)
        Y.FROZEN.AUTH   = FIELD(Y.FROZ.AUTH,'_',2)
        Y.FRO.FLAG = 1
      END
      Y.FRZ.CNT--
    REPEAT
  END
  RETURN

*----------------------------------------------------------------------------
FIND.FROZEN.LIFT.DATE.DETAILS:
*--------------------------------
  Y.FRZ.CNT = ''
  Y.FZ.FLAG = ''
  IF Y.ACL.CUR.NO EQ '1' THEN
    Y.FROZ.START.DATE = ''
    Y.FROZ.LIFT.DATE  = ''
  END ELSE
    Y.FRZ.CNT = Y.ACL.CUR.NO - 1
    LOOP
    WHILE Y.FRZ.CNT GE 1
      Y.ACL.HIS.ID = Y.AC.LOCKED.EVN:";":Y.FRZ.CNT
      R.HISTORY = ''
      CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,Y.ACL.HIS.ID,R.HISTORY,F.AC.LOCKED.EVENTS$HIS,Y.ACL.HIS.ERR)
      Y.HIS.STATUS = R.HISTORY<AC.LCK.LOCAL.REF><1,LOC.AC.STATUS2.POS>
      IF Y.HIS.STATUS EQ '' THEN
        Y.DATE.TIME = R.HISTORY<AC.LCK.DATE.TIME>
        Y.FROZ.LIFT.DATE  = TODAY[1,2]:Y.DATE.TIME[1,6]
        Y.FROZEN.AMOUNT = R.HISTORY<AC.LCK.LOCKED.AMOUNT>
        Y.FROZ.USER     = R.HISTORY<AC.LCK.INPUTTER>
        Y.FROZ.AUTH     = R.HISTORY<AC.LCK.AUTHORISER>
        Y.FROZEN.INPUT  = FIELD(Y.FROZ.USER,'_',2)
        Y.FROZEN.AUTH   = FIELD(Y.FROZ.AUTH,'_',2)
        Y.FZ.FLAG = 1
      END
      IF Y.HIS.STATUS NE 'GARNISHMENT' AND Y.HIS.STATUS NE '' AND Y.FZ.FLAG EQ 1 THEN
        RETURN
      END
      Y.FRZ.CNT --
    REPEAT
  END
  RETURN

*----------------------------------------------------------------------------
FIND.SEZ.START.DATE:
*---------------------
  Y.SEZ.CNT = ''
  IF Y.ACL.CUR.NO EQ '1' THEN
    Y.SEZ.START.DATE = ''
  END ELSE
    Y.SEZ.CNT = Y.ACL.CUR.NO - 1
    LOOP
    WHILE Y.SEZ.CNT GE 1
      Y.ACL.HIS.ID = Y.AC.LOCKED.EVN:";":Y.SEZ.CNT
      R.HISTORY = ''
      CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,Y.ACL.HIS.ID,R.HISTORY,F.AC.LOCKED.EVENTS$HIS,Y.ACL.HIS.ERR)
      Y.HIS.STATUS = R.HISTORY<AC.LCK.LOCAL.REF><1,LOC.AC.STATUS2.POS>
      IF Y.HIS.STATUS EQ 'GARNISHMENT' THEN
        Y.DATE.TIME = R.HISTORY<AC.LCK.DATE.TIME>
        Y.SEZ.START.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        Y.SEZ.AMOUNT  = R.HISTORY<AC.LCK.LOCKED.AMOUNT>
        Y.SE.USER     = R.HISTORY<AC.LCK.INPUTTER>
        Y.SE.AUTH     = R.HISTORY<AC.LCK.AUTHORISER>
        Y.SEZ.INPUT   = FIELD(Y.SE.USER,'_',2)
        Y.SEZ.AUTH    = FIELD(Y.SE.AUTH,'_',2)
        Y.SEZ.FLAG = 1
      END
      IF Y.SEZ.FLAG EQ 1 AND Y.HIS.STATUS NE 'GARNISHMENT' THEN
        RETURN
      END
      Y.SEZ.CNT --
    REPEAT
  END
  RETURN

*----------------------------------------------------------------------------
FIND.SEZ.LIFT.DATE:
*---------------------
  Y.SEZ.CNT = ''
  Y.SEZ.FLAG = ''
  IF Y.ACL.CUR.NO EQ '1' THEN
    Y.SEZ.LIFT.DATE = ''
  END ELSE
    Y.SEZ.CNT = Y.ACL.CUR.NO - 1
    LOOP
    WHILE Y.SEZ.CNT GE 1
      Y.ACL.HIS.ID = Y.AC.LOCKED.EVN:";":Y.SEZ.CNT
      R.HISTORY = ''
      CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,Y.ACL.HIS.ID,R.HISTORY,F.AC.LOCKED.EVENTS$HIS,Y.ACL.HIS.ERR)
      Y.HIS.STATUS = R.HISTORY<AC.LCK.LOCAL.REF><1,LOC.AC.STATUS2.POS>
      IF Y.SEZ.FLAG EQ 1 THEN
        IF Y.HIS.STATUS EQ 'GARNISHMENT' THEN
          RETURN
        END ELSE
          Y.DATE.TIME = ''
          Y.SEZ.FLAG = 0
        END
      END
      IF Y.HIS.STATUS EQ '' THEN
        Y.SEZ.FLAG = 1
        Y.SEZ.AMOUNT  = R.HISTORY<AC.LCK.LOCKED.AMOUNT>
        Y.SE.USER     = R.HISTORY<AC.LCK.INPUTTER>
        Y.SE.AUTH     = R.HISTORY<AC.LCK.AUTHORISER>
        Y.SEZ.INPUT   = FIELD(Y.SE.USER,'_',2)
        Y.SEZ.AUTH    = FIELD(Y.SE.AUTH,'_',2)
        Y.DATE.TIME = R.HISTORY<AC.LCK.DATE.TIME>
        Y.LIFT.DATE = Y.DATE.TIME
        Y.SEZ.LIFT.DATE = TODAY[1,2]:Y.LIFT.DATE[1,6]
      END
      Y.SEZ.CNT --
    REPEAT
  END
  RETURN

*----------------------------------------------------------------------------
READ.ACCOUNT:
*-----------
  R.ACCOUNT = ''
  CALL F.READ(FN.ACCOUNT,Y.ACT.ID,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
  R.ECB='' ; ECB.ERR='' ;*Tus Start
  CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.ACT.ID,R.ECB,ECB.ERR);*Tus End
  RETURN


*----------------------------------------------------------------------------
READ.CUSTOMER:
*-------------
  R.CUSTOMER = ''
  CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
  RETURN

*----------------------------------------------------------------------------
RETURN.ARRAY:
*------------
  IF Y.RETURN NE '' THEN
    Y.RETURN<-1> = Y.ACCT.TYPE:"*":Y.PREV.ACT.NUMBER:"*":Y.ACCT.NO:"*":Y.AGENCY:"*":Y.ACCT.EXEC:"*":Y.ACCT.NAME:"*":Y.CURR.BAL:"*":Y.NOTIF.TYPE:"*":Y.NOTIF.START.DATE:"*":Y.NOTIF.LIFT.DATE:"*":Y.NOTIF.INPUT:"*":Y.NOTIFY.AUTH:"*":Y.FREEZ.TYPE:"*":Y.FROZ.START.DATE:"*":Y.FROZEN.AMOUNT:"*":Y.FROZ.LIFT.DATE:"*":Y.FROZEN.INPUT:"*":Y.FROZEN.AUTH:"*":Y.SEZ.START.DATE:"*":Y.SEZ.AMOUNT:"*":Y.SEZ.LIFT.DATE:"*":Y.SEZ.INPUT:"*":Y.SEZ.AUTH
!                         1                  2                    3            4             5               6               7             8                   9                     10                 11                12                13                 14                      15                  16                 17                 18                19                  20                21                22               23
  END ELSE
    Y.RETURN     = Y.ACCT.TYPE:"*":Y.PREV.ACT.NUMBER:"*":Y.ACCT.NO:"*":Y.AGENCY:"*":Y.ACCT.EXEC:"*":Y.ACCT.NAME:"*":Y.CURR.BAL:"*":Y.NOTIF.TYPE:"*":Y.NOTIF.START.DATE:"*":Y.NOTIF.LIFT.DATE:"*":Y.NOTIF.INPUT:"*":Y.NOTIFY.AUTH:"*":Y.FREEZ.TYPE:"*":Y.FROZ.START.DATE:"*":Y.FROZEN.AMOUNT:"*":Y.FROZ.LIFT.DATE:"*":Y.FROZEN.INPUT:"*":Y.FROZEN.AUTH:"*":Y.SEZ.START.DATE:"*":Y.SEZ.AMOUNT:"*":Y.SEZ.LIFT.DATE:"*":Y.SEZ.INPUT:"*":Y.SEZ.AUTH
!                         1                  2                    3            4             5               6               7             8                   9                     10                 11                12                13                 14                      15                  16                 17                 18                19                  20                21                22               23
  END
  RETURN
*----------------------------------------------------------------------------
END
