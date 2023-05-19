* @ValidationCode : MjoxMTY1NDMzODM2OkNwMTI1MjoxNjg0NDA4NTQ5MjI2OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 16:45:49
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.RATE.CHANGE
*----------------------------------------------------------
* Description: This routine is validation routine for the VERSION - REDO.RATE.CHANGE,MASSIVE.INPUT and ,EXTRACT.INPUT.
*----------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RATE.CHANGE


    GOSUB PROCESS
RETURN

*------------------------------------------------------
PROCESS:
*------------------------------------------------------

    Y.EXTRACT.TYPE = R.NEW(REDO.RT.EXTRACT.TYPE)

    IF Y.EXTRACT.TYPE EQ 'AUTOMATICA' THEN
        IF R.NEW(REDO.RT.FROM.DATE) ELSE
            AF = REDO.RT.FROM.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
        IF R.NEW(REDO.RT.TO.DATE) ELSE
            AF = REDO.RT.TO.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
    END

    IF Y.EXTRACT.TYPE EQ 'MANUAL' THEN
        IF R.NEW(REDO.RT.FROM.DATE) AND R.NEW(REDO.RT.TO.DATE) EQ '' THEN
            AF = REDO.RT.TO.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
        IF R.NEW(REDO.RT.FROM.DATE) EQ '' AND R.NEW(REDO.RT.TO.DATE) THEN
            AF = REDO.RT.FROM.DATE
            ETEXT = 'AC-INP.MAND'
            CALL STORE.END.ERROR
        END
    END
RETURN
END
