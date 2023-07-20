* @ValidationCode : MjotNzk5NTY2NjQyOlVURi04OjE2ODk4MzExMDI2MzQ6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Jul 2023 11:01:42
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
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.PRE.PEND.ACT.LOAD
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 14-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file,
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion -START
    $INSERT  I_EQUATE
    $INSERT  I_BATCH.FILES
    $INSERT  I_TSA.COMMON
    $INSERT  I_F.DATES
    $INSERT  I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT  I_F.USER
    $INSERT  I_F.FUNDS.TRANSFER
    $INSERT  I_F.REDO.H.REPORTS.PARAM
    $INSERT  I_F.ST.L.APAP.AAA.PENDIENTENAU
    $INSERT  I_F.AA.ARRANGEMENT
    $INSERT  I_LAPAP.PRE.PEND.ACT.COMMON ;*R22 Manual Conversion - END

    GOSUB OPEN.FILES

RETURN
OPEN.FILES:

    FN.USER = "F.USER"
    F.USER = ""
    CALL OPF (FN.USER,F.USER)

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER = ""
    CALL OPF (FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ARRANGEMENT.ACTIVITY = "F.AA.ARRANGEMENT.ACTIVITY"
    F.ARRANGEMENT.ACTIVITY = ""
    CALL OPF(FN.ARRANGEMENT.ACTIVITY,F.ARRANGEMENT.ACTIVITY)
    FN.DATES = 'F.DATES'; F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM  = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    FN.FUNDS.TRANSFER$NAU = "F.FUNDS.TRANSFER$NAU"
    F.FUNDS.TRANSFER$NAU = ""
    CALL OPF(FN.FUNDS.TRANSFER$NAU,F.FUNDS.TRANSFER$NAU)

    FN.ARRANGEMENT.ACTIVITY$NAU = "F.AA.ARRANGEMENT.ACTIVITY$NAU"
    F.ARRANGEMENT.ACTIVITY$NAU  = ""
    CALL OPF (FN.ARRANGEMENT.ACTIVITY$NAU,F.ARRANGEMENT.ACTIVITY$NAU)

    FN.ST.L.APAP.AAA.PENDIENTENAU = "F.ST.L.APAP.AAA.PENDIENTENAU"
    F.ST.L.APAP.AAA.PENDIENTENAU = ""
    CALL OPF(FN.ST.L.APAP.AAA.PENDIENTENAU,F.ST.L.APAP.AAA.PENDIENTENAU)

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    Y.FECHA.ACTUAL = TODAY

RETURN

END
