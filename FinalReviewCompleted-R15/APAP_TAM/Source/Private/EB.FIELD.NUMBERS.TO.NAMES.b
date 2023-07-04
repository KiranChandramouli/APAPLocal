* @ValidationCode : MjoxMDg1MDI0MzY2OkNwMTI1MjoxNjgwNjAyNDgwNTYzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:31:20
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
$PACKAGE APAP.TAM
* Version 2 07/06/01  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE EB.FIELD.NUMBERS.TO.NAMES(IN.FIELD.NUMBER, FIELD.NAME,ERR.MSG)
*
* Converts fields numbers (as defined in the standard selection record)
* to field names
*
* Parameters passed :
*
* Incoming  :  IN.FIELD.NUMBER    (field number to be converted - DEFAULT AF, AV)
*
*
*
* Outgoing  :  FIELD.NO        (field name, blank if not found)
*              ERR.MSG         (error message, if field not found or not
*                               a data field)
* Modification history
** 04-04-2023 R22 Auto Conversion – FM TO @FM, VM to @VM, SM to @SM
** 04-04-2023 Skanda R22 Manual Conversion - No changes
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.STANDARD.SELECTION
*
    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN
*
* ======
PROCESS:
* ======
*
* Locate field number in either the system or user fields on the standard
* selection record (the user fields are appended to the sys fields in
* GET.STANDARD.SELECTION.DETS)
*
    LOCATE FIELD.NO IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,1> SETTING POSN THEN
        FIELD.NAME = R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,POSN>
    END ELSE
        POSN = ''
    END
*
    IF FIELD.NAME EQ "LOCAL.REF" THEN
        GOSUB FIND.LOCAL.REF.NAME
    END
*
* Give an error if the field name was not found
*
    IF POSN EQ '' THEN ;* If field not found ;* R22 Auto conversion
        FIELD.NAME = '' ;* Setting to null allows enquiry to continue
        ERR.MSG = 'FIELD & NOT ON STANDARD.SELECTION RECORD':@FM:IN.FIELD.NUMBER
    END

RETURN
*
* ==================
FIND.LOCAL.REF.NAME:
* ==================
*
    WFIELD.NO = "LOCAL.REF<1,"  : VAL.SUB.NOS : ">"
    LOCATE WFIELD.NO IN R.STANDARD.SELECTION<SSL.USR.FIELD.NO,1> SETTING POS.LF THEN
        FIELD.NAME = R.STANDARD.SELECTION<SSL.USR.FIELD.NAME,POS.LF>
    END ELSE
        POSN = ''
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    ERR.MSG = ''
*
* Field number can either be a field number or field number "." value
* number or field number "." value number "." subvalue number.  Seperate
* field number from value/subvalue number
*
    IF IN.FIELD.NUMBER THEN
        FIELD.NO    = FIELD(IN.FIELD.NUMBER,'.',1)
        VAL.SUB.NOS = FIELD(IN.FIELD.NUMBER,'.',2,99)
    END ELSE
        FIELD.NO    = AF
        VAL.SUB.NOS = AV
    END
*
    FN.STANDARD.SELECTION = "F.STANDARD.SELECTION"
    F.STANDARD.SELECTION  = ""
*
    CALL CACHE.READ(FN.STANDARD.SELECTION, APPLICATION, R.STANDARD.SELECTION, ERR.MSG) ;* R22 Auto conversion
*
RETURN
*
END
