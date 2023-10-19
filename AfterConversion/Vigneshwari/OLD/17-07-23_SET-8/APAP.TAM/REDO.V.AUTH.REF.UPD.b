* @ValidationCode : MjotMjA3Nzg2MzAwOTpDcDEyNTI6MTY4OTU4MjMxMTExNzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Jul 2023 13:55:11
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
SUBROUTINE REDO.V.AUTH.REF.UPD
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.AUTH.REF.UPD
* ODR NO      : ODR-2009-10-0315
*----------------------------------------------------------------------
*DESCRIPTION: This Input routine will update TFS id to transaction.ref field
*in AZ.ACCOUNT
*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & T24.FUNDS.SERVICE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*13.05.2010  H GANESH     ODR-2009-12-0275  INITIAL CREATION
*01.11.2011  S.SUDHARSANAN CR.18             MODIFY THE LOGIC
*13/07/2023  CONVERSION TOOL             AUTO R22 CODE CONVERSION-FM TO @FM
*13/07/2023   VIGNESHWARI	             MANUAL R22 CODE CONVERSION- NOCHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.AZ.ACCOUNT.NAU='F.AZ.ACCOUNT$NAU'
    F.AZ.ACCOUNT.NAU=''

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''

    FN.REDO.TFS.PROCESS='F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS = ''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL OPF(FN.AZ.ACCOUNT.NAU,F.AZ.ACCOUNT.NAU)
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)
RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="AZ.ACCOUNT":@FM:"T24.FUND.SERVICES"
    LOC.REF.FIELDS='L.AZ.REF.NO':@FM:'L.TT.PROCESS'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AZ.REF.NO=LOC.REF.POS<1,1>
    POS.L.TT.PROCESS = LOC.REF.POS<2,1>

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        Y.REDO.TFS.PROCESS.ID = R.NEW(TFS.LOCAL.REF)<1,POS.L.TT.PROCESS>
        CALL F.READ(FN.REDO.TFS.PROCESS,Y.REDO.TFS.PROCESS.ID,R.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS,PRO.ERR)
        Y.VAR.ACCOUNT = R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>
    END
    R.AZ.ACCOUNT = ''
    CALL F.READ(FN.AZ.ACCOUNT,Y.VAR.ACCOUNT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

    IF R.AZ.ACCOUNT THEN
        R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.REF.NO>=ID.NEW
        CALL F.WRITE(FN.AZ.ACCOUNT,Y.VAR.ACCOUNT,R.AZ.ACCOUNT)
    END ELSE
        R.AZ.ACCOUNT.NAU = ''
        CALL F.READ(FN.AZ.ACCOUNT.NAU,Y.VAR.ACCOUNT,R.AZ.ACCOUNT.NAU,F.AZ.ACCOUNT.NAU,AZ.ERR.NAU)
        IF R.AZ.ACCOUNT.NAU THEN
            R.AZ.ACCOUNT.NAU<AZ.LOCAL.REF,POS.L.AZ.REF.NO>=ID.NEW
            CALL F.WRITE(FN.AZ.ACCOUNT.NAU,Y.VAR.ACCOUNT,R.AZ.ACCOUNT.NAU)
        END
    END
RETURN
*-----------------------------------------------------------------------------------------
END
