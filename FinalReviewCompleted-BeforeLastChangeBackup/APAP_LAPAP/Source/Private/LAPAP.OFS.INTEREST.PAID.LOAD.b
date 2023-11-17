* @ValidationCode : MjoxMTM2ODIxMzpVVEYtODoxNjg5NzQ5NjU1OTE5OklUU1M6LTE6LTE6NDAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:15
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 400
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.OFS.INTEREST.PAID.LOAD
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023     Narmadha V             R22 Manual Conversion   No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion - STRAT
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ACCT.CR

    $INSERT I_LAPAP.OFS.INTEREST.PAID.COMMON ;*R22 Auto Conversion - END

    FN.AZ = "F.AZ.ACCOUNT"
    F.AZ = ""
    CALL OPF(FN.AZ,F.AZ)

    FN.ST = "F.STMT.ACCT.CR"
    F.ST = ""
    CALL OPF(FN.ST,F.ST)

    FN.DT = "F.DATES"
    F.DT = ""
    CALL OPF(FN.DT,F.DT)

    FN.AC = "F.ACCOUNT"
    F.AC = ""
    CALL OPF(FN.AC,F.ACC)

RETURN

END
