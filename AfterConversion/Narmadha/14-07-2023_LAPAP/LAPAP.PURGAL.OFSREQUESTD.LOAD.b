* @ValidationCode : MjotMTc0NDM5MjU2MTpVVEYtODoxNjg5MzIxNzA2ODEyOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 13:31:46
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PURGAL.OFSREQUESTD.LOAD
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion     No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion - START
    $INSERT I_EQUATE
    $INSERT I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT I_F.OFS.REQUEST.DETAIL
    $INSERT I_F.DATES ;*R22 Auto Conversion -END

    FN.REQ.PURGA = "F.OFS.REQUEST.DETAIL"
    F.REQ.PURGA = ""
    CALL OPF(FN.REQ.PURGA,F.REQ.PURGA)

    Y.LAST.DAY = R.DATES(EB.DAT.JULIAN.DATE)[3,5]

END
