* @ValidationCode : MjotMTg1NzI5NzgzOkNwMTI1MjoxNjgxMjgzOTM0Mjc0OklUU1M6LTE6LTE6NTc4OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 578
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION               VM TO @VM , FM TO @FM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.ACH.REF.UPD.FT.REVERSAL
*-------------------------------------------------------

*Comments
*-------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_System

    GOSUB OPEN.FILES
    GOSUB LOCAL.REF.DET
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------


    FN.ACH.FT.REVE.TXN = 'F.ACH.FT.REVE.TXN'
    F.ACH.FT.REVE.TXN  = ''
    CALL OPF(FN.ACH.FT.REVE.TXN,F.ACH.FT.REVE.TXN)

    FN.REDO.FILE.DATE.PROCESS = 'F.REDO.FILE.DATE.PROCESS'
    F.REDO.FILE.DATE.PROCESS  = ''
    CALL OPF(FN.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

RETURN

*-----------------------------------------------------------------------------
LOCAL.REF.DET:
*-----------------------------------------------------------------------------
    LREF.APP ='FUNDS.TRANSFER'
    LREF.FIELDS = "L.COMMENTS":@VM:"L.NCF.NUMBER":@VM:"L.TT.TAX.AMT"
    LOCAL.REF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)
    POS.L.COMMENTS     = LOCAL.REF.POS<1,1>
    POS.L.NCF.NUMBER   = LOCAL.REF.POS<1,2>
    POS.L.TT.TAX.AMT   = LOCAL.REF.POS<1,3>
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ID=FIELD(R.NEW(FT.PAYMENT.DETAILS),'-',2)
    IF Y.ID THEN
        CALL F.READ(FN.ACH.FT.REVE.TXN,Y.ID,R.ACH.FT.REVE.TXN,F.ACH.FT.REVE.TXN,ACH.FT.REVE.TXN.ERR)
        R.ACH.FT.REVE.TXN = ID.NEW
        CALL F.WRITE(FN.ACH.FT.REVE.TXN,Y.ID,R.ACH.FT.REVE.TXN)
    END

    Y.ARC.FILE.NAME  = R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS>
    Y.ARC.FILE.AC.NO = FIELD(R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS>,'.',5)
    CALL F.READ(FN.REDO.FILE.DATE.PROCESS,Y.ARC.FILE.NAME,R.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS,REDO.FILE.DATE.PROCESS.ERR)
    IF R.REDO.FILE.DATE.PROCESS AND Y.ARC.FILE.AC.NO THEN
        Y.PARENT.FT.REF = R.REDO.FILE.DATE.PROCESS<REDO.FILE.PRO.PARENT.FT.REF>
        R.NEW(FT.PAYMENT.DETAILS) = 'REVERSADO-':Y.PARENT.FT.REF
    END

RETURN

*---------------------------------------------------------------
END
