* @ValidationCode : MjotMTg2NzQxNDIxNjpDcDEyNTI6MTY4NTUzNjAyMDAyNTp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.DEF.IVR.LOAN.STATUS.COND
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This is the internal call routine which updates the value of the local reference fields
* L.LOAN.STATUS.1 & L.LOAN.COND in FUNDS.TRANSFER application and determine if loan payment
* is possible based on partial payments allow condition.
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : REDO.CRR.GET.CONDITIONS
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-feb-2012       RMONDRAGON    ODR-2011-02-0099      Modified for C.3 IVR based in original
*                                                       routine REDO.V.DEF.ARC.LOAN.STATUS.COND
*                                                       for ARC-IB.
*---------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM
*11-04-2023              Samaran T                R22 Manual Code conversion               CALL routine format modified
*---------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.AA.TERM.AMOUNT
    $USING APAP.TAM

    IF VAL.TEXT THEN
        RETURN
    END

    GOSUB GET.LRF.POS
    GOSUB PROCESS

RETURN

*-----------
GET.LRF.POS:
*-----------
*----------------------------------------------------------------------
* This section gets the position of the local reference field positions
*----------------------------------------------------------------------
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LR.APP = 'AA.PRD.DES.OVERDUE':@FM:'FUNDS.TRANSFER':@FM:'AA.PRD.DES.TERM.AMOUNT'
    LR.FLDS = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LR.FLDS := 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@FM
    LR.FLDS := 'L.AA.PART.ALLOW'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)

    OD.LOAN.STATUS.POS = LR.POS<1,1>
    OD.LOAN.COND.POS =  LR.POS<1,2>
    FT.LOAN.STATUS.POS = LR.POS<2,1>
    FT.LOAN.COND.POS =  LR.POS<2,2>
    AA.PART.ALLOW.POS = LR.POS<3,1>

RETURN

*-------
PROCESS:
*-------
*------------------------------------------------------------------------------------------------------------------------------------
* This section gets the latest overdue record for the arrangement id and stores the value of loan status and condition in R.NEW of FT
*------------------------------------------------------------------------------------------------------------------------------------

    APAP.REDOVER.redoVValDefaultAmt();* R22 Manual Code conversion

    Y.ACCT.NO=COMI
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ERR)
    ARR.ID =  R.ACCOUNT<AC.ARRANGEMENT.ID>
    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
    APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;* R22 Manual Code conversion
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>

    CHANGE @SM TO @VM IN LOAN.STATUS
*PACS00952982 - Start
*CHANGE SM TO VM IN LOAN.COND
    CHANGE @SM TO '' IN LOAN.COND
*PACS00952982 - End
    R.NEW(FT.LOCAL.REF)<1,FT.LOAN.STATUS.POS> = LOAN.STATUS
    R.NEW(FT.LOCAL.REF)<1,FT.LOAN.COND.POS> = LOAN.COND
    IF ('JudicialCollection' MATCHES LOAN.STATUS) OR ('Write-off' MATCHES LOAN.STATUS) OR ('Legal' MATCHES LOAN.COND) THEN
        IF LOAN.STATUS THEN
            DISP.STATUS = LOAN.STATUS
        END
        IF LOAN.COND THEN
            DISP.STATUS : = @VM:LOAN.COND
        END
        CHANGE @VM TO ' ' IN DISP.STATUS
        AF = FT.CREDIT.ACCT.NO
        ETEXT = 'EB-STATUS.COND':@FM:DISP.STATUS
        CALL STORE.END.ERROR
        R.NEW(FT.CREDIT.ACCT.NO) = COMI
    END

RETURN

END
