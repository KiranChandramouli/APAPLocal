* @ValidationCode : Mjo2MzU0MDcwOTI6Q3AxMjUyOjE2ODIzMzEzMjA0MTU6SVRTUzotMTotMToxMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CLOS.JOINT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - start
    $INSERT I_EQUATE

    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE ;*R22 Auto conversion- end

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""

    Y.ACC.ID = COMI

    CALL OPF(FN.ACC,FV.ACC)
    CALL EB.READ.HISTORY.REC(FV.ACC,Y.ACC.ID,R.ACC,ACC.ERROR)

    CUSTOMER.ID = R.ACC<AC.JOINT.HOLDER>

    COMI = CUSTOMER.ID
