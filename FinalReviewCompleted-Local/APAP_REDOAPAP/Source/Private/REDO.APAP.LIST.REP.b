* @ValidationCode : MjotMTgzMTY2MzQ0NzpDcDEyNTI6MTY4MDY3OTk3ODUxMTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:02:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.LIST.REP
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME    ODR.NUMBER       REASON
* 08-06-2011   MANJU   PACS00074021     Initial creation
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION FM TO @FM
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.RESTRICTIVE.LIST
    GOSUB PROCESS
RETURN
**********
PROCESS:
*********
    VAR.USER.LANG  =  R.USER<EB.USE.LANGUAGE>
    OUT.DATA = O.DATA
    VAR.VIRTUAL.TABLE = "LIST"
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
        VAL.LIST.REST = ''
        VAL.LIST.REST = VIRTUAL.TABLE.VALUES<POS,VAR.USER.LANG>
        IF NOT(VAL.LIST.REST) THEN
            O.DATA = VIRTUAL.TABLE.VALUES<POS,1>
        END ELSE
            O.DATA = VAL.LIST.REST
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
END
