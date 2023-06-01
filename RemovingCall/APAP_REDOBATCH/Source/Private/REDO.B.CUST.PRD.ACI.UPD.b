* @ValidationCode : MjotMTUyMjI2NzE3MTpDcDEyNTI6MTY4NDg1NDM4NDIxNjpJVFNTOi0xOi0xOjM1MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 353
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
* <Rating>-55</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CUST.PRD.ACI.UPD(Y.ACCT.NO)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.UPD
* ODR Number    : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description : This batch routine is used to update the interest rate for reactive accounts annd also check the field
* l.ac.man.upd is not equal to 'yes' then it should be update the ACI record
* Linked with: N/A
* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION - VM TO @VM AND NEXT CNT TO NEXT BAS.CNT AND NEXT CNT1 TO BAS2.CNT
*-------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.ACCOUNT.CREDIT.INT
$INSERT I_F.BASIC.INTEREST
$INSERT I_F.DATES
$INSERT I_F.REDO.CUST.PRD.LIST
$INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON
$INSERT I_F.REDO.ACC.CR.INT

  GOSUB PROCESS
  RETURN
*
*-------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
*
  CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

  Y.STATUS=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1>
  Y.CATEGORY=R.ACCOUNT<AC.CATEGORY>
  Y.UPD.STATUS = Y.STATUS
  Y.REDO.ACI.ID=Y.CATEGORY:'.':Y.UPD.STATUS
  R.REDO.ACC.CR.INT=''
  REDO.ACI.ERR=''
  CALL F.READ(FN.REDO.ACC.CR.INT,Y.REDO.ACI.ID,R.REDO.ACC.CR.INT,F.REDO.ACC.CR.INT,REDO.ACI.ERR)
  IF R.REDO.ACC.CR.INT NE '' THEN
    Y.BASIC.RATE=R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE,1>
    GOSUB INT.UPD
    Y.MANUAL.UPD=R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.MAN.UPD>
    IF Y.MANUAL.UPD NE 'YES' THEN
      GOSUB ACI.UPD
    END
  END
  RETURN
*
*------------------------------------------------------------------------------------------------
INT.UPD:
*------------------------------------------------------------------------------------------------

  IF Y.BASIC.RATE EQ '' THEN
    Y.INT.RATE=R.REDO.ACC.CR.INT<ACI.CR.INT.RATE,1>
    Y.DATE=TODAY
    R.ACCOUNT<AC.LOCAL.REF,POS.L.STAT.INT.RATE>=Y.INT.RATE
    R.ACCOUNT<AC.LOCAL.REF,POS.L.DATE.INT.UPD>=Y.DATE
  END ELSE
    Y.CURR=R.ACCOUNT<AC.CURRENCY>
    BASIC.ID=Y.BASIC.RATE:Y.CURR
    SEL.BASIC.LIST=''
    NOR=''
    SEL.ERR=''
*Shek -s
* do not select and read basic.interest multiple times.
    GOSUB GetBasicIntRec

*-        SEL.BASIC="SSELECT ":FN.BASIC.INTEREST:" WITH @ID LIKE ":BASIC.ID:"..."
*-        CALL EB.READLIST(SEL.BASIC,SEL.BASIC.LIST,'',NOR,SEL.ERR)
*-        BASIC.REC.ID=SEL.BASIC.LIST<NOR>
*-        R.BASIC.INTEREST=''
*-        CALL F.READ(FN.BASIC.INTEREST,BASIC.REC.ID,R.BASIC.INTEREST,F.BASIC.INTEREST,BASIC.ERR)
*Shek -e
    Y.INT.RATE=R.BASIC.INTEREST<EB.BIN.INTEREST.RATE>
    Y.MARGIN.RATE=R.REDO.ACC.CR.INT<ACI.CR.MARGIN.RATE,1>
    Y.MARGIN.OPER=R.REDO.ACC.CR.INT<ACI.CR.MARGIN.OPER,1>
    BEGIN CASE
    CASE Y.MARGIN.OPER EQ 'ADD'
      Y.INT.RATE=(Y.INT.RATE+Y.MARGIN.RATE)
    CASE Y.MARGIN.OPER EQ 'SUBTRACT'
      Y.INT.RATE=(Y.INT.RATE-Y.MARGIN.RATE)
    CASE Y.MARGIN.OPER EQ 'MULTIPLY'
      Y.INT.RATE=(Y.INT.RATE*Y.MARGIN.RATE)
    END CASE
    Y.DATE=TODAY
    R.ACCOUNT<AC.LOCAL.REF,POS.L.STAT.INT.RATE>=Y.INT.RATE
    R.ACCOUNT<AC.LOCAL.REF,POS.L.DATE.INT.UPD>=Y.DATE
  END
  CALL F.WRITE(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT)
  RETURN
*--------------------------------------------------------------------------------
ACI.UPD:
*---------------------------------------------------------------------------------

  Y.ACI.ID=Y.ACCT.NO:'-':Y.DATE
  R.ACI.RECORD=''

  R.ACI.RECORD<IC.ACI.INTEREST.DAY.BASIS>=R.REDO.ACC.CR.INT<ACI.INTEREST.DAY.BASIS>
  R.ACI.RECORD<IC.ACI.TAX.KEY>=R.REDO.ACC.CR.INT<ACI.TAX.KEY>
  R.ACI.RECORD<IC.ACI.CR.BALANCE.TYPE>=R.REDO.ACC.CR.INT<ACI.CR.BALANCE.TYPE>
  R.ACI.RECORD<IC.ACI.CR.CALCUL.TYPE>=R.REDO.ACC.CR.INT<ACI.CR.CALCUL.TYPE>
  R.ACI.RECORD<IC.ACI.CR.MINIMUM.BAL>=R.REDO.ACC.CR.INT<ACI.CR.MINIMUM.BAL>
  R.ACI.RECORD<IC.ACI.CR.OFFSET.ONLY>=R.REDO.ACC.CR.INT<ACI.CR.OFFSET.ONLY>

  BEGIN CASE
  CASE R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE> NE ''
    CNT = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE>,@VM)
  CASE R.REDO.ACC.CR.INT<ACI.CR.INT.RATE> NE ''
    CNT = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR.INT.RATE>,@VM)
  END CASE

  FOR BAS.CNT=1 TO CNT
    R.ACI.RECORD<IC.ACI.CR.BASIC.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE,BAS.CNT>
    R.ACI.RECORD<IC.ACI.CR.INT.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.INT.RATE,BAS.CNT>
    R.ACI.RECORD<IC.ACI.CR.MARGIN.OPER,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.MARGIN.OPER,BAS.CNT>
    R.ACI.RECORD<IC.ACI.CR.MAX.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.MAX.RATE,BAS.CNT>
    R.ACI.RECORD<IC.ACI.CR.MARGIN.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.MARGIN.RATE,BAS.CNT>
    R.ACI.RECORD<IC.ACI.CR.LIMIT.AMT,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.LIMIT.AMT,BAS.CNT>
  *NEXT CNT
  NEXT BAS.CNT  ;*R22 MANUAL CONVERSTION CHANGING CNT TO BAS.CNT

  R.ACI.RECORD<IC.ACI.CR2.BALANCE.TYPE>=R.REDO.ACC.CR.INT<ACI.CR2.BALANCE.TYPE>
  R.ACI.RECORD<IC.ACI.CR2.CALCUL.TYPE>=R.REDO.ACC.CR.INT<ACI.CR2.CALCUL.TYPE>
  R.ACI.RECORD<IC.ACI.CR2.MINIMUM.BAL>=R.REDO.ACC.CR.INT<ACI.CR2.MINIMUM.BAL>
  R.ACI.RECORD<IC.ACI.CR2.OFFSET.ONLY>=R.REDO.ACC.CR.INT<ACI.CR2.OFFSET.ONLY>

  BEGIN CASE
  CASE R.REDO.ACC.CR.INT<ACI.CR2.BASIC.RATE> NE ''
    CNT1 = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR2.BASIC.RATE>,@VM)
  CASE R.REDO.ACC.CR.INT<ACI.CR2.INT.RATE> NE ''
    CNT1 = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR2.INT.RATE>,@VM)
  END CASE

  IF CNT1 NE '' THEN
    FOR BAS2.CNT=1 TO CNT1
      R.ACI.RECORD<IC.ACI.CR2.BASIC.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.BASIC.RATE,BAS2.CNT>
      R.ACI.RECORD<IC.ACI.CR2.INT.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.INT.RATE,BAS2.CNT>
      R.ACI.RECORD<IC.ACI.CR2.MARGIN.OPER,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.MARGIN.OPER,BAS2.CNT>
      R.ACI.RECORD<IC.ACI.CR2.MAX.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.MAX.RATE,BAS2.CNT>
      R.ACI.RECORD<IC.ACI.CR2.MAX.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.MARGIN.RATE,BAS2.CNT>
      R.ACI.RECORD<IC.ACI.CR2.LIMIT.AMT,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.LIMIT.AMT,BAS2.CNT>
*NEXT CNT1
    NEXT BAS2.CNT  ;*R22 MANUAL CONVERSTION CHANGING CNT TO BAS2.CNT
  END

  R.ACI.RECORD<IC.ACI.INTEREST.TAX.MIN>=R.REDO.ACC.CR.INT<ACI.INTEREST.TAX.MIN>
  R.ACI.RECORD<IC.ACI.NET.TAX>=R.REDO.ACC.CR.INT<ACI.NET.TAX>
  R.ACI.RECORD<IC.ACI.CR.MIN.BAL.ST.DTE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.BAL.ST.DTE>
  R.ACI.RECORD<IC.ACI.CR.MIN.BAL.ED.DTE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.BAL.ED.DTE>
  R.ACI.RECORD<IC.ACI.CR.ACCR.OPEN.AC>=R.REDO.ACC.CR.INT<ACI.CR.ACCR.OPEN.AC>
  R.ACI.RECORD<IC.ACI.CR.ACCR.CLOSE.AC>=R.REDO.ACC.CR.INT<ACI.CR.ACCR.CLOSE.AC>
  R.ACI.RECORD<IC.ACI.CR2.MIN.BAL.ST.DTE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.BAL.ST.DTE>
  R.ACI.RECORD<IC.ACI.CR2.MIN.BAL.ED.DTE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.BAL.ED.DTE>
  R.ACI.RECORD<IC.ACI.CR2.ACCR.OPEN.AC>=R.REDO.ACC.CR.INT<ACI.CR2.ACCR.OPEN.AC>
  R.ACI.RECORD<IC.ACI.CR2.ACCR.CLOSE.AC>=R.REDO.ACC.CR.INT<ACI.CR2.ACCR.CLOSE.AC>
  R.ACI.RECORD<IC.ACI.CR.MIN.VALUE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.VALUE>
  R.ACI.RECORD<IC.ACI.CR.MIN.WAIVE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.WAIVE>
  R.ACI.RECORD<IC.ACI.CR2.MIN.VALUE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.VALUE>
  R.ACI.RECORD<IC.ACI.CR2.MIN.WAIVE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.WAIVE>
  R.ACI.RECORD<IC.ACI.CR.ZERO.INT.BAL>=R.REDO.ACC.CR.INT<ACI.CR.ZERO.INT.BAL>
  R.ACI.RECORD<IC.ACI.CR.ZERO.INT.OC>=R.REDO.ACC.CR.INT<ACI.CR.ZERO.INT.OC>
  R.ACI.RECORD<IC.ACI.CR2.ZERO.INT.BAL>=R.REDO.ACC.CR.INT<ACI.CR2.ZERO.INT.BAL>
  R.ACI.RECORD<IC.ACI.CR2.ZERO.INT.OC>=R.REDO.ACC.CR.INT<ACI.CR2.ZERO.INT.OC>
  R.ACI.RECORD<IC.ACI.NEGATIVE.RATES>=R.REDO.ACC.CR.INT<ACI.NEGATIVE.RATES>
  R.ACI.RECORD<IC.ACI.COMPOUND.TYPE>=R.REDO.ACC.CR.INT<ACI.COMPOUND.TYPE>

  APP.NAME = 'ACCOUNT.CREDIT.INT'
  OFSFUNCT = 'I'
  PROCESS  = 'PROCESS'
  OFSVERSION = 'ACCOUNT.CREDIT.INT,'
  GTSMODE = ''
  NO.OF.AUTH = '0'
  TRANSACTION.ID = Y.ACI.ID
  OFSRECORD = ''

  OFS.MSG.ID =''
  OFS.SOURCE.ID = 'REDO.OFS.ACI.UPDATE'
  OFS.ERR = ''

  CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.ACI.RECORD,OFSRECORD)
  CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)


  RETURN

GetBasicIntRec:
*--------------
* Do not select and read basic.interest multiple times.
* save the record after 1st select/read.
  jPos = ''
  LOCATE BASIC.ID IN BASIC.INT.IDS<1> SETTING jPos THEN
    R.BASIC.INTEREST = BASIC.INT.RECS(jPos)
  END ELSE
    SEL.BASIC="SSELECT ":FN.BASIC.INTEREST:" WITH @ID LIKE ":BASIC.ID:"..."
    CALL EB.READLIST(SEL.BASIC,SEL.BASIC.LIST,'',NOR,SEL.ERR)
    BASIC.REC.ID=SEL.BASIC.LIST<NOR>
    R.BASIC.INTEREST=''
    CALL F.READ(FN.BASIC.INTEREST,BASIC.REC.ID,R.BASIC.INTEREST,F.BASIC.INTEREST,BASIC.ERR)
    BASIC.INT.CTR += 1
    IF BASIC.INT.CTR = 500 THEN
      BASIC.INT.CTR = 1
    END
    BASIC.INT.IDS<BASIC.INT.CTR> = BASIC.REC.ID
    BASIC.INT.RECS(BASIC.INT.CTR) = R.BASIC.INTEREST
  END

  RETURN
*---------(GetBasicIntRec)
*
*-------------------------------------------------------------------------
END
