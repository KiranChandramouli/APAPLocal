* @ValidationCode : MjotMzMyNDg1MTg3OkNwMTI1MjoxNjgyNDEyMzQ0Njg1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.CHK.FX.OVR
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for TELLER VERSIONS
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : VICTOR NAVA
* PROGRAM NAME : REDO.V.CHK.FX.OVR
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                   REFERENCE                           DESCRIPTION
*10-04-2023      Conversion Tool     R22 Auto Code conversion            FM TO @FM VM TO @VM
*10-04-2023       Samaran T           R22 Manual Code conversion             No Changes

* -----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_REDO.FX.OVR.COMMON
*
    $INSERT I_F.FOREX
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.SEC.TRADE


    LOC.REF.APPL="FOREX":@FM:"MM.MONEY.MARKET":@FM:"SEC.TRADE"
    LOC.REF.FIELDS="L.LIMIT.OVR":@VM:"L.CR.USER.APAP":@VM:"L.TR.USER.APAP":@FM:"L.LIMIT.OVR":@VM:"L.CR.USER.APAP":@VM:"L.TR.USER.APAP":@FM:"L.LIMIT.OVR":@VM:"L.CR.USER.APAP":@VM:"L.TR.USER.APAP"
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.FX.LIMIT.OVR.POS  = LOC.REF.POS<1,1>
    Y.FX.CR.USER.POS =  LOC.REF.POS<1,2>
    Y.FX.TR.USER.POS =  LOC.REF.POS<1,3>

    Y.MM.LIMIT.OVR.POS  = LOC.REF.POS<2,1>
    Y.MM.CR.USER.POS =  LOC.REF.POS<2,2>
    Y.MM.TR.USER.POS =  LOC.REF.POS<2,3>

    Y.SC.LIMIT.OVR.POS  = LOC.REF.POS<3,1>
    Y.SC.CR.USER.POS =  LOC.REF.POS<3,2>
    Y.SC.TR.USER.POS =  LOC.REF.POS<3,3>

    Y.APPLICATION = APPLICATION

    BEGIN CASE
        CASE Y.APPLICATION EQ "FOREX"
            GOSUB FX.DEFAULT.PARA
        CASE Y.APPLICATION EQ "MM.MONEY.MARKET"
            GOSUB MM.DEFAULT.PARA
        CASE Y.APPLICATION EQ "SEC.TRADE"
            GOSUB SC.DEFAULT.PARA
    END CASE

RETURN
*
*

*****************
FX.DEFAULT.PARA:
*****************
    R.NEW(FX.OUR.ACCOUNT.PAY) = ''
    R.NEW(FX.OUR.ACCOUNT.REC) = ''

RETURN
*****************
MM.DEFAULT.PARA:
*****************
    R.NEW(MM.DRAWDOWN.ACCOUNT) = ''
    R.NEW(MM.PRIN.LIQ.ACCT)    = ''
    R.NEW(MM.INT.LIQ.ACCT)     = ''

RETURN

*****************
SC.DEFAULT.PARA:
*****************
    R.NEW(SC.SBS.BR.ACC.NO) = ''
RETURN
END
