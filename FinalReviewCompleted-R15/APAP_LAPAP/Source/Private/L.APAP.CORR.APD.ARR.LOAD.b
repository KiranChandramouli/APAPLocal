* @ValidationCode : Mjo3NDYwMzg1NTk6Q3AxMjUyOjE3MDUwNjc5NDgyMjM6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 19:29:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.LAPAP
**===========================================================================================================================================
*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CORR.APD.ARR.LOAD
**===========================================================================================================================================
**  This routine is developed to update AA.PROCESS.DETAILS. Where the AAA record has some missing AA.ARR.<<PROPERTY>> records in NAU.
**  Some of the child activities linked in AA.RR.CONTROL is not available in NAU
**
**  Correction will done to loop through AA.RR.CONTROL and remove the AAA which are missing in NAU
**  AA.PROCESS.DETAILS will be validated and missing AA.ARR.<<PROPERTY>> link will be removed
**  Then delete the MASTER activity.
*
**===========================================================================================================================================
*** Modification history
*--------------------------
*   DATE          WHO                 REFERENCE               DESCRIPTION
*   12-01-2024    Santosh        R22 MANUAL CONVERSION        BP removed, added I_ in COMMON file
**===========================================================================================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PROCESS.DETAILS
    $INSERT I_AA.RR.CONTROL
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_L.APAP.CORR.APD.ARR.COMMON
**===========================================================================================================================================

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AAA$NAU = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
    F.AAA$NAU = ''
    CALL OPF(FN.AAA$NAU,F.AAA$NAU)

    FN.AA.ARR.STATUS = 'F.AA.ARRANGEMENT.STATUS'
    F.AA.ARR.STATUS = ''
    CALL OPF(FN.AA.ARR.STATUS,F.AA.ARR.STATUS)

    FN.APD = 'F.AA.PROCESS.DETAILS'
    FV.APD = ''
    CALL OPF(FN.APD,FV.APD)

    FN.RR.CONTROL = "F.AA.RR.CONTROL"
    F.RR.CONTROL = ""
    CALL OPF(FN.RR.CONTROL, F.RR.CONTROL)

    FN.SAVEDLISTS = '&SAVEDLISTS&';
    FV.SAVEDLISTS = '';
    CALL OPF(FN.SAVEDLISTS,FV.SAVEDLISTS)
*    CALL F.READ(FN.SAVEDLISTS,'SL.APD.NAU',R.SL,FV.SAVEDLISTS,ERROR.SL)
    IDVAR.1 = 'SL.APD.NAU' ;* R22 UTILITY AUTO CONVERSION
    CALL F.READ(FN.SAVEDLISTS,IDVAR.1,R.SL,FV.SAVEDLISTS,ERROR.SL);* R22 UTILITY AUTO CONVERSION
    IF R.SL THEN
        AA.ACCOUNT.LIST = R.SL;
    END
* OPEN '&SAVEDLISTS&' TO TMP.SAVE ELSE NULL
*READ AA.ACCOUNT.LIST FROM TMP.SAVE, 'SL.APD.NAU' ELSE NULL


RETURN



END
