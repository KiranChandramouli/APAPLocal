* @ValidationCode : MjotMTc0NDM5MjU2MTpVVEYtODoxNjg5NzQ5NjU2OTcyOklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
* @ValidationInfo : Encoding          : UTF-8
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
