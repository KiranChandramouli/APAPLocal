* @ValidationCode : MjoyMzIxNzMzMzE6VVRGLTg6MTY4OTc0OTY1Njk4NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Jul 2023 12:24:16
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PURGAL.OFSREQUESTD.SELECT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file
* 14-07-2023    Narmadha V             R22 Manual Conversion     No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_LAPAP.PURGAL.OFSREQUESTD.COMMON
    $INSERT I_F.OFS.REQUEST.DETAIL ;*R22 Auto Conversion - END


    SELECT.STATEMENT = "SELECT F.OFS.REQUEST.DETAIL WITH @ID UNLIKE ..." : Y.LAST.DAY : "..."
    PURGA.LIST = ""
    LIST.NAME = ""
    SELECTED = ""
    SYSTEM.RETURN.CODE = ""
    CALL EB.READLIST(SELECT.STATEMENT,PURGA.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    CALL BATCH.BUILD.LIST('',PURGA.LIST)

END
