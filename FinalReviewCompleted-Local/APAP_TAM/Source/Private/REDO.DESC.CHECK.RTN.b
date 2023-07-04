* @ValidationCode : MjoxOTY5NDI3NTEyOkNwMTI1MjoxNjgwNzczNjY4MzIwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
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
SUBROUTINE REDO.DESC.CHECK.RTN
******************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.DESC.CHECK.RTN.DETAILS
*-----------------------------------------------------------------------------
*Description       : L.AC.OTHER.DETS can accept user input only when
*                   L.AC.PROP.USE is selected as OTHERS(SPECIFY).Otherwise
*                   this  Routine Returns Error Message to user
*-----------------------------------------------------------------------------

*Modification Details:
*=====================
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*----------
INITIALISE:
*----------
    LREF.APP=''
    LREF.FIELDS=''
    LREF.POS=''
    L.AC.PROP.USE.POS=''
    L.AC.OTHER.DETS.POS=''
RETURN

*--------
PROCESS:
*--------

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.PROP.USE':@VM:'L.AC.OTHER.DETS'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.PROP.USE.POS = LREF.POS<1,1>
    L.AC.OTHER.DETS.POS=LREF.POS<1,2>

*Checks whether the value of OTHER.DETAILS field is Null or not
*When value of OTHER.DETAILS is not Null AND Value of PROPOSE.USE.ACC
*is not OTHERS THEN it Displays Error

    IF R.NEW(AC.LOCAL.REF)<1, L.AC.PROP.USE.POS> NE 'OTHERS(SPECIFY)' AND R.NEW(AC.LOCAL.REF)<1,L.AC.OTHER.DETS.POS> NE '' THEN

        AF=AC.LOCAL.REF
        AV=L.AC.OTHER.DETS.POS
        ETEXT="EB-REDO.DESC.NOT.REQUIRED"
        CALL STORE.END.ERROR
    END
    IF R.NEW(AC.LOCAL.REF)<1, L.AC.PROP.USE.POS> EQ 'OTHERS(SPECIFY)' AND R.NEW(AC.LOCAL.REF)<1,L.AC.OTHER.DETS.POS> EQ '' THEN
        AF=AC.LOCAL.REF
        AV=L.AC.OTHER.DETS.POS
        ETEXT="AC-INP.MAND"
        CALL STORE.END.ERROR
    END

RETURN
END
