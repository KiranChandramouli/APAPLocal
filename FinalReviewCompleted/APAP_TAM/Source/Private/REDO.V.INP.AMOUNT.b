* @ValidationCode : MjoxMzYwMTU4NDIzOkNwMTI1MjoxNjg5NTgzMDg2MDE3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Jul 2023 14:08:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.INP.AMOUNT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.INP.AMOUNT
* ODR NO      : ODR-2009-10-0322
*----------------------------------------------------------------------
*DESCRIPTION: This is the  Routine for check the amount value is equal to REDO.TFS.PROCESS to
* the T24.FUND.SERVICES,SERVICE.CREATE amount field value. through the error, if it is mismatched
* It is INPUT Routine

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.TFS.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE          WHO                   REFERENCE           DESCRIPTION
* 15/05/2010    S SUDHARSANAN         ODR-2009-10-0322    INITIAL CREATION
* 20/05/2013    Vignesh Kumaar M R    PACS00289413        L.TT.NO.OF.CHQ to be set as mandatory for cheque
*13/07/2023	    CONVERSION TOOL                           AUTO R22 CODE CONVERSION-VM TO @VM,FM TO @FM
*13/07/2023	    VIGNESHWARI	                              MANUAL R22 CODE CONVERSION-NOCHANGE
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB INIT

    BEGIN CASE
        CASE APPLICATION EQ 'T24.FUND.SERVICES'
            GOSUB TFS.PROCESS
        CASE APPLICATION EQ 'TELLER'
            GOSUB TELLER.PROCESS

    END CASE

RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.REDO.TFS.PROCESS = 'F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS = ''
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)

    LOC.REF.APPLICATION="T24.FUND.SERVICES":@FM:"TELLER"
    LOC.REF.FIELDS='L.TT.PROCESS':@VM:'L.TT.NO.OF.CHQ':@FM:'L.COMMENTS'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.PROCESS = LOC.REF.POS<1,1>
    POS.L.TT.NO.OF.CHQ =   LOC.REF.POS<1,2>         ;* Added for PACS00289413
    POS.L.COMMENTS = LOC.REF.POS<2,1>

RETURN
*----------------------------------------------------------------------
TFS.PROCESS:
*----------------------------------------------------------------------

* Fix for PACS00289413 [L.TT.NO.OF.CHQ to be set as mandatory for cheque]

    GET.NO.OF.CHEQUE = R.NEW(TFS.LOCAL.REF)<1,POS.L.TT.NO.OF.CHQ>
    GET.TRANS.TYPE = R.NEW(TFS.TRANSACTION)

    CHQ.FLAG = ''
    LOCATE 'CHQDEP' IN GET.TRANS.TYPE<1,1> SETTING TRANS.POS THEN
        CHQ.FLAG = '1'
    END

    LOCATE 'FCHQDEP' IN GET.TRANS.TYPE<1,1> SETTING TRANS.POS THEN
        CHQ.FLAG = '1'
    END

    IF CHQ.FLAG AND GET.NO.OF.CHEQUE EQ '' THEN
        AF = TFS.LOCAL.REF
        AV = POS.L.TT.NO.OF.CHQ
        AS = 1
        ETEXT = "AC-MAND.FLD"
        CALL STORE.END.ERROR
    END

* End of Fix

*Checking TFS amount value equal with the local table amount value
    Y.REDO.TFS.PROCESS.ID = R.NEW(TFS.LOCAL.REF)<1,POS.L.TT.PROCESS>
    CALL F.READ(FN.REDO.TFS.PROCESS,Y.REDO.TFS.PROCESS.ID,R.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS,PRO.ERR)
    Y.COUNT=DCOUNT(R.REDO.TFS.PROCESS<TFS.PRO.AMOUNT>,@VM)
    Y.TFS.COUNT = DCOUNT(R.NEW(TFS.AMOUNT),@VM)
*IF Y.COUNT EQ Y.TFS.COUNT THEN
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.TFS.AMT = R.NEW(TFS.AMOUNT)<1,Y.CNT>
        Y.AMT = R.REDO.TFS.PROCESS<TFS.PRO.AMOUNT,Y.CNT>
        IF Y.TFS.AMT NE Y.AMT THEN
            AF=TFS.AMOUNT
            AV=Y.CNT
            ETEXT='TT-TFS.AMT.CHECK-&':@FM:Y.AMT
            CALL STORE.END.ERROR
            RETURN
        END
        Y.CNT += 1
    REPEAT
*END
RETURN
*----------------------------------------------------------------------
TELLER.PROCESS:
*----------------------------------------------------------------------
*Checking TELLER amount value equal with the local table amount value
    Y.TELLER.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>
    Y.AMT = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.COMMENTS>
    IF Y.TELLER.AMT NE Y.AMT AND Y.AMT NE "" THEN
        AF=TT.TE.AMOUNT.LOCAL.1
        AV=1
        ETEXT='TT-TFS.AMT.CHECK-&':@FM:Y.AMT
        CALL STORE.END.ERROR
    END
RETURN

END
