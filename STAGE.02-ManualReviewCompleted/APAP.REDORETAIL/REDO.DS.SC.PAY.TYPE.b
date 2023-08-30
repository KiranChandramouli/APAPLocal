* @ValidationCode : MjotNDA4MzU4NDgwOkNwMTI1MjoxNjgxOTA1NjgwNjMwOklUU1M6LTE6LTE6LTg6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.SC.PAY.TYPE(Y.OUT.VAR)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.DS.SC.PAY.TYPE
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the value from EB.LOOKUP TABLE
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION                NO CAHNGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER

    GOSUB PROCESS

RETURN

*********
PROCESS:
*********

    Y.LOOKUP.ID   = "PAY.TYPE"
    Y.LOOOKUP.VAL = Y.OUT.VAR
    Y.DESC.VAL    = ''
    CALL APAP.REDOEB.REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2) ;* MANAUL R22 CODE CONVERSION

    Y.OUT.VAR = Y.DESC.VAL

RETURN

END
