* @ValidationCode : MjotMTc0Mzg4NjUzMTpVVEYtODoxNjg0MjIyODE0NDY3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:14
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

*========================================================================
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.REGEXs(string,code)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.REGEXs
* Date           : 2018-11-29
* Item ID        : -----------
*========================================================================
* Brief description :
* -------------------
* This program allow verify string chains, returning as value 1 in
* case that found any special charecter.
*========================================================================
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-11-29     Richard HC        Initial Development
* 24-APR-2023   Conversion tool    R22 Auto conversion      BP is removed in Insert File, INCLUDE to INSERT
* 24-APR-2023    Narmadha V        R22 Manual Conversion    No Changes
*========================================================================
* Content summary :
* =================
* Table name     :N/A
* Auto Increment :N/A
* Views/versions :N/A
* EB record      :LAPAP.REGEXs
* Routine        :LAPAP.REGEXs
*========================================================================

****    D O  N O T  M O D I F Y  T H I S  R O U T I N E    ****

* A lot of requeriments could be depending to this program if you unknown
* all of those previous soluctions, take as sugerence doesn't edit any
* fragment of code content here. In case that you need solve particular
* cases, please kindly create a new soluction independent to this one.
*------------------------------------------------------------------------


    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE ;*R22 Auto conversion - END


    return.code = 0
    REGEX = "0123456789'~`!@#$%^&*()_+|}{:?><,./;\[]+-*Ã�Ã‰Ã�Ã“ÃšÃ‘Ã¡Ã©Ã­Ã³ÃºÃ±"

    SIZE = LEN(string)
    FOR A = SIZE TO 1 STEP -1

        ARG = string[A,1]
        FINDSTR ARG IN REGEX SETTING POS THEN
            return.code = 1
        END

    NEXT A

    code = return.code

RETURN

END
