* @ValidationCode : Mjo0NDgyNjQ3MTM6Q3AxMjUyOjE2ODIzMzEzMjIxNzc6SVRTUzotMTotMToyMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.REC.SLA.DAYS.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.FRONT.CLAIMS
    $INSERT I_F.REDO.ISSUE.CLAIMS

    FN.CL = "F.REDO.ISSUE.CLAIMS"
    FV.CL = ""
    R.CL = ""
    CL.ERR = ""
    CALL OPF(FN.CL,FV.CL)

    Y.CL.ID = O.DATA
    Y.CLAIM.SLA = ""
    DAYS = "C"

    CALL F.READ(FN.CL, Y.CL.ID, R.CL, FV.CL, CL.ERR)
    CALL GET.LOC.REF("REDO.ISSUE.CLAIMS", "CLAIM.SLA",LR.POS)
    Y.CLAIM.SLA = R.CL<ISS.CL.LOCAL.REF,LR.POS>
    IF Y.CLAIM.SLA EQ ""  THEN
        Y.ISS.CL.OPENING.DATE = R.CL<ISS.CL.OPENING.DATE>
        Y.ISS.CL.DATE.RESOLUTION = R.CL<ISS.CL.DATE.RESOLUTION>
        CALL CDD("",Y.ISS.CL.OPENING.DATE,Y.ISS.CL.DATE.RESOLUTION,DAYS)
        Y.CLAIM.SLA = DAYS
    END

    O.DATA = Y.CLAIM.SLA
RETURN

END
