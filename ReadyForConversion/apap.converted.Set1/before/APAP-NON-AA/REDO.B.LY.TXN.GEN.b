*-----------------------------------------------------------------------------
* <Rating>-116</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LY.TXN.GEN(Y.PRGM.ID)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This subroutine is performed during daily COB. The functionality is performed
* only when "Transaccisn Interna" (internal transaction) option has been defined as point usage
* in the program and take all records by customer from REDO.LY.POINTS table to form the internal
* transactions to credit the monetary value of points generated by this program using FUNDS.TRANSFER
* standard functionality through OFS messages. In addition, subroutine reads the accounting parameters
* to use when any of these internal transactions are applied to customer's products
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date             who           Reference            Description
* 03-MAY-2010   S.Sudharsanan  ODR-2009-12-0276      Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.REDO.LY.MODALITY
$INSERT I_F.REDO.LY.PROGRAM
$INSERT I_F.REDO.LY.POINTS
$INSERT I_F.REDO.LY.POINTS.TOT
$INSERT I_F.DATES
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.BILL.DETAILS
$INSERT I_REDO.B.LY.TXN.GEN.COMMON
$INSERT I_F.FUNDS.TRANSFER
*-----------------------------------------------------------------------------
*    GOSUB PROCESS
  GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* The points are redemption to customer account through FT process
  CALL F.READ(FN.REDO.LY.PROGRAM,Y.PRGM.ID,R.PRGM,F.REDO.LY.PROGRAM,PRGM.ERR)
  Y.MODALITY = R.PRGM<REDO.PROG.MODALITY>
  Y.TXN.TYPE.F.INT = R.PRGM<REDO.PROG.TXN.TYPE.F.INT>
  Y.POINT.VALUE = R.PRGM<REDO.PROG.POINT.VALUE>
  Y.INT.ACCT = R.PRGM<REDO.PROG.INT.ACCT>
  CALL F.READ(FN.REDO.LY.MODALITY,Y.MODALITY,R.REDO.REC,F.REDO.LY.MODALITY,DR.ERR)
  Y.CURRENCY = R.REDO.REC<REDO.MOD.CURRENCY>
  SEL.CMD.POINTS = 'SELECT ':FN.REDO.LY.POINTS:' WITH PROGRAM EQ ':Y.PRGM.ID
  CALL EB.READLIST(SEL.CMD.POINTS,SEL.LIST.POINTS,'',NO.REC.POI,POINTS.ERR)
  LOOP
    REMOVE Y.PTS.ID FROM SEL.LIST.POINTS SETTING POS.PTS    ;**************************** STEP 5
  WHILE Y.PTS.ID:POS.PTS
    Y.YOT.QTY = 0
    CALL F.READU(FN.REDO.LY.POINTS,Y.PTS.ID,R.REC.LY.POINTS,F.REDO.LY.POINTS,LY.ERR,'')
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.PTS.ID,R.CUS.ACC,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)    ;************** STEP 6
    GOSUB GET.CUS.ACC         ;*************************************************************** STEP 7
    LOOP
      REMOVE Y.ACC FROM VAR.CUS.ACC SETTING POS.ACC
    WHILE Y.ACC:POS.ACC
      GOSUB GET.QTY ;******************************************************************************STEP 9,10,11
    REPEAT          ;************************************************************** STEP 13
    GOSUB UPD.REDO.LY.POINTS.TOT
  REPEAT  ;************************************************************** STEP 14
  RETURN
*-----------------------------------------------------------------------------
FT.OFS:
*-----------------------------------------------------------------------------
* The monetary values are credited to customer accout
  R.REC.FT<FT.TRANSACTION.TYPE> = Y.TXN.TYPE.F.INT
  R.REC.FT<FT.DEBIT.ACCT.NO> = Y.INT.ACCT
  R.REC.FT<FT.DEBIT.CURRENCY> = Y.CURRENCY
  R.REC.FT<FT.DEBIT.VALUE.DATE> = TODAY
  R.REC.FT<FT.CREDIT.ACCT.NO> = Y.ACC
  R.REC.FT<FT.CREDIT.CURRENCY> = Y.CURRENCY
  R.REC.FT<FT.CREDIT.AMOUNT> = Y.AMOUNT
  R.REC.FT<FT.CREDIT.VALUE.DATE> = TODAY
  APP.NAME = 'FUNDS.TRANSFER'
  OFSFUNCTION = 'I'
  PROCESS = 'PROCESS'
  OFS.SOURCE.ID = 'FT.ENTRY'
  OFSVERSION = 'FUNDS.TRANSFER,'
  GTS.MODE = ''
  NO.OF.AUTH = '0'
  TRANSACTION.ID = ''
  CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.REC.FT,OFSSTRING)
  CALL OFS.POST.MESSAGE(OFSSTRING,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
  RETURN
*------------------------------------------------------------------------------
GET.CUS.ACC:
*------------------------------------------------------------------------------
  VAR.CUS.ACC = ''
  LOOP
    REMOVE CUS.ACC.ID FROM R.CUS.ACC SETTING CUS.POS        ;******************************************* STEP7
  WHILE CUS.ACC.ID:CUS.POS
    R.ACCT.ENT.TODAY = ''  ; ACC.FLAG = '' ; DELAY.FLAG = ''
    CALL F.READ(FN.ACCT.ENT.TODAY,CUS.ACC.ID,R.ACCT.ENT.TODAY,F.ACCT.ENT.TODAY,ACCT.ERR)
    IF R.ACCT.ENT.TODAY THEN
      VAR.CUS.ACC<-1> = CUS.ACC.ID
    END
  REPEAT

  RETURN
*------------------------------------------------------------------------------
GET.QTY:
*------------------------------------------------------------------------------
*Find the quantity value based on if generation date is equal to today and also the status is equal to released (Liberada)
  Y.PRODUC = R.REC.LY.POINTS<REDO.PT.PRODUCT>
  Y.PRODUC = CHANGE(Y.PRODUC,VM,FM)
  Y.CNT.PROD = DCOUNT(Y.PRODUC,FM)
  FLG.CNT = 1
  LOOP
  WHILE FLG.CNT LE Y.CNT.PROD
    Y.PRGMS = R.REC.LY.POINTS<REDO.PT.PROGRAM,FLG.CNT>
    Y.PRGMS = CHANGE(Y.PRGMS,SM,FM)
    Y.PRGMS = CHANGE(Y.PRGMS,VM,FM)
    COUNTER = 1
    FOUND.FLAG = 1
    LOOP
    WHILE FOUND.FLAG
      FIND Y.PRGM.ID IN Y.PRGMS,COUNTER SETTING POS.PGM THEN
        Y.QTY = R.REC.LY.POINTS<REDO.PT.QUANTITY,FLG.CNT,POS.PGM>     ;***************************** STEP 9
        Y.GEN.DATE = R.REC.LY.POINTS<REDO.PT.GEN.DATE,FLG.CNT,POS.PGM>
        Y.STATUS = R.REC.LY.POINTS<REDO.PT.STATUS,FLG.CNT,POS.PGM>
        Y.EXP.DATE = R.REC.LY.POINTS<REDO.PT.EXP.DATE,FLG.CNT,POS.PGM>
        IF TODAY EQ Y.GEN.DATE AND Y.QTY GT 0  AND Y.STATUS EQ 'Liberada' THEN
          Y.AMOUNT = Y.POINT.VALUE*Y.QTY
          Y.TOT.QTY+=Y.QTY
          GOSUB FT.OFS        ;************************************************************** STEP 12
        END
      END ELSE
        FOUND.FLAG = 0
      END
      ++COUNTER
    REPEAT
    FLG.CNT +=1
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
UPD.REDO.LY.POINTS.TOT:
*-----------------------------------------------------------------------------
*To accumulate the points in respective program id's
  GOSUB UPD.PTS.MMYY
  GOSUB UPD.PTS.PGM.YY
  GOSUB UPD.PTS.YYYY
  GOSUB UPD.PTS.ALL.PGM
  GOSUB UPD.PTS.ALL.PGM.MMYY
  GOSUB UPD.PTS.ALL.PGM.YY
  GOSUB UPD.PTS.ALL.YYYY
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.MMYY:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = Y.PTS.ID:Y.PRGM.ID:CUR.MONTH:CUR.YEAR
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.PGM.YY:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = Y.PTS.ID:Y.PRGM.ID:'ALL':CUR.YEAR
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.YYYY:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = Y.PTS.ID:'ALL':CUR.YEAR
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.PGM:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = 'ALL':Y.PRGM.ID
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.PGM.MMYY:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = 'ALL':Y.PRGM.ID:CUR.MONTH:CUR.YEAR
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.PGM.YY:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = 'ALL':Y.PRGM.ID:CUR.YEAR
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.YYYY:
*---------------------------------------------------------------------------------
  TOT.POINTS.ID = 'ALL':CUR.YEAR
  R.REDO.LY.POINTS.TOT =''
  CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
  GOSUB UPD.PROCESS
  GOSUB ASSIGN.AUDIT
  CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
  RETURN
*------------------------------------------------------------------------------
UPD.PROCESS:
*---------------------------------------------------------------------------------
  VAR.AVAIL = '' ; VAR.USED = ''
  VAR.AVAIL   =  R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
  VAR.USED   =  R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS>
  VAR.AVAIL -= Y.TOT.QTY
  VAR.USED += Y.TOT.QTY
  R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS> = VAR.AVAIL
  R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS> = VAR.USED
  RETURN
*--------------------------------------------------------------------------------
ASSIGN.AUDIT:
*-------------------------------------------------------------------------------
* This section updates audit fields of REDO.LY.POINTS table
*----------------------------------------------------------
  CURR.NO = ''
  CUR.TIME = OCONV(TIME(), "MT")
  CONVERT ':' TO '' IN CUR.TIME
  CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
  IF CURR.NO EQ '' THEN
    CURR.NO = 1
  END ELSE
    ++CURR.NO
  END
  R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
  R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
  R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = TNO:'_':OPERATOR
  R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
  R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = TNO:'_':OPERATOR
  R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
  R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1
  RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
