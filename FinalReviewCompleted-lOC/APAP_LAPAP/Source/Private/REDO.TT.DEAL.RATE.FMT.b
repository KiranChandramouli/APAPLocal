* @ValidationCode : MjotMzc0MjI1MDQ4OkNwMTI1MjoxNjgyNDMwMDQxMTg5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 19:10:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.TT.DEAL.RATE.FMT(YFIELD.NME)

***********************************************************************************
* Description: This deal slip routine will validate the deal rate in the TELLER.
*
* Dev by : V.P.Ashokkumar
*
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
************************************************************************************
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER ;*AUTO R22 CODE CONVERSION END

    IF YFIELD.NME NE 'Y.DEAL.RATE' THEN
        RETURN
    END

    Y.DEAL.RATE = R.NEW(TT.TE.DEAL.RATE)
    IF INDEX(Y.DEAL.RATE,".",1) THEN
        YFIELD.NME = FMT(Y.DEAL.RATE,'R2#7')
    END ELSE
        YFIELD.NME = FMT(Y.DEAL.RATE,'R2#7')
    END
RETURN
END
