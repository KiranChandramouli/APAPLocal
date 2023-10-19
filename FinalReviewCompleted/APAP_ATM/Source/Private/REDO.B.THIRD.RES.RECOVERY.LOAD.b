* @ValidationCode : MjotNDQxNDA5NzIwOkNwMTI1MjoxNjk3MDI5MzA5MDYzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Oct 2023 18:31:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.ATM

SUBROUTINE REDO.B.THIRD.RES.RECOVERY.LOAD
*------------------------------------------------------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files with tax data checks and electronic transfer that should be send to the Government Entity (SB)

* Developed By          : Thilak Kumar K
*
* Development Reference :
*
* Attached To           : Batch - BNK/REDO.B.THIRD.RES.RECOVERY
*
* Attached As           : Online Batch Routine to COB
*--------------------------------------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*--------------------------------------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
* 29/10/2014  Ashokkumar.V.P        PACS00353049 - New mapping changes
* 12/03/2015  Ashokkumar.V.P        PACS00353049 - Added to fetch balance from TOTCOMMITMENT and rate field fix.
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.AA.ARRANGEMENT ;* R22 Auto conversion
    $INSERT I_F.AA.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.AA.TERM.AMOUNT ;* R22 Auto conversion
    $INSERT I_F.AA.INTEREST.ACCRUALS ;* R22 Auto conversion
    $INSERT I_F.EB.CONTRACT.BALANCES ;* R22 Auto conversion
    $INSERT I_F.AA.ACTIVITY.HISTORY ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.DATES ;* R22 Auto conversion
    $INSERT I_F.CURRENCY ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_TSA.COMMON ;* R22 Auto conversion
*   $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_F.RAD.CONDUIT.LINEAR ;* R22 Auto conversion
    $INSERT I_REDO.B.THIRD.RES.RECOVERY.COMMON ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $USING APAP.REDOCHNLS

*
    GOSUB INITIALISE
*
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
INITIALISE:
*----------
*Initialize all the files and varibles
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM  = ''
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'; F.AA.ARRANGEMENT  = ''
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'; F.AA.INTEREST.ACCRUALS= ''
    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES' ; F.EB.CONTRACT.BALANCES  = ''
    FN.CUSTOMER = 'F.CUSTOMER' ; F.CUSTOMER  = ''
    FN.CURRENCY = 'F.CURRENCY'; F.CURRENCY  = ''
    FN.RAD.CONDUIT.LINEAR = 'F.RAD.CONDUIT.LINEAR' ; F.RAD.CONDUIT.LINEAR  = ''
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY' ; F.AA.ACTIVITY.HISTORY  = ''
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'; F.ACCOUNT.HIS = ''
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'; F.AA.INTEREST.ACCRUALS = ''
*
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    CALL OPF(FN.RAD.CONDUIT.LINEAR,F.RAD.CONDUIT.LINEAR)
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
*
    L.APAP.INDUSTRY.POS = ''
    Y.APP = "CUSTOMER":@FM:"AA.ARR.CUSTOMER"
    Y.FIELDS = "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.PASS.NAT":@VM:"L.APAP.INDUSTRY":@FM:"L.AA.CAMP.TY"
    Y.FIELD.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FIELDS,Y.FIELD.POS)
    L.CU.TIPO.CL.POS = Y.FIELD.POS<1,1>
    L.CU.CIDENT.POS  = Y.FIELD.POS<1,2>
    L.CU.RNC.POS     = Y.FIELD.POS<1,3>
    L.CU.FOREIGN.POS = Y.FIELD.POS<1,4>
    L.APAP.INDUSTRY.POS =  Y.FIELD.POS<1,5>
    Y.CU.CAMP.POS    = Y.FIELD.POS<2,1>
*
    YLAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = TODAY
    Y.TODATE = Y.TODAY
    CALL CDT('',Y.TODATE,'-1C')
    IF YLAST.DATE[5,2] NE Y.TODATE[5,2] THEN
        COMI = YLAST.DATE[1,6]:'01'
        CALL LAST.DAY.OF.THIS.MONTH
        Y.TODATE = COMI
    END

    Y.PARAM.ID = 'REDO.RES.REC'
    R.REDO.H.REPORTS.PARAM = ''; Y.PARAM.ERR = ''
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,Y.PARAM.ERR)
*
    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.FILE.ID    = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.FILE.NAME>
        Y.FILE.DIR   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.TEMP.DIR>
        Y.FIELD.NAME    = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VALUE   = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
    END
*
    CHANGE @VM TO @FM IN Y.FIELD.VALUE
*
    LOCATE "L.AA.CAMP.TY" IN Y.FIELD.NAME<1,1> SETTING Y.CON.POS THEN
        Y.AA.CAMY.TY.VAL = Y.FIELD.VALUE<Y.CON.POS>
    END
*
    Y.FILE.NAME = Y.FILE.ID:".TEMP.":AGENT.NUMBER:".":SERVER.NAME ;* R22 Auto conversion
*
    CHANGE @VM TO '' IN Y.FILE.DIR
*
    OPENSEQ Y.FILE.DIR,Y.FILE.NAME TO SEQ.PTR ELSE
        Y.ERR.MSG   = "Unable to Open '":Y.FILE.NAME:"'"
        GOSUB RAISE.ERR.C.22
        RETURN
    END
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
*
RAISE.ERR.C.22:
*--------------
*Handling error process
*----------------------
*
    MON.TP    = "13"
    REC.CON   = "Recuperaciones de la Tercera Resolucion-":Y.ERR.MSG
    DESC      = "Recuperaciones de la Tercera Resolucion-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
* APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*R22 Manual Conversion
RETURN
*
*--------------------------------------------------------------------------------------------------------------------------------------------
END
*-------------------------------
