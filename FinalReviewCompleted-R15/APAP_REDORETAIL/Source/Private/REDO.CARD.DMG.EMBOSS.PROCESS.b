* @ValidationCode : MjozMTk5NzgwMTI6Q3AxMjUyOjE2ODE4MjgwMDM4NDM6SVRTUzotMTotMTotMjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -20
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.DMG.EMBOSS.PROCESS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DMG.EMBOSS.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description  : Check For mandatory fields in the REDO.CARD.DMG.EMBOSS.PROCESS
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 MAY 2011     JEEVA T               ODR-2010-03-0400        Initail Draft
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.DMG.EMBOSS

    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.STOCK.REGISTER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB PROCESS.PARA
    R.NEW(DMG.LST.TIME.ENTRY) =TODAY
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------
* Main processing section

    GOSUB CARD.TYPE.CHECK

RETURN
*--------------------------------------------------------------------------------------------------------
CARD.TYPE.CHECK:
*--------------------------------------------------------------------------------------------------------
    Y.CARD.TYPE.NEW = R.NEW(DMG.LST.CARD.TYPE)
    Y.LOST.LIST = R.NEW(DMG.LST.LOST)
    Y.DAMAGE.LIST = R.NEW(DMG.LST.DAMAGE)
    Y.COUNT = DCOUNT(Y.CARD.TYPE.NEW,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        IF Y.CARD.TYPE.NEW<1,Y.CNT> AND NOT(Y.LOST.LIST<1,Y.CNT>) AND NOT(Y.DAMAGE.LIST<1,Y.CNT>) THEN
            AF = DMG.LST.LOST
            AV = Y.CNT
            ETEXT = "EB-ONE.SHLD.ENTER"
            CALL STORE.END.ERROR
            RETURN

        END
        Y.CNT += 1
    REPEAT
RETURN
END
