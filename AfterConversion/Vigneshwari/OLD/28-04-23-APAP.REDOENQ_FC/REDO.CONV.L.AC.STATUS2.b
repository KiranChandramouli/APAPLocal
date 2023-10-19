* @ValidationCode : MjoxMzk5Njc2NTEzOkNwMTI1MjoxNjgyMDczMzc5ODEwOklUU1M6LTE6LTE6LTg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.L.AC.STATUS2
*---------------------------------------------------
* Description: This routine is a conversion routine for the enquiry
* to display the L.AC.STATUS2.
*---------------------------------------------------
* Modification History
* DATE         NAME          Reference                   REASON
* 10-02-2012  H Ganesh      PACS00194856 - CR.22      Initial creation
*
* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    OUT.DATA =  O.DATA
    IF OUT.DATA ELSE
        RETURN
    END

    VAR.USER.LANG  =  R.USER<EB.USE.LANGUAGE>
    VAR.VIRTUAL.TABLE = "L.AC.STATUS2"
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
        O.DATA = VIRTUAL.TABLE.VALUES<POS,VAR.USER.LANG>
        IF O.DATA ELSE
            O.DATA =  VIRTUAL.TABLE.VALUES<POS,1>
        END
    END

RETURN
END
