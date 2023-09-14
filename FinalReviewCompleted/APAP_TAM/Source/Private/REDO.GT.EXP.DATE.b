* @ValidationCode : MjoxNDYzNDAxNDAwOkNwMTI1MjoxNjgwNzY1NTUzMzI4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 12:49:13
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
SUBROUTINE REDO.GT.EXP.DATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.GT.EXP.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to Get the Exposure date and check whether it is greater than old
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CLEARING.OUTWARD

    GOSUB PROCESS
RETURN

PROCESS:
*Get the Exposure date and check whether it is greater than old

    VAR.NEW.EXP.DATE = R.NEW(CLEAR.OUT.EXPOSURE.DATE)
    VAR.OLD.EXP.DATE = R.OLD(CLEAR.OUT.EXPOSURE.DATE)
    IF VAR.OLD.EXP.DATE GT VAR.NEW.EXP.DATE THEN
        AF = CLEAR.OUT.EXPOSURE.DATE
        ETEXT = "EB-REDO.GT.EXP.DATE"
        CALL STORE.END.ERROR
    END
RETURN
END
