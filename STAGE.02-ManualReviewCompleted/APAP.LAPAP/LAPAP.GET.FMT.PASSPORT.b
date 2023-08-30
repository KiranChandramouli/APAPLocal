* @ValidationCode : Mjo1NzgwNTI4OTY6Q3AxMjUyOjE2ODIwNjk0MzQwMzE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:00:34
* @ValidationInfo : Encoding          : Cp1252
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
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GET.FMT.PASSPORT(NO.PASSPORT, NO.FMT.PASSPORT)

    $INSERT I_COMMON
    $INSERT I_EQUATE
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.GET.FORMATED.PASSPORT
* Date           : 2018-05-23
* Item ID        : CN008754
*========================================================================
* Brief description :
* -------------------
* This routine retorned the formated passport (COUNTRY CODE + PASSPORT NUMBER)
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-05-23     Anthony Martinez  Initial Development
*
* 21-APR-2023   Conversion tool    R22 Auto conversion      BP is removed in Insert File
* 21-APR-2023    Narmadha V           R22 Manual Conversion    No Changes
*========================================================================

    GOSUB PROCESS

PROCESS:
*-------
    NO.FMT.PASSPORT = SUBSTRINGS(NO.PASSPORT, LEN(NO.PASSPORT)-1, 2) : SUBSTRINGS(NO.PASSPORT, 0, LEN(NO.PASSPORT)-3)

RETURN
*-------
