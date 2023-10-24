* @ValidationCode : MjoxMTM2MTIzMDM5OkNwMTI1MjoxNjgxOTA1NjgxNTg0OklUU1M6LTE6LTE6LTY6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.ST.TREASURY(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.ST.SELLERS
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE

    GOSUB PROCESS
RETURN

PROCESS:
********

    ST.OVERRIDE = R.NEW(SC.SBS.OVERRIDE)
    IF ST.OVERRIDE NE '' THEN
        CHANGE @VM TO @FM IN ST.OVERRIDE
        Y.COUNT = DCOUNT(ST.OVERRIDE,@FM)
        INIT = 1
        LOOP
        WHILE INIT LE Y.COUNT
            REMOVE ST.OVERRIDE.1 FROM ST.OVERRIDE SETTING POS
            FINDSTR '*' IN ST.OVERRIDE.1 SETTING POS.1 THEN
                Y.TRA = FIELD(ST.OVERRIDE.1,'*',3,1)
            END
            INIT += 1
        REPEAT
    END
    Y.RET = Y.TRA
RETURN
END
