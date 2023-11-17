* @ValidationCode : Mjo0MDEzMzA2ODk6Q3AxMjUyOjE2ODU1NTAwNDY1MjA6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 21:50:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TT.LS.LC.AUTORUN
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: N. Satheesh Kumar
* PROGRAM NAME: REDO.TT.LS.LC.AUTORUN
* ODR NO      : ODR-2009-10-0331
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for REDO.PART.TT.PROCESS to
* default the value for the TELLER application from REDO.PART.TT.PROCESS
* It is AUTOM NEW CONTENT routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.PART.TT.AUTORTN
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE               WHO           REFERENCE         DESCRIPTION
*29.06.2010 N. Satheesh Kumar   ODR-2009-10-0331   INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        FM TO @FM, VM TO @VM, SM TO @SM
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION          CALL Rtn format modified
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.PART.TT.PROCESS
    $INSERT I_F.TELLER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ALTERNATE.ACCOUNT
	$USING APAP.AA

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------



    FN.REDO.PART.TT.PROCESS = 'F.REDO.PART.TT.PROCESS'
    F.REDO.PART.TT.PROCESS = ''
    CALL OPF(FN.REDO.PART.TT.PROCESS,F.REDO.PART.TT.PROCESS)
    FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    LOC.REF.APPLICATION = "TELLER":@FM:'AA.PRD.DES.OVERDUE'
    LOC.REF.FIELDS = 'L.TT.DUE.PRS':@VM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LOC.REF.FIELDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.DUE.PRS = LOC.REF.POS<1,1>
    TT.LOAN.STATUS.POS = LOC.REF.POS<1,2>
    TT.LOAN.COND.POS = LOC.REF.POS<1,3>
    OD.LOAN.STATUS.POS = LOC.REF.POS<2,1>
    OD.LOAN.COND.POS = LOC.REF.POS<2,2>

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.DATA = ""
    CALL BUILD.USER.VARIABLES(Y.DATA)
    Y.REDO.PART.TT.PROCESS.ID=FIELD(Y.DATA,"*",2)
    CALL F.READ(FN.REDO.PART.TT.PROCESS,Y.REDO.PART.TT.PROCESS.ID,R.REDO.PART.TT.PROCESS,F.REDO.PART.TT.PROCESS,PRO.ERR)

    Y.ARR.ID = R.REDO.PART.TT.PROCESS<PAY.PART.TT.ARRANGEMENT.ID>
    Y.CURRENCY= R.REDO.PART.TT.PROCESS<PAY.PART.TT.CURRENCY>
    Y.AMOUNT = R.REDO.PART.TT.PROCESS<PAY.PART.TT.AMOUNT>
    Y.TRAN.TYPE = R.REDO.PART.TT.PROCESS<PAY.PART.TT.TRAN.TYPE>
    Y.DATE =  R.REDO.PART.TT.PROCESS<PAY.PART.TT.VALUE.DATE>
    Y.REMARKS =  R.REDO.PART.TT.PROCESS<PAY.PART.TT.REMARKS>

    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.ARR.ID,R.ALT.ACC,F.ALTERNATE.ACCOUNT,ALT.ERR)
    ACC.ID = R.ALT.ACC<AAC.GLOBUS.ACCT.NUMBER>

    GOSUB GET.STATUS.COND
    R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1> = Y.AMOUNT
    R.NEW(TT.TE.CURRENCY.2) = Y.CURRENCY
    R.NEW(TT.TE.TRANSACTION.CODE) = Y.TRAN.TYPE
    R.NEW(TT.TE.ACCOUNT.2) = ACC.ID
    R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.DUE.PRS> = Y.REDO.PART.TT.PROCESS.ID
RETURN

*----------------------------------------------------------------------
GET.STATUS.COND:
*----------------------------------------------------------------------

    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
*    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    CHANGE @SM TO @VM IN LOAN.STATUS
    CHANGE @SM TO @VM IN LOAN.COND
    R.NEW(TT.TE.LOCAL.REF)<1,TT.LOAN.STATUS.POS> = LOAN.STATUS
    R.NEW(TT.TE.LOCAL.REF)<1,TT.LOAN.COND.POS> = LOAN.COND
RETURN

END
