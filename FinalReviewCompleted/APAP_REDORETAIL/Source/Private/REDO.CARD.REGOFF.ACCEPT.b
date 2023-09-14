* @ValidationCode : MjotODI5MzkwODM0OkNwMTI1MjoxNjgxODI4MDA1ODEyOklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.REGOFF.ACCEPT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REGOFF.ACCEPT
*--------------------------------------------------------------------------------------------------------
*Description  : This is a check routine to default Reg off quantity
*Linked With  : Application REDO.CARD.REQUEST,REGOFF
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 18 SEP 2010    Swaminathan.S.R       ODR-2010-03-0400        Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
***************
PROCESS.PARA:
***************

    Y.TOT.CARD.TYPES = DCOUNT(R.NEW(REDO.CARD.REQ.CARD.TYPE),@VM)
    Y.INIT.COUNT = 1
    LOOP
    WHILE Y.INIT.COUNT LE Y.TOT.CARD.TYPES
        R.NEW(REDO.CARD.REQ.REGOFF.ACCEPTQTY)<1,Y.INIT.COUNT> = R.NEW(REDO.CARD.REQ.BRANCH.ORDERQTY)<1,Y.INIT.COUNT>
        Y.INIT.COUNT +=1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------------------
END
