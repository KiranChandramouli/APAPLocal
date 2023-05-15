* @ValidationCode : MjotNzAwNTgwNDA4OkNwMTI1MjoxNjgyMzE1NDQ2ODQ4OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:20:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.VERIFY.CATEGORY(ACC,CTG)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.VERIFY.CATEGORY
* Date           : 2018-05-04
* Item ID        : -----------
*========================================================================
* Brief description :
* -------------------
* This a routine verify what kind of category have any account and return
* some value like 0 or 1 to indicated the expesific categories.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-05-04     Richard HC                Initial Development
*========================================================================
* Content summary :
* =================
* Table name     : ACCOUNT
* Auto Increment : N/A
* Views/versions : ALL VERSION REQUIRED
* EB record      : LAPAP.VERIFY.CATEGORY
* Routine        : LAPAP.VERIFY.CATEGORY
*========================================================================

****    D O  N O T  M O D I F Y  T H I S  R O U T I N E    ****

* A lot of requeriments could be depending to this program if you unknown
* all of those previous soluctions, take as sugerence doesn't edit any
* fragment of code content here. In case that you need solve particular
* cases, please kindly create a new soluction independent to this one.
*------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT     ;*R22 AUTO CODE CONVERSION.END

    GOSUB INIT
    GOSUB PROCESS

INIT:
*----
    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)
RETURN

PROCESS:
*-------
    CALL F.READ(FN.ACC,ACC,R.ACC,F.ACC,ACC.ERR)
    CATEGORY = R.ACC<AC.CATEGORY>
    IF CATEGORY GE 6000 AND CATEGORY LE 6599 THEN
        CTG = 1
    END
    IF CATEGORY GE 6600 AND CATEGORY LE 6699 THEN
        CTG = 2
    END ELSE
        CTG = 0
    END

RETURN

END
