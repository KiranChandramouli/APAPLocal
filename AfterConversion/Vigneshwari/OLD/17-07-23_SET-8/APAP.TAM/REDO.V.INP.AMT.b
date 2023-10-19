* @ValidationCode : MjotMjA4NTMyMzE6Q3AxMjUyOjE2ODk1ODMxMDQ5NDM6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Jul 2023 14:08:24
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
SUBROUTINE REDO.V.INP.AMT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.INP.AMT
* ODR NO : ODR-2010-08-0017
*----------------------------------------------------------------------
*DESCRIPTION: This is the Routine for check the amount value is equal to REDO.TFS.PROCESS to
* the T24.FUND.SERVICES,COLLECT.AA.REPAY amount field value. through the error, if it is mismatched
* It is INPUT Routine

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.PART.TFS.PROCESS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE WHO REFERENCE DESCRIPTION
*10.07.2010 S SUDHARSANAN ODR-2010-08-0017 INITIAL CREATION
*DATE			         AUTHOR				Modification                            DESCRIPTION
*13/07/2023	             CONVERSION TOOL    AUTO R22 CODE CONVERSION			 VM TO @VM,FM TO @FM
*13/07/2023	             VIGNESHWARI	    MANUAL R22 CODE CONVERSION		          NOCHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.PART.TFS.PROCESS
    $INSERT I_F.T24.FUND.SERVICES
    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.REDO.PART.TFS.PROCESS = 'F.REDO.PART.TFS.PROCESS'
    F.REDO.PART.TFS.PROCESS = ''
    CALL OPF(FN.REDO.PART.TFS.PROCESS,F.REDO.PART.TFS.PROCESS)

    LOC.REF.APPLICATION="T24.FUND.SERVICES"
    LOC.REF.FIELDS='L.TFS.DUE.PRS'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.TFS.DUE.PRS=LOC.REF.POS<1,1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*Checking TFS amount value equal with the local table amount value

    Y.REDO.PART.TFS.PROCESS.ID = R.NEW(TFS.LOCAL.REF)<1,POS.L.TFS.DUE.PRS>
    CALL F.READ(FN.REDO.PART.TFS.PROCESS,Y.REDO.PART.TFS.PROCESS.ID,R.REDO.PART.TFS.PROCESS,F.REDO.PART.TFS.PROCESS,PRO.ERR)
    Y.COUNT=DCOUNT(R.REDO.PART.TFS.PROCESS<PAY.PART.TFS.AMOUNT>,@VM)
    Y.TFS.COUNT = DCOUNT(R.NEW(TFS.AMOUNT),@VM)
    IF Y.COUNT EQ Y.TFS.COUNT THEN
        FOR Y.CNT = 1 TO Y.COUNT
            Y.TFS.AMT = R.NEW(TFS.AMOUNT)<1,Y.CNT>
            Y.AMT = R.REDO.PART.TFS.PROCESS<PAY.PART.TFS.AMOUNT,Y.CNT>
            IF Y.TFS.AMT NE Y.AMT THEN
                AF=TFS.AMOUNT
                AV=Y.CNT
                ETEXT='TT-TFS.AMOUNT.CHECK':@FM:Y.AMT
                CALL STORE.END.ERROR
            END
        NEXT Y.CNT
    END
RETURN
END
