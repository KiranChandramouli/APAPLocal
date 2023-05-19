* @ValidationCode : Mjo3ODI2MDY3NTk6Q3AxMjUyOjE2ODI0MjIxODQ2Njk6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:59:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.S.CALL.GET.SAP.ACCT(Y.ACCT.DET,Y.LINE.DET)
* -------------------------------------------------------------------------------------------------
* Description           : This is call routine to return line desc for az deposits
*
* Developed By          : Prabhu N
* Development Reference : CA01
* Attached To           : NA
* Attached As           : NA
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : AZ.ACC.ID
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* Include files
* CA01                   Prabhu N                       20140916              As Per the CR request
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.GENERIC.AZ.LINE.DESC
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.RE.STAT.REP.LINE


    Y.ACCT.ID=Y.ACCT.DET<1>
    YCRF.TYPE=Y.ACCT.DET<2>

    CALL F.READ(FN.EB.CONT.BAL.CA,Y.ACCT.ID,R.EB.CONTRACT.BALANCES,F.EB.CONT.BAL.CA,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY    = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART   = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE.CA,Y.LINE,R.LINE,F.RE.STAT.REP.LINE.CA,REP.ERR)
        Y.LINE.DET<1>= R.LINE<RE.SRL.DESC,1>
    END
RETURN
END
