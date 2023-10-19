* @ValidationCode : MjotMTY5ODUzNzM3NTpDcDEyNTI6MTY4MTgyODAwMjQ4NTpJVFNTOi0xOi0xOjIwMDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.BRANCH.ID.DELIVER
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.BRANCH.ID.DELIVER
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to avoid "delivered to branch" status if the cards have not been generated yet
*Linked With  : REDO.CARD.REQUEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 1 DEC 2010    SWAMINATHAN       ODR-2010-03-0400        Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.GENERATION

    FN.REDO.CARD.GENERATION = 'F.REDO.CARD.GENERATION'
    F.REDO.CARD.GENERATION = ''
    CALL OPF(FN.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION)
    R.REDO.CARD.GENERATION = ''
    Y.CARD.REQ.ID = ID.NEW
    CALL F.READ(FN.REDO.CARD.GENERATION,Y.CARD.REQ.ID,R.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION,Y.ERR.GEN)
    IF R.REDO.CARD.GENERATION EQ '' THEN
        E='EB-CARD.DELI.TO.BRANCH'
    END
RETURN
END
